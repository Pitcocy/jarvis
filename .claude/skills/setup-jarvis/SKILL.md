---
name: setup-jarvis
description: Set up Jarvis end to end. Creates the workspace, installs the tools Jarvis needs (Node.js, git, GitHub CLI), connects GitHub and backs everything up to a private repo. Run this first.
disable-model-invocation: true
---

# Jarvis Setup

The user should never have to open a terminal, download anything themselves, or go hunting for settings. You do the work; they only click what only a human can click (a GitHub approval, an Apple install popup). Before every step that opens a browser or a popup, say in one sentence what they'll see.

Talk in the user's language.

## Step 1: Workspace

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/scaffold.sh"
```

List the top-level directories to confirm it worked.

## Step 2: Tools

```bash
bash "${CLAUDE_SKILL_DIR}/scripts/install-tools.sh"
```

It installs Node.js (memory hooks), the GitHub CLI and, on a Mac, triggers Apple's developer tools for git. No admin password: everything goes into `~/.local`, checksum-verified. It's safe to rerun. Read the `STATUS` lines at the end:

- `git=installing` → tell the user an Apple popup is open: click **Install**, wait until it says done (a few minutes), then tell you. Rerun the script.
- anything `missing` → rerun once. Still missing: tell the user plainly which tool, and carry on. Jarvis works without it, just without that piece.

In this session the new tools aren't on PATH yet. Start every command that uses them with:

```bash
export PATH="$HOME/.local/bin:$PATH";
```

## Step 3: GitHub backup

Skip this step if the user doesn't want a backup. Otherwise:

**Account.** Ask if they have a GitHub account. If not, open https://github.com/signup (`open` on Mac, `start` on Windows) and wait until they're done.

**Login.** Check `gh auth status`. If not logged in, start the login in the background so you can read the code:

```bash
export PATH="$HOME/.local/bin:$PATH"; gh auth login --hostname github.com --git-protocol https --web > .claude/gh-login.txt 2>&1 &
sleep 3; cat .claude/gh-login.txt
```

Show the user the one-time code in big, plain text, then open https://github.com/login/device for them. They paste the code and click **Authorize**. Poll `gh auth status` every few seconds until it succeeds, then:

```bash
export PATH="$HOME/.local/bin:$PATH"; gh auth setup-git; rm -f .claude/gh-login.txt
```

**Private repo.** Check `git remote get-url origin`:

- Points to their own account → already set up, skip.
- Points to `Pitcocy/jarvis` (they cloned the template itself) → `git remote remove origin`, then create theirs (below).
- No git repo or no remote → `git init` if needed, then create theirs:

```bash
export PATH="$HOME/.local/bin:$PATH"
git add -A && git commit -m "Jarvis setup"
gh repo create jarvis --private --source . --remote origin --push
```

If the name `jarvis` is taken, ask for another. It must be **private**: this folder will hold their context, clients and goals.

## Step 4: Wrap up

Tell the user, short and warm:

1. What was set up: the workspace, the tools, the private GitHub backup (`/save` backs up from now on).
2. If `restart_claude_app=yes`: **quit the Claude app completely and open it again**, in this same folder. That's what switches on Jarvis' memory.
3. After the restart: run `/get-to-know-me`. That's where Jarvis learns who they are and personalizes everything.
