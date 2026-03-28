# Git & GitHub Setup

Version control for the Jarvis project + a private remote repo on GitHub so nothing is lost.

**Prerequisites:** A GitHub account.

## Steps

### 1. Check git

```bash
git --version 2>/dev/null
```

- If not found → install: `brew install git`
- If found → skip

### 2. Install GitHub CLI

```bash
gh --version 2>/dev/null
```

- If not found → install: `brew install gh`
- If found → skip

### 3. Authenticate with GitHub

Check if already logged in:

```bash
gh auth status 2>/dev/null
```

If not authenticated, tell the user:

> I need to connect to your GitHub account. This will open your browser:
>
> 1. A browser tab opens asking you to sign in to GitHub
> 2. You'll see a device code — confirm it matches what I show in the terminal
> 3. Click **"Authorize"**
> 4. Come back here once done

Then run:

```bash
gh auth login --web --git-protocol https
```

Wait for the user to confirm they completed the browser step.

### 4. Initialize the git repo

Only if not already a git repo:

```bash
git init
git add -A
git commit -m "Initial Jarvis setup"
```

If already a git repo, skip this step.

### 5. Create private remote repo

Ask the user what they want to name the repo (suggest "jarvis" as default), then:

```bash
gh repo create REPO_NAME --private --source . --push
```

This creates a **private** repo on their GitHub account and pushes the initial commit. Private is critical — this folder contains personal context, goals, brand voice, and potentially API tokens.

### 6. Verify

```bash
git remote -v
gh repo view --web
```

The second command opens the repo in the browser so the user can see it exists. Tell them:

> Your Jarvis project is now backed up to a private GitHub repo. Everything you create — content, context, memory — is version controlled. You can always roll back if something goes wrong.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `git: command not found` | `brew install git` |
| `gh: command not found` | `brew install gh` |
| Auth fails in browser | Try `gh auth login --web` again — sometimes the device code expires |
| "Repository already exists" | The repo name is taken — ask the user for a different name |
| Push rejected | Check if the remote already has commits — may need `git pull --rebase` first |
