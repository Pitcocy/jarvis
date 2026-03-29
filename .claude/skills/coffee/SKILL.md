---
name: coffee
description: |
  Your daily briefing — grab your coffee and catch up. Scans emails, calendar,
  meeting notes, and client context to give you a prioritized rundown of your day.
  Works morning, mid-day, or whenever you need to get oriented.
disable-model-invocation: true
---

# Coffee

The daily briefing. Scans everything — emails, calendar, meetings, action items — and gives the user a prioritized rundown of what matters right now.

## Command Format

```
/coffee              # Full briefing
/coffee --quick      # Calendar + urgent emails only
/coffee --client X   # Briefing filtered to one client
```

## Important

**Read [references/gog-commands.md](references/gog-commands.md) before running any gogcli commands.** It has the exact syntax — don't guess flags.

## Process

Run all data gathering steps first, then synthesize into one briefing. Don't present raw data — interpret it.

### Step 1: What Time Is It?

Check the time. This changes the tone and focus:

- **Morning (before 10am):** Full day ahead. Focus on what's coming today + anything from yesterday that needs follow-up.
- **Mid-day (10am–3pm):** Day is underway. Focus on what's coming in the next few hours + anything urgent that landed.
- **Late afternoon (after 3pm):** Day is winding down. Focus on loose ends + what's coming tomorrow.

### Step 2: Calendar Scan

Pull today's events (see `references/gog-commands.md` for full syntax):

```bash
gog calendar events --today --all --json
```

If afternoon, also pull tomorrow:
```bash
gog calendar events --tomorrow --all --json
```

For each meeting, note:
- **Time and title**
- **Attendees** — cross-reference with client contacts (check `clients/*/CLAUDE.md` for contact emails)
- **Is it soon?** — flag anything in the next 2 hours as "coming up"
- **Needs prep?** — if it's a client meeting, check if there are recent notes or open action items

### Step 3: Email Triage

Pull recent unread emails (see `references/gog-commands.md` for full syntax):

```bash
gog gmail search "is:unread newer_than:1d" --json --max 20
```

For each email:
- **Who's it from?** — cross-reference sender against client contacts
- **Classify priority:**
  - **Urgent** — from a client contact, contains deadline language, or flagged
  - **Needs reply** — question asked, action requested
  - **FYI** — newsletters, notifications, CCs
- **Route to client** — if the sender matches a client contact, note which client

If `--client X` was passed, filter to only show emails matching that client's contacts.

### Step 4: Meeting Notes & Action Items

If Granola MCP is available, pull recent meeting notes:

```
query_granola_meetings: "action items from meetings in the last 3 days"
```

Look for:
- **Open action items** — things assigned to the user that haven't been completed
- **Follow-ups due** — "I'll send that by Friday" type commitments
- **Meeting prep** — for upcoming meetings today, check if there were previous meetings with the same people and what was discussed

If Granola is not available, check `clients/*/notes/` for recent files.

### Step 5: Client Pulse (if clients exist)

If `clients/` folder has client subfolders, do a quick pulse check:

For each active client:
- Any emails from them in the last 24h?
- Any meetings with them today?
- Any open action items?
- Any deadlines approaching?

Only surface clients that have something going on. Don't list quiet clients.

### Step 6: Synthesize the Briefing

Now bring it all together. **Don't dump raw data.** Interpret it, prioritize it, and present it in a way that helps the user decide what to do first.

**Tone:** Match the user's SOUL.md and communication style. If they're casual, be casual. If the SOUL.md says to use humor, use humor. This should feel like a smart colleague catching them up, not a dashboard readout.

**Structure the output like this:**

```markdown
# ☕ {Greeting based on time of day}

## Right Now
{Anything urgent — meeting in 30 min, email that needs immediate reply, deadline today}

## Today's Meetings
{Chronological list of meetings with context}
- **10:00 — Weekly with Acme** (John, Sarah) — Last meeting you discussed the Q2 campaign pivot. Action item: you were going to send updated targeting.
- **14:00 — Internal strategy** — No prep needed.
- **16:00 — BigCorp review** (Mike) — First meeting in 2 weeks. Check recent email thread.

## Email Highlights
{Grouped by priority, not chronologically}

**Needs Reply:**
- {sender} — {subject} — {one-line summary of what they need}

**FYI:**
- {sender} — {subject} — {one-line summary}

## Action Items
{Open items from recent meetings, with context}
- [ ] Send Acme updated targeting (from Monday's meeting)
- [ ] Review BigCorp Q1 report (Mike asked on Thursday)

## Client Pulse
{Only clients with activity}
- **Acme** — 2 unread emails, meeting at 10:00, 1 open action item
- **BigCorp** — meeting at 16:00, no emails

## Suggested Priorities
{Your recommendation on what to tackle first, based on everything above}
1. Reply to {urgent email} before the 10:00 meeting
2. Prep Acme meeting — review the targeting doc
3. Clear the BigCorp action item before their 16:00 call
```

### Adaptation Rules

- **No calendar events?** Skip the meetings section entirely.
- **No unread emails?** Say "Inbox is clear" and move on.
- **No clients set up?** Skip client pulse.
- **No Granola?** Skip action items from meetings (or check notes/ folders).
- **`--quick` flag?** Only show "Right Now" + "Today's Meetings" + urgent emails. Skip everything else.
- **`--client X` flag?** Filter everything to just that client — their emails, meetings, action items.
- **Weekend/holiday?** Lighter tone, focus on what's coming Monday.

### What NOT to Do

- Don't list every email. Only the ones that matter.
- Don't show raw JSON or command output.
- Don't be robotic. This is ☕ time, not a KPI dashboard.
- Don't make up information. If you can't reach the calendar or email, say so and skip that section.
- Don't overwhelm. If there are 15 unread emails, group and summarize — don't list all 15.
