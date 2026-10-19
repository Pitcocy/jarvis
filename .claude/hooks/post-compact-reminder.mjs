#!/usr/bin/env node
// SessionStart (matcher "compact"): re-inject critical context after compaction
import { userContextFolder, recentSessionLogs, fail } from './_shared.mjs';

try {
  const folder = userContextFolder() || 'me';
  let context = `Re-read these files to restore context:\n1. context/${folder}/goals.md: current priorities\n2. context/${folder}/brand-voice.md: how to write as them\n`;
  context += recentSessionLogs();
  process.stdout.write(context);
} catch (err) {
  fail('post-compact-reminder', err);
}
process.exit(0);
