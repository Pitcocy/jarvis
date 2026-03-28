---
name: business-context
description: |
  Structured interview to create or update context/business.md — business model,
  unit economics, goals, marketing channels, competitive landscape, and constraints.
  Run from inside a client folder. Channel-agnostic.
---

# Business Context Gatherer

Conduct a structured interview to create or update `context/business.md` — the most important context file for any client. Every downstream skill reads this file for targets, constraints, and strategic context.

Works for any marketing channel — Google Ads, Meta, LinkedIn, Email, SEO, Content, or any combination.

## Command Format

```
/business-context [--quick] [--update]
```

- `/business-context` — Full interview (all sections)
- `/business-context --quick` — Sections 1-3 only (Business Model, Unit Economics, Goals)
- `/business-context --update` — Review existing business.md, update only what changed

## Domain Rules (Non-Negotiable)

1. **Never skip unit economics.** Without margins, CLV, and CAC, no skill can set meaningful targets. If the user can't provide inputs, mark as `[Not provided — ask in follow-up]` and flag in Gaps.

2. **Goals must be specific and measurable.** "Grow leads" is not acceptable. "Grow monthly leads from 100 to 150 by Q3" is. Apply the SMART framework.

3. **Validate feasibility immediately.** If targets are mathematically impossible given the unit economics, flag it during the Goals phase — don't wait.

4. **Do not assume, ask.** If there's ambiguity, ask the user. Their stated context overrides everything.

5. **Flag gaps, do not skip.** Every unanswered question appears in the Gaps section with a priority level.

---

## Process

### Phase 0: Check Location

Verify you're inside a client folder (should have a CLAUDE.md with client context). If not, ask the user which client this is for.

Check for existing files:
- `context/business.md` — if exists, offer Update mode
- `context/brand.md` — pre-populate company info if available

### Phase 1: Entry & Mode Selection

**If `context/business.md` exists:** Ask create or update?
**Then ask interview mode:** Full / Quick / Custom

**Ask business vertical:**
- Lead Gen (B2B)
- Lead Gen (B2C)
- SaaS
- Ecommerce
- Services (agencies, consultants, etc.)

This determines which unit economics questions to ask.

### Phase 2: Business Model

Ask:
1. What do they sell? (Products, services, subscriptions — be specific)
2. Who do they sell to? (B2B/B2C, verticals, customer profile)
3. Average order value / deal value / ARPU?
4. Typical sales cycle? (Immediate, days, weeks, months)

Follow up with vertical-specific questions (e.g., return rate for ecommerce, churn for SaaS, lead-to-sale rate for lead gen).

### Phase 3: Unit Economics

**NEVER skip this section.** Even in Quick mode.

Ask vertical-specific inputs:

**Ecommerce:** AOV, COGS per order, shipping cost, payment fees, return rate, current ROAS
**Lead Gen:** Average deal value, profit margin %, lead-to-sale rate, sales cycle, current CPA
**SaaS:** MRR, active customers, monthly churn, gross margin %, current CAC, trial-to-paid rate
**Services:** Average project value, profit margin %, close rate, current CPA

Calculate and present: break-even CPA/ROAS, CLV, viable acquisition cost range.

Flag any critical issues immediately (e.g., target CPA below break-even).

### Phase 4: Goals & KPIs

Ask:
1. **Primary goal type:** Growth / Efficiency / Balanced
2. **Primary KPI:** CPA, ROAS, Conversions, Revenue, Leads, or custom
3. **Specific targets:** Target value, hard constraint (floor/ceiling), monthly budget
4. **Guardrail KPIs:** What secondary metrics protect against over-optimization?

Cross-check targets against unit economics from Phase 3.

### Phase 5: Marketing Channels & Priorities

**Skip in Quick mode.**

Ask:
1. Which marketing channels are active? (Google Ads, Meta Ads, LinkedIn, Email, SEO, Content, etc.)
2. Budget allocation across channels (rough %)
3. Which channels are highest priority for optimization?
4. Any channels planned to start or stop?
5. Are channels managed in-house or by the user?

### Phase 6: Competitive Landscape

**Skip in Quick mode.**

Ask:
1. Top 3-5 competitors (name and URL)
2. How the client differentiates from each
3. Competitive strategy: Aggressive / Defensive / Opportunistic
4. Any competitive intelligence worth noting

### Phase 7: Constraints & Context

**Skip in Quick mode.**

Ask:
1. Ad copy / content approval process (none / internal / legal / client approval)
2. Landing page / website change speed (same day / days / weeks / can't change)
3. Brand guidelines strictness (none / light / strict)
4. Team dependencies (dev for tracking, design for creatives, etc.)
5. Reporting cadence (weekly / bi-weekly / monthly)
6. Seasonality (strong / mild / none — if yes, describe peak/slow periods)
7. Historical context (what's been tried before, what worked, what failed)

### Phase 8: Validation & Output

1. **Cross-check** all targets against unit economics
2. **Flag** any feasibility issues
3. **List** all gaps with priority levels
4. **Generate** `context/business.md` with all sections filled in
5. **Present** summary with gaps, issues, and suggested next steps

## Output Format

Write to `context/business.md` using this structure:

```markdown
# Business Context — {Client Name}

*Last updated: {date} | Next review: {date + 90 days}*

## Business Model
{What they sell, who they sell to, pricing, sales cycle}

## Unit Economics

| Metric | Value |
|--------|-------|
| {vertical-specific calculated metrics} |

**Viability:** {Go / Conditional / No-Go}

## Goals & KPIs

**Primary Focus:** {Growth / Efficiency / Balanced}
**Primary KPI:** {metric} — Target: {value} | Hard Constraint: {value}
**Monthly Budget:** {value}

### Guardrails
{Secondary metrics and thresholds}

## Marketing Channels

| Channel | Status | Budget % | Priority |
|---------|--------|----------|----------|
| {channels} |

## Competitive Landscape

**Strategy:** {Aggressive / Defensive / Opportunistic}

| Competitor | URL | Differentiation |
|-----------|-----|-----------------|
| {competitors} |

## Constraints
{Approval processes, brand guidelines, dependencies, reporting}

## Seasonal Patterns
{Peak/slow periods, upcoming events}

## Historical Context
{What's been tried, what worked, what failed}

## Gaps
{Unanswered items with priority: Critical / Warning / Info}
```

## After Output

Suggest next steps:
1. Review `context/business.md` for accuracy
2. Address Critical gaps with `/business-context --update`
3. Run `/brand-context {url}` to gather brand context from their website
