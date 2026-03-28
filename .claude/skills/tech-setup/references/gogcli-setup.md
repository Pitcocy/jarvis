# gogcli — Google Suite CLI

[gogcli](https://github.com/steipete/gogcli) gives Jarvis access to Gmail (read-only), Drive (read-only), and Calendar (read + write).

## Steps

### 1. Install gogcli

```bash
brew install gogcli
```

Verify with `gog --version`. If already installed, skip.

### 2. Find and register credentials

Look for the credentials file in the project root:

```bash
ls client_secret*.json 2>/dev/null
```

If found, register it:

```bash
gog auth credentials ./client_secret_FILENAME.json
```

If not found, ask the user where they put it. They may have left it in `~/Downloads/`.

After registering, delete the credentials file — it contains OAuth secrets and has no reason to stay in the project:

```bash
rm ./client_secret_FILENAME.json
```

Tell the user: "I've removed the credentials file — gogcli stored what it needs securely in your system keyring."

### 3. Authorize with the right scopes

Ask the user for their Gmail address, then run:

```bash
gog auth add USER_EMAIL --services gmail,drive,calendar --gmail-scope readonly --drive-scope readonly
```

**Before running this command, tell the user:**

> This will open your browser for Google sign-in. Here's what to expect:
>
> 1. A browser tab opens asking you to sign in to Google
> 2. You'll see a consent screen listing the permissions (Gmail read, Drive read, Calendar full)
> 3. Click **"Allow"**
> 4. The browser will show a success message — you can close that tab
> 5. Come back here — I'll verify everything worked

Wait for the user to confirm they completed the browser step before continuing.

### 4. Verify

Test each service:

```bash
gog gmail labels list --account USER_EMAIL
gog drive files list --limit 3 --account USER_EMAIL
gog calendar events list --limit 3 --account USER_EMAIL
```

If all three return data, gogcli is working. If any fail, check `gog auth status` and the troubleshooting section below.

### 5. Set default account

Other Jarvis skills depend on gogcli working without `--account` flags. You MUST add the default to the user's shell profile.

Detect shell and append:

```bash
if [ -f ~/.zshrc ]; then
  SHELL_PROFILE=~/.zshrc
elif [ -f ~/.bashrc ]; then
  SHELL_PROFILE=~/.bashrc
elif [ -f ~/.bash_profile ]; then
  SHELL_PROFILE=~/.bash_profile
fi
```

```bash
grep -q 'GOG_ACCOUNT' "$SHELL_PROFILE" || echo '\n# Jarvis — default Google account for gogcli\nexport GOG_ACCOUNT=USER_EMAIL' >> "$SHELL_PROFILE"
```

Export in the current session too:

```bash
export GOG_ACCOUNT=USER_EMAIL
```

Tell the user: "I added your Google account as the default for all future terminal sessions."

---

## Prerequisites

The user must have done these before running this section:

### 1. Homebrew
Should already be installed. Test with `brew --version`.

### 2. Google Cloud Project
The user needs a Google Cloud project with these APIs enabled:
- Gmail API
- Google Drive API
- Google Calendar API

**How to enable APIs:**
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select or create a project
3. Go to "APIs & Services" → "Library"
4. Search for and enable each API

### 3. OAuth Desktop Credentials
The user needs to create OAuth credentials:
1. Go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "OAuth client ID"
3. Select "Desktop app" as the application type
4. Download the JSON file (starts with `client_secret_`)
5. Place it in the Jarvis project root folder

### 4. OAuth Consent Screen
If not configured yet:
1. Go to "APIs & Services" → "OAuth consent screen"
2. Choose "External" (unless Workspace)
3. Fill in app name (e.g., "Jarvis") and your email
4. Add scopes: Gmail readonly, Drive readonly, Calendar full
5. Add yourself as a test user (required while app is in "Testing" status)

## Scopes We Request

| Service  | Scope                  | Access      | What Jarvis can do                              |
|----------|------------------------|-------------|--------------------------------------------------|
| Gmail    | gmail.readonly         | Read-only   | Search emails, read threads, list labels         |
| Drive    | drive.readonly         | Read-only   | Search files, read content, download             |
| Calendar | calendar               | Full access | Read, create, update, and delete calendar events |

## Key Commands Reference

```bash
# Auth
gog auth credentials <file>          # Register OAuth credentials
gog auth add <email> --services ...  # Authorize account with scopes
gog auth status                      # Check current auth status
gog auth list                        # List authorized accounts

# Gmail
gog gmail search '<query>'           # Search emails (Gmail search syntax)
gog gmail threads get <id>           # Read a thread
gog gmail labels list                # List all labels
gog gmail messages list              # List recent messages

# Drive
gog drive files list                 # List files
gog drive files search '<query>'     # Search files
gog drive files get <id>             # Get file metadata
gog drive files download <id>        # Download a file

# Calendar
gog calendar events list             # List upcoming events
gog calendar events create ...       # Create an event
gog calendar events update ...       # Update an event
gog calendar events delete <id>      # Delete an event
gog calendar calendars list          # List calendars
```

## Output Formats

- Default: human-readable tables
- `--json`: structured JSON (best for piping to Claude)
- `--plain`: tab-separated values

## Multi-Account

If the user has multiple Google accounts:

```bash
gog auth add work@company.com --services gmail,drive,calendar --gmail-scope readonly --drive-scope readonly
gog auth add personal@gmail.com --services gmail,drive,calendar --gmail-scope readonly --drive-scope readonly
gog auth alias set work work@company.com
gog auth alias set personal personal@gmail.com
```

Then use `--account work` or `--account personal` per command.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `gog: command not found` | Run `brew install gogcli` |
| Browser doesn't open | Use `--manual` flag for a copy-paste URL flow |
| "Access blocked" in browser | Add yourself as test user in OAuth consent screen |
| Token expired | Run `gog auth add <email>` again — tokens auto-refresh, but occasionally need re-auth |
| Wrong scopes | Remove account with `gog auth remove <email>` and re-add with correct `--services` flags |
