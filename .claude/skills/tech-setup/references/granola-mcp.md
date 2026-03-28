# Granola MCP

[Granola MCP](https://docs.granola.ai/help-center/sharing/integrations/mcp) gives Jarvis access to your meeting notes — search transcripts, query notes, extract action items, and browse meeting folders.

**Prerequisites:** A Granola account with existing meeting notes.

## Steps

### 1. Add the MCP server

```bash
claude mcp add granola --scope user --transport http https://mcp.granola.ai/mcp
```

User scope — available in all Claude Code projects.

### 2. Authenticate via browser

Tell the user to restart Claude Code, then:

> I've added Granola. After restarting, I need to authenticate with your Granola account:
>
> 1. I'll open the MCP settings — run `/mcp`
> 2. Select the **granola** MCP
> 3. Choose **"Authenticate"**
> 4. A browser window will open — sign in with the same email you use for Granola
> 5. Click **"Allow"** on the consent screen
> 6. Come back here once done

No tokens or API keys — Granola uses OAuth, so credentials are handled automatically.

### 3. Verify

After authentication, test with:

> What meetings did I have this week?

or

> What action items came out of my last meeting?

If it returns meeting data, it's working.

---

## Available Tools

| Tool | What it does |
|------|-------------|
| `query_granola_meetings` | Chat with and query your meeting notes |
| `list_meeting_folders` | View folders you're a member of (paid plans only) |
| `list_meetings` | List meetings with metadata, filter by folder |
| `get_meetings` | Search meeting content including transcripts and notes |
| `get_meeting_transcript` | Access raw transcripts (paid plans only) |

## What Jarvis Can Do With Granola

- Search across all your meeting notes
- Pull action items from specific meetings
- Answer questions like "What did we decide about X in last week's meeting?"
- List meetings by date range or folder
- Access full transcripts for detailed context

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "No tools available" | Disconnect and reconnect via `/mcp` |
| Wrong account authenticated | Wait 24 hours after removing, then re-authenticate with the correct email |
| Can't access transcripts | Full transcript access requires a paid Granola plan |
| Only seeing last 30 days | Free plan limitation — upgrade for full history |
| Rate limit errors | Granola allows ~100 requests/minute — wait and retry |
