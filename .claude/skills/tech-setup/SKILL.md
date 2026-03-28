---
name: tech-setup
description: Install and configure the technical tools that power Jarvis — Google Suite CLI, MCP servers, and other integrations. Run after /setup-jarvis and /get-to-know-me.
disable-model-invocation: true
---

# Tech Setup

Install and configure the tools Jarvis needs. Run each section in order — skip any that are already done.

**Important:** Some steps open a browser or require the user to act outside the terminal. Explain what they'll see before it happens. Don't rush — normies need a moment.

## Sections

### 1. Node.js & npm
Required by MCP servers. Follow [references/node-setup.md](references/node-setup.md).

### 2. Git & GitHub
Version control + private remote repo. Follow [references/github-setup.md](references/github-setup.md).

### 3. Google Suite CLI (gogcli)
Gmail (readonly), Drive (readonly), Calendar (full). Follow [references/gogcli-setup.md](references/gogcli-setup.md).

### 4. Chrome DevTools MCP
Browser control — screenshots, navigation, forms, performance audits. Follow [references/chrome-devtools-mcp.md](references/chrome-devtools-mcp.md).

### 5. Meta Ads MCP
Meta Ads reporting via TrueClicks. Requires GPT token in `.env.local`. Follow [references/meta-ads-mcp.md](references/meta-ads-mcp.md).

### 6. Granola MCP
Meeting notes — search transcripts, query notes, extract action items. OAuth-based, no tokens needed. Follow [references/granola-mcp.md](references/granola-mcp.md).

### 7. Additional Tools
*Coming soon — more MCP servers and integrations will be added here.*

---

## Tokens & Secrets

All API tokens live in `.env.local` in the project root. This file is gitignored — never committed.

```
META_ADS_GPT_TOKEN=xxx
```

Skills that need tokens read from this file. If `.env.local` doesn't exist yet, the setup steps will create it.

---

## After Setup

Once all sections are complete, tell the user:

> Jarvis is fully set up. You have:
> - Version control with a private GitHub repo
> - Google email, drive, and calendar access (gogcli)
> - Browser control — screenshots, navigation, form filling (Chrome DevTools MCP)
> - Meta Ads reporting (Meta Ads MCP)
> - Meeting notes search and action items (Granola MCP)
>
> Every new conversation can now read your emails, check your calendar, search your drive, interact with websites, pull Meta Ads data, and reference your meeting notes. Try asking "What's on my calendar today?" or "What action items came out of my last meeting?"
