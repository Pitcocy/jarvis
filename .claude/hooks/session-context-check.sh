#!/bin/bash
# SessionStart: Inject recent session logs + check goals freshness
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
CONTEXT=""

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
    CONTEXT="${CONTEXT}\n--- ${LABEL}'S WORK LOG (${DAY}) ---\n$(cat "$MEMORY_FILE")\n--- END WORK LOG ---\n"
  fi
done

# Check goals freshness (find any goals.md under context/)
GOALS_FILE=$(find "$PROJECT_DIR/context" -maxdepth 2 -name "goals.md" -not -path "*/memory/*" 2>/dev/null | head -1)
if [ -n "$GOALS_FILE" ] && [ -f "$GOALS_FILE" ]; then
  FILE_MOD=$(stat -f %m "$GOALS_FILE" 2>/dev/null || stat -c %Y "$GOALS_FILE")
  NOW=$(date +%s)
  DAYS_OLD=$(( (NOW - FILE_MOD) / 86400 ))
  if [ "$DAYS_OLD" -gt 30 ]; then
    LAST_UPDATED=$(date -r "$FILE_MOD" '+%Y-%m-%d' 2>/dev/null || date -d "@$FILE_MOD" '+%Y-%m-%d')
    CONTEXT="${CONTEXT}goals.md is ${DAYS_OLD} days old (last updated ${LAST_UPDATED}). Consider asking if goals need updating.\n"
  fi
fi

# Create session timestamp for Stop hook
mkdir -p "$PROJECT_DIR/context/memory/sessions"
touch "$PROJECT_DIR/.claude/hooks/.session-timestamp"

# Output
if [ -n "$CONTEXT" ]; then
  printf '%b' "$CONTEXT"
fi

exit 0
