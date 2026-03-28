# Memory Logging

Memory lives in `context/memory/` and has four types. Be proactive — the more context you capture, the better future sessions will be.

## Sessions — `context/memory/sessions/YYYY-MM-DD.md`

What you did today. Factual work log.

**Always log:**
- Content created or edited (type, title, status, key angle)
- Updates to user context files (what changed, why)
- Business decisions or brainstorming outcomes
- Campaigns planned or launched

**Never log:**
- File reads or searches
- Questions you asked the user
- Minor formatting fixes

**Format:** One entry per section (## Content Created, ## Business, ## Campaigns, etc). Short — one line per action + brief context. If today's file exists, append; if not, create with `# YYYY-MM-DD` header.

**When to read:** Check last 3 days when the user references past work or when continuing multi-session tasks. The session-start hook injects these automatically.

## Learnings — `context/memory/learnings/`

Patterns you notice about how the user works, decides, and reacts. Things that make you a better assistant over time.

**Examples:**
- "They write best in the morning — don't suggest content tasks in afternoon sessions"
- "When they're stuck on copy, showing competitor examples unblocks them faster than brainstorming"
- "They tend to overthink headlines — push them to ship after the second draft"

**Format:** One file per insight, named descriptively (e.g., `morning-writer.md`, `competitor-unblock.md`). Short — 3-5 lines max. Include when you noticed it and why it matters.

**When to write — specific triggers:**
- The user reacts unexpectedly to a suggestion (positive or negative)
- You notice a work pattern repeating across sessions
- The user corrects your approach — the correction itself is a learning
- Something that worked unusually well or poorly
- You discover a preference that isn't documented in their context files

Don't wait for a "big insight." Small patterns compound.

## Decisions — `context/memory/decisions/`

Business or content decisions the user makes, with reasoning.

**Examples:**
- "Switching LinkedIn strategy from thought leadership to case studies — engagement was flat on opinion posts"
- "Pausing email newsletter until Q3 — not enough subscriber volume to justify the time"

**Format:** One file per decision, named by topic (e.g., `linkedin-strategy-shift.md`, `newsletter-paused.md`). Include: the decision, the reasoning, the date, and any conditions for revisiting.

**When to write — specific triggers:**
- The user says "let's do X instead of Y" or "I'm going with X"
- A strategy or direction changes (content strategy, pricing, project priority)
- The user sets a deadline or condition ("if X doesn't happen by Y, then Z")
- A new project starts or an existing one gets paused/killed
- Pricing, positioning, or business model choices

If the user made a choice with reasoning, it's a decision. Log it.

## Ideas — `context/memory/ideas/`

Brainstorms, content ideas, campaign concepts, things to try later.

**Format:** One file per idea, named descriptively. Include: the core concept, why it came up, and the user's gut reaction.

**When to write — specific triggers:**
- Any brainstorm conversation (even if nothing gets picked)
- "What if we..." or "I've been thinking about..." from the user
- Content ideas that came up but aren't being written yet
- Feature ideas for existing projects
- Business opportunities or partnership concepts

Don't filter too hard — the point is capture, not curation. Write it down even if it's half-baked.

## Retention

- **Sessions:** Keep last 60 days. Older logs can be archived or deleted.
- **Learnings, Decisions, Ideas:** Keep indefinitely. Review and prune when they become stale.
