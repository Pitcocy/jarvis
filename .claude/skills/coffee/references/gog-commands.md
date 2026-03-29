# gogcli Command Reference for /coffee

Exact command syntax for the data-gathering steps. **Do not guess flags — use these exactly.**

## Calendar

```bash
# Today's events (all calendars)
gog calendar events --today --all --json

# Today's events (primary calendar only)
gog calendar events --today --json

# Tomorrow's events
gog calendar events --tomorrow --all --json

# Next N days
gog calendar events --days 3 --all --json

# This week
gog calendar events --week --all --json

# Specific calendar by name
gog calendar events --cal "Work" --today --json

# List all calendars (to find IDs/names)
gog calendar calendars --json
```

**Key syntax rules:**
- `--today`, `--tomorrow`, `--week`, `--days N` are convenience flags — use them instead of `--from`/`--to`
- `--all` fetches from ALL calendars (not just primary) — use this by default
- `--json` for structured output Claude can parse
- Calendar ID is an optional positional arg: `gog calendar events <calendarId>` — but prefer `--all` or `--cal "Name"`

## Gmail

```bash
# Unread emails from the last day
gog gmail search "is:unread newer_than:1d" --json --max 20

# Unread emails from the last 3 days
gog gmail search "is:unread newer_than:3d" --json --max 20

# All recent emails (read + unread) from last day
gog gmail search "newer_than:1d" --json --max 20

# Emails from a specific sender
gog gmail search "from:john@acme.com newer_than:7d" --json

# Starred/important emails
gog gmail search "is:starred newer_than:7d" --json

# Emails with attachments
gog gmail search "has:attachment newer_than:3d" --json

# Read a specific thread (get full content)
gog gmail threads get <threadId> --json
```

**Key syntax rules:**
- `<query>` is a positional argument — the Gmail search query comes right after `search`
- Uses standard Gmail search syntax: `is:unread`, `from:`, `to:`, `newer_than:`, `older_than:`, `subject:`, `has:attachment`
- `--max N` limits results (default: 10)
- `--json` for structured output

## Gmail Search Query Cheat Sheet

| Query | What it finds |
|-------|--------------|
| `is:unread` | Unread emails |
| `is:starred` | Starred emails |
| `is:important` | Emails marked important |
| `newer_than:1d` | Last 24 hours |
| `newer_than:7d` | Last 7 days |
| `from:user@example.com` | From specific sender |
| `to:me` | Sent directly to user (not CC) |
| `subject:invoice` | Subject contains "invoice" |
| `has:attachment` | Has attachments |
| `label:INBOX` | In inbox (not archived) |
| `category:updates` | In Updates tab |
| `category:promotions` | In Promotions tab |

Combine with spaces: `is:unread from:john@acme.com newer_than:3d`

## Output Format Notes

- `--json` returns structured data — parse directly, don't show raw JSON to the user
- Calendar events include: `summary`, `start`, `end`, `attendees`, `location`, `description`
- Gmail threads include: `subject`, `from`, `to`, `snippet`, `date`, `labels`, `threadId`
- Use `--results-only` with `--json` to skip pagination metadata
