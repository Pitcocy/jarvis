# Meta Ads MCP (TrueClicks)

Gives Jarvis access to Meta Ads data — campaign performance, ad insights, account reporting. Hosted MCP by [TrueClicks](https://trueclicks.com) via [gaql.app](https://gaql.app). No local install needed.

**Prerequisites:** A Meta Ads account with active ad accounts.

## Steps

### 1. Get the GPT token

The user needs to generate a token from gaql.app. Tell them:

> I need a Meta Ads token to connect your ad accounts. Here's how to get it:
>
> 1. Go to **https://gaql.app** in your browser
> 2. Click **Sign in with Meta** and log in with the account that has access to your ad accounts
> 3. Once logged in, click the **"COPY GPT TOKEN"** button in the top-right corner
> 4. Paste the token back here

Wait for the user to provide the token.

### 2. Store the token in `.env.local`

Save it to the project's `.env.local` file (create if it doesn't exist):

```bash
# Check if .env.local exists
if [ ! -f .env.local ]; then
  touch .env.local
fi
```

Check if `META_ADS_GPT_TOKEN` already exists in the file. If not, append it:

```bash
grep -q 'META_ADS_GPT_TOKEN' .env.local || echo 'META_ADS_GPT_TOKEN=THE_TOKEN_VALUE' >> .env.local
```

If it already exists, update it with the new value.

### 3. Add the MCP server

Read the token from `.env.local` and register the MCP:

```bash
META_TOKEN=$(grep 'META_ADS_GPT_TOKEN' .env.local | cut -d '=' -f2-)
claude mcp add meta-ads --scope user --transport sse "https://mcp.gaql.app/sse/meta-ads/$META_TOKEN"
```

User scope — available in all Claude Code projects.

### 4. Tell the user to restart Claude Code

> I've added the Meta Ads MCP server. You'll need to restart Claude Code for it to load.
>
> Close this session and open a new one. When you come back, I'll be able to pull your Meta Ads data — campaign performance, spend, conversions, all of it.

### 5. Verify (after restart)

After restart, test by asking something like:

> Show me my Meta ad accounts

or

> How did my Meta campaigns perform last week?

If it returns ad data, it's working.

---

## What Jarvis Can Do With Meta Ads

- Pull campaign, ad set, and ad performance data
- Ask natural-language questions about spend, ROAS, conversions
- Compare performance across time periods
- Generate insights and recommendations

## Token Refresh

The GPT token from gaql.app may expire. If Meta Ads queries stop working:

1. Go back to https://gaql.app
2. Sign in again and copy a fresh token
3. Update `META_ADS_GPT_TOKEN` in `.env.local`
4. Re-run: `claude mcp add meta-ads --scope user --transport sse "https://mcp.gaql.app/sse/meta-ads/NEW_TOKEN"`
5. Restart Claude Code

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "No ad accounts found" | Make sure the Meta account you logged into gaql.app with has ad account access |
| MCP not loading after restart | Run `claude mcp list` to verify it's registered |
| Token expired | Get a fresh token from gaql.app and re-add the MCP |
| SSE connection errors | Check your internet connection — this is a hosted MCP, not local |
