#!/bin/bash
# Stop hook: Block if content was created but session log wasn't updated
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
TIMESTAMP_FILE="$PROJECT_DIR/.claude/hooks/.session-timestamp"

# If no session timestamp exists, allow stop
if [ ! -f "$TIMESTAMP_FILE" ]; then
  exit 0
fi

# Check if any content files were created/modified since session start
NEW_OUTPUTS=""

# Check content/ (all content types)
if [ -d "$PROJECT_DIR/content" ]; then
  CONTENT_FILES=$(find "$PROJECT_DIR/content" -newer "$TIMESTAMP_FILE" -type f \
    -not -name '.DS_Store' -not -name 'CLAUDE.md' 2>/dev/null)
  if [ -n "$CONTENT_FILES" ]; then
    NEW_OUTPUTS="$CONTENT_FILES"
  fi
fi

# Check user context files (anything in context/ that's not memory/)
for DIR in "$PROJECT_DIR"/context/*/; do
  DIRNAME=$(basename "$DIR")
  if [ "$DIRNAME" != "memory" ] && [ -d "$DIR" ]; then
    CTX_FILES=$(find "$DIR" -newer "$TIMESTAMP_FILE" -type f \
      -not -name '.DS_Store' 2>/dev/null)
    if [ -n "$CTX_FILES" ]; then
      NEW_OUTPUTS="${NEW_OUTPUTS}${CTX_FILES}"
    fi
  fi
done

# If no new outputs, allow stop
if [ -z "$NEW_OUTPUTS" ]; then
  exit 0
fi

# Outputs exist — check if today's session log was updated
TODAY=$(date '+%Y-%m-%d')
MEMORY_FILE="$PROJECT_DIR/context/memory/sessions/${TODAY}.md"

if [ -f "$MEMORY_FILE" ] && [ "$MEMORY_FILE" -nt "$TIMESTAMP_FILE" ]; then
  # Session was logged — nudge about other memory types before allowing stop
  echo "Reminder: Did any decisions, ideas, or learnings come up this session? If so, log them to context/memory/decisions/, context/memory/ideas/, or context/memory/learnings/ before ending."
  exit 0
fi

# Block — memory not logged
FILE_COUNT=$(echo "$NEW_OUTPUTS" | grep -c .)
FILE_LIST=$(echo "$NEW_OUTPUTS" | sed "s|$PROJECT_DIR/||g" | head -5)

jq -n --arg count "$FILE_COUNT" --arg today "$TODAY" --arg files "$FILE_LIST" '{
  decision: "block",
  reason: ("You created/updated " + $count + " file(s) this session but did not log to context/memory/sessions/" + $today + ".md. Log the work before ending.\nFiles:\n" + $files)
}'
