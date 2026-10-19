// Shared helpers for the Jarvis hooks. Cross-platform Node: no bash, jq, or OS-specific utilities.
import { existsSync, readFileSync, readdirSync } from 'node:fs';
import { join, dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

export const PROJECT_DIR = process.env.CLAUDE_PROJECT_DIR
  || resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');

export const STAMP_FILE = join(PROJECT_DIR, '.claude', 'hooks', '.session-timestamp');
export const SESSIONS_DIR = join(PROJECT_DIR, 'context', 'memory', 'sessions');

export function localDateStr(d) {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

// The user's context folder: context/{name}/ after /get-to-know-me, context/me/ before.
export function userContextFolder() {
  const ctx = join(PROJECT_DIR, 'context');
  let dirs = [];
  try {
    dirs = readdirSync(ctx, { withFileTypes: true })
      .filter((e) => e.isDirectory() && e.name !== 'memory')
      .map((e) => e.name);
  } catch { /* no context/ yet */ }
  return dirs.find((n) => n !== 'me') || (dirs.includes('me') ? 'me' : null);
}

// Last 3 days of session logs, oldest label first in the text block.
export function recentSessionLogs() {
  const labels = ['TODAY', 'YESTERDAY', '2 DAYS AGO'];
  let out = '';
  for (let offset = 0; offset < 3; offset++) {
    const d = new Date();
    d.setDate(d.getDate() - offset);
    const day = localDateStr(d);
    const file = join(SESSIONS_DIR, `${day}.md`);
    if (existsSync(file)) {
      const body = readFileSync(file, 'utf8').replace(/\n+$/, '');
      out += `\n--- ${labels[offset]}'S WORK LOG (${day}) ---\n${body}\n--- END WORK LOG ---\n`;
    }
  }
  return out;
}

export function fail(hook, err) {
  // Never break a session over a hook failure, but fail loudly, not silently.
  process.stderr.write(`${hook} hook error: ${err && err.message ? err.message : err}\n`);
}
