---
name: add-client
description: Add a new client to Jarvis — creates their folder structure with CLAUDE.md, rules, context templates, and registers them in the root index.
disable-model-invocation: true
---

# Add Client

Set up a new client workspace. This creates a full working environment — CLAUDE.md, rules, context folders, and templates — so Jarvis knows who this client is from day one.

## Step 1: Gather Client Info

Ask the user about the client. Be conversational — don't dump a form. Key things to learn:

**Basics**
- Client/company name
- Industry / niche
- What the user does for them (services, scope — e.g., "Google Ads + Meta Ads + email marketing")
- Website URL (for brand context gathering later)

**Contacts**
- Main contact(s): name, email, role. Critical for email/meeting routing.
- Any other key people they interact with

**Marketing Channels**
- Which platforms/channels are active? (Google Ads, Meta Ads, LinkedIn Ads, Email, SEO, Content, etc.)
- Any ad account IDs or platform identifiers worth noting
- Monthly budget range (if known)

**Communication**
- How often do they meet? (weekly? biweekly?)
- Preferred communication channel (email, Slack, calls)

**Goals** (high level — `/business-context` goes deeper later)
- What's the client trying to achieve?
- Primary KPI they care about (leads, revenue, ROAS, etc.)

Don't ask everything if it's not relevant. Read the room.

## Step 2: Create the Folder Structure

Use the client name (lowercase, hyphens for spaces) as the folder name.

```bash
CLIENT_DIR="clients/{client-name}"
mkdir -p "$CLIENT_DIR/.claude/rules"
mkdir -p "$CLIENT_DIR/context/website/pages"
mkdir -p "$CLIENT_DIR/context/brand-colours"
mkdir -p "$CLIENT_DIR/notes"
mkdir -p "$CLIENT_DIR/emails"
mkdir -p "$CLIENT_DIR/created/reports"
```

## Step 3: Write the Client's CLAUDE.md

This loads automatically when the user `cd`s into the client folder. Write it personalized with everything you learned. Follow this structure:

```markdown
# {Client Name} — Marketing Workspace

You are working on {Client Name}'s marketing. Think in business outcomes, not just metrics. Be a thinking partner — have opinions, challenge assumptions, and lead with data.

## Before Any Task

Read `context/business.md` first (if it exists). Know the targets, constraints, and priorities before doing anything.

If `business.md` is missing or incomplete, tell the user and suggest running `/business-context` to set it up.

## Overview

- **Company:** {name}
- **Industry:** {industry}
- **Website:** {url}
- **Services we provide:** {what the user does for them}
- **Active channels:** {Google Ads, Meta, Email, etc.}
- **Meeting cadence:** {weekly/biweekly/etc.}
- **Budget:** {if known}

## Contacts

| Name | Email | Role |
|------|-------|------|
| {name} | {email} | {role} |

## Goals

{High-level goals — what the client is trying to achieve and their primary KPI}

## How You Think

- Tie recommendations back to business.md targets — never analyze in a vacuum
- Before recommending anything, check: do I have the data? If not, say so
- Flag stale data before basing decisions on it
- After completing a task, suggest the next logical step
- Connect dots across channels — if one channel's insight applies elsewhere, say so

## How You Communicate

- Lead with impact: "$2,400/month saved" not "I recommend adjusting the strategy"
- Use numbers, not adjectives: "$45 CPA vs $200 target" not "CPA is quite high"
- Short and direct — bullets over paragraphs
- When presenting options, give your recommendation and why

## Data & Context

All context lives in `context/`:
- `context/business.md` — business model, goals, targets, constraints
- `context/brand.md` — brand analysis from website

Meeting notes → `notes/`
Important emails → `emails/`
Created content and reports → `created/`

Full file reference: `.claude/rules/context-files.md`
```

Fill in all the `{placeholders}` with actual info from Step 1. Don't leave any unfilled.

## Step 4: Write Client Rules

### `.claude/rules/context-files.md`

```markdown
# Context File Reference

| File | Contains | Updated by |
|------|----------|-----------|
| `context/business.md` | Business model, goals, targets, KPIs, constraints | `/business-context` |
| `context/brand.md` | Brand analysis — tone, audience, USPs, trust signals | `/brand-context` |
| `context/brand-colours/palette.md` | Brand colour palette | `/brand-context` |
| `context/website/pages/*.md` | Scraped website content | `/brand-context` |
| `notes/*.md` | Meeting notes and call summaries | Manual / Granola |
| `emails/*.md` | Important email threads | Manual |
| `created/reports/*.md` | Analysis reports and recommendations | Various skills |
```

### `.claude/rules/memory-logging.md`

```markdown
# Client Memory Logging

When working in this client folder, log all significant work to the Jarvis session log at `context/memory/sessions/YYYY-MM-DD.md` (relative to Jarvis root).

Include the client name in the log entry so it's searchable:

**Format:** `- [{Client Name}] {what you did} — {brief context}`

**Example:** `- [Acme] Created Q2 campaign brief — focused on lead gen for enterprise segment`
```

## Step 5: Create Context Templates

### `context/business.md`

```markdown
# Business Context — {Client Name}

> Run `/business-context` to fill this in through a structured interview.

**Status: TEMPLATE — needs setup**

## Business Model
<!-- What they sell, who they sell to, pricing -->

## Unit Economics
<!-- Margins, CLV, CAC, break-even points -->

## Goals & KPIs
<!-- Primary KPI, targets, hard constraints, budget -->

## Marketing Channels
<!-- Which channels, budget allocation, priorities -->

## Competitive Landscape
<!-- Key competitors, differentiation, strategy -->

## Constraints
<!-- Approval processes, brand guidelines, team dependencies -->

---
*Run `/business-context` for a structured interview that fills this in properly.*
```

## Step 6: Update the Root CLAUDE.md

Add a one-liner to the "Clients & Projects" section under `### Clients`. If the section doesn't exist, create it.

Format:
```markdown
- **{Client Name}** — `clients/{client-name}/` — {industry}, {services}, contact: {main email}
```

## Step 7: Confirm

Tell the user:

> **{Client Name} is set up.** Here's what's ready:
>
> - Full workspace at `clients/{client-name}/`
> - CLAUDE.md with client context
> - Rules for file routing and memory logging
>
> **Next steps:**
> 1. `cd clients/{client-name}/` — work from the client folder
> 2. Run `/business-context` — structured interview for goals, targets, unit economics
> 3. Run `/brand-context {website-url}` — scrape their website for brand analysis
>
> After that, Jarvis knows this client inside out.
