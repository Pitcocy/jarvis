#!/usr/bin/env node
// Stop: block if content was created but today's session log wasn't updated
import { existsSync, statSync, readdirSync } from 'node:fs';
import { join, relative, sep } from 'node:path';
import { PROJECT_DIR, STAMP_FILE, SESSIONS_DIR, localDateStr, fail } from './_shared.mjs';

try {
  if (!existsSync(STAMP_FILE)) process.exit(0);
  const sessionStart = statSync(STAMP_FILE).mtimeMs;

  const skipNames = new Set(['.DS_Store', '.gitkeep', 'CLAUDE.md']);
  const newOutputs = [];
  const walk = (dir) => {
    let entries;
    try { entries = readdirSync(dir, { withFileTypes: true }); } catch { return; }
    for (const entry of entries) {
      const full = join(dir, entry.name);
      if (entry.isDirectory()) {
        if (entry.name !== '.claude') walk(full);
      } else if (entry.isFile() && !skipNames.has(entry.name)) {
        try {
          if (statSync(full).mtimeMs > sessionStart) newOutputs.push(full);
        } catch { /* file vanished mid-walk */ }
      }
    }
  };

  // content/, clients/, projects/ + the user's context folders (not memory/)
  for (const name of ['content', 'clients', 'projects']) walk(join(PROJECT_DIR, name));
  try {
    for (const e of readdirSync(join(PROJECT_DIR, 'context'), { withFileTypes: true })) {
      if (e.isDirectory() && e.name !== 'memory') walk(join(PROJECT_DIR, 'context', e.name));
    }
  } catch { /* no context/ yet */ }

  if (newOutputs.length === 0) process.exit(0);

  const today = localDateStr(new Date());
  const memoryFile = join(SESSIONS_DIR, `${today}.md`);
  if (existsSync(memoryFile) && statSync(memoryFile).mtimeMs > sessionStart) {
    process.stdout.write('Reminder: Did any decisions, ideas, or learnings come up this session? If so, log them to context/memory/decisions/, context/memory/ideas/, or context/memory/learnings/ before ending.');
    process.exit(0);
  }

  const fileList = newOutputs.slice(0, 5)
    .map((f) => relative(PROJECT_DIR, f).split(sep).join('/'))
    .join('\n');
  process.stdout.write(JSON.stringify({
    decision: 'block',
    reason: `You created/updated ${newOutputs.length} file(s) this session but did not log to context/memory/sessions/${today}.md. Log the work before ending.\nFiles:\n${fileList}`
  }, null, 2));
} catch (err) {
  fail('stop-memory-check', err);
}
process.exit(0);
