---
name: save
description: Save your work to GitHub — stages changes, creates a commit with a clear message, and pushes. Safe for normies.
disable-model-invocation: true
argument-hint: "[optional message]"
---

# Save

Save the user's work to GitHub. Handles staging, committing, and pushing in one go. The user never needs to know git commands.

## Command Format

```
/save                    # Auto-generate commit message from changes
/save updated acme notes # Use the provided message
```

## Process

### Step 1: Check Status

```bash
git status
```

If there are no changes (working tree clean), tell the user:

> Nothing to save — everything is already up to date on GitHub.

And stop.

### Step 2: Review Changes

Look at what changed:

```bash
git status --short
git diff --stat
```

Quickly scan for anything that should NOT be committed:
- `.env`, `.env.local`, or any file matching secret patterns
- `credentials.json`, `token.json`, `*.key`, `*.pem`
- `node_modules/`
- Any file that looks like it contains API keys or passwords

If you spot something sensitive:
> I noticed `{filename}` in the changes — this looks like it might contain secrets. I'm going to skip it. If it should be committed, let me know.

Do NOT stage sensitive files. Add them to `.gitignore` if they're not already there.

### Step 3: Stage Safe Files

Stage everything except sensitive files:

```bash
git add -A
```

If specific files were excluded in Step 2, unstage them:

```bash
git reset HEAD {sensitive-file}
```

### Step 4: Generate Commit Message

**If the user provided a message** (via `$ARGUMENTS`), use it as-is. Clean it up slightly if needed (capitalize first letter, no trailing period).

**If no message was provided**, generate one from the changes:

- Look at which files were added, modified, deleted
- Group by type: content, context, client work, config, notes
- Write a short, clear commit message (1-2 lines max)

**Good messages:**
- "Add Acme meeting notes and update Q2 brief"
- "Update brand voice and create 3 LinkedIn drafts"
- "Set up BigCorp client workspace"

**Bad messages:**
- "Update files" (too vague)
- "Modified CLAUDE.md, notes/2026-03-28.md, content/linkedin/drafts/post.md" (file list, not summary)

### Step 5: Commit

```bash
git commit -m "{message}"
```

### Step 6: Push

Check if the branch tracks a remote:

```bash
git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
```

If it does:
```bash
git push
```

If it doesn't (first push or new branch):
```bash
git push -u origin main
```

### Step 7: Confirm

Tell the user what was saved. Keep it short:

> Saved to GitHub: "{commit message}"
> {X} files changed.

If this is their first push ever, add:
> Your work is now backed up on GitHub. Run `/save` anytime to push new changes.

## Edge Cases

| Situation | Action |
|-----------|--------|
| No changes | "Nothing to save — already up to date." |
| Sensitive file detected | Skip it, warn the user, add to .gitignore if missing |
| No remote repo | Tell the user to run `/tech-setup` (GitHub section) first |
| Merge conflict | Explain what happened in plain English, ask how they want to handle it |
| Not a git repo | Tell the user to run `/tech-setup` (GitHub section) first |
| Push rejected (remote ahead) | Run `git pull --rebase` first, then push. If conflicts, explain clearly. |

## What NOT to Do

- Never commit `.env`, `.env.local`, credentials, or tokens
- Never force push
- Never amend a previous commit — always create a new one
- Never use technical git jargon with the user — "save" not "commit", "GitHub" not "remote"
