#!/bin/bash
# PostCompact: Re-inject critical context after compaction
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
CONTEXT=""

# Find user context folder (anything in context/ that's not memory/)
USER_CONTEXT=$(find "$PROJECT_DIR/context" -maxdepth 1 -type d ! -name "context" ! -name "memory" 2>/dev/null | head -1)
USER_FOLDER=$(basename "$USER_CONTEXT" 2>/dev/null)

if [ -n "$USER_FOLDER" ] && [ "$USER_FOLDER" != "me" ]; then
  CONTEXT="Re-read these files to restore context:\n1. context/${USER_FOLDER}/goals.md — current priorities\n2. context/${USER_FOLDER}/brand-voice.md — how to write as them"
else
  CONTEXT="Re-read context/me/goals.md and context/me/brand-voice.md to restore context."
fi

# Inject last 3 days of session logs
for OFFSET in 0 1 2; do
  DAY=$(date -v-${OFFSET}d '+%Y-%m-%d' 2>/dev/null || date -d "-${OFFSET} days" '+%Y-%m-%d')
  MEMORY_FILE="$PROJECT_DIR/context/memory/sessions/${DAY}.md"
  if [ -f "$MEMORY_FILE" ]; then
    if [ "$OFFSET" -eq 0 ]; then
      LABEL="TODAY"
    elif [ "$OFFSET" -eq 1 ]; then
      LABEL="YESTERDAY"
    else
      LABEL="2 DAYS AGO"
    fi
    CONTEXT="${CONTEXT}\n\n--- ${LABEL}'S WORK LOG (${DAY}) ---\n$(cat "$MEMORY_FILE")\n--- END WORK LOG ---"
  fi
done

printf '%b' "$CONTEXT"
exit 0
