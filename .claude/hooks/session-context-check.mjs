#!/usr/bin/env node
// SessionStart: inject recent session logs + check goals freshness
import { existsSync, statSync, mkdirSync, closeSync, openSync, utimesSync } from 'node:fs';
import { join, dirname } from 'node:path';
import {
  PROJECT_DIR, STAMP_FILE, SESSIONS_DIR, localDateStr, userContextFolder, recentSessionLogs, fail
} from './_shared.mjs';

try {
  let context = recentSessionLogs();

  const folder = userContextFolder();
  const goals = folder && join(PROJECT_DIR, 'context', folder, 'goals.md');
  if (goals && existsSync(goals)) {
    const mtimeMs = statSync(goals).mtimeMs;
    const days = Math.floor((Date.now() - mtimeMs) / 86400000);
    if (days > 30) {
      context += `goals.md is ${days} days old (last updated ${localDateStr(new Date(mtimeMs))}). Consider asking if goals need updating.\n`;
    }
  }

  // Session timestamp for the Stop hook
  mkdirSync(SESSIONS_DIR, { recursive: true });
  mkdirSync(dirname(STAMP_FILE), { recursive: true });
  closeSync(openSync(STAMP_FILE, 'a'));
  const now = new Date();
  utimesSync(STAMP_FILE, now, now);

  if (context) process.stdout.write(context);
} catch (err) {
  fail('session-context-check', err);
}
process.exit(0);
