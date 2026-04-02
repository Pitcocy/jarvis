# Meta Ads MCP (TrueClicks)

Gives Jarvis access to Meta Ads data — campaign performance, ad insights, account reporting. Hosted MCP by [TrueClicks](https://trueclicks.com) via [gaql.app](https://gaql.app). No local install needed.

**Prerequisites:** A Meta Ads account with active ad accounts.

## Steps

### 1. Check `.env.local` for the token

Read `.env.local` and check the value of `GOOGLE_ADS_GPT_TOKEN`.

**If the token is real** (not `your-google-ads-token-here` or empty) → tell the user you found their token and skip to step 3.

**If the token is still a placeholder or missing** → walk them through getting it:

> To connect your Google Ads, I need a token. It takes about 30 seconds:
>
> 1. Open **https://gaql.app** in your browser
> 2. Click **"Sign in with Google"** — log in with whichever account runs your ads
> 3. Once you're in, you'll see a **"COPY GPT TOKEN"** button in the top-right — click it
> 4. Open the file `.env.local` in your project folder (it's already there from setup)
> 5. Find the line `GOOGLE_ADS_GPT_TOKEN=your-google-ads-token-here` and replace `your-google-ads-token-here` with the token you just copied
> 6. Save the file and come back here
>
> That token is what lets me read your ad data. It stays on your machine — never gets uploaded or shared.

Wait for the user to confirm they've updated it, then read `.env.local` again to verify the token is no longer a placeholder.

### 3. Add the MCP server

Read the token from `.env.local` and register the MCP:

```bash
META_TOKEN=$(grep 'GOOGLE_ADS_GPT_TOKEN' .env.local | cut -d '=' -f2-)
claude mcp add google-ads --scope user --transport sse "https://mcp.gaql.app/sse/google-ads/$GOOGLE_ADS_TOKEN"
```

User scope — available in all Claude Code projects.

### 4. Tell the user to restart Claude Code

> I've added the Google Ads MCP server. You'll need to restart Claude Code for it to load.
>
> Close this session and open a new one. When you come back, I'll be able to pull your Google Ads data — campaign performance, spend, conversions, all of it.

### 5. Verify (after restart)

After restart, test by asking something like:

> Show me my Google ad accounts

or

> How did my Google campaigns perform last week?

If it returns ad data, it's working.

---

## What Jarvis Can Do With Google Ads

- Pull campaign, ad set, and ad performance data
- Ask natural-language questions about spend, ROAS, conversions
- Compare performance across time periods
- Generate insights and recommendations  

## Token Refresh

The GPT token from gaql.app may expire. If Google Ads queries stop working:

1. Go back to https://gaql.app
2. Sign in again and copy a fresh token
3. Update `GOOGLE_ADS_GPT_TOKEN` in `.env.local`
4. Re-run: `claude mcp add google-ads --scope user --transport sse "https://mcp.gaql.app/sse/google-ads/NEW_TOKEN"`
5. Restart Claude Code

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "No ad accounts found" | Make sure the Meta account you logged into gaql.app with has ad account access |
| MCP not loading after restart | Run `claude mcp list` to verify it's registered |
| Token expired | Get a fresh token from gaql.app and re-add the MCP |
| SSE connection errors | Check your internet connection — this is a hosted MCP, not local |
