---
name: brand-context
description: |
  Gather brand and marketing context from a client's website. Scrapes pages,
  extracts brand voice, audience, USPs, and optionally brand colours.
  Run from inside a client folder. Channel-agnostic.
---

# Brand Context Gatherer

Scrape a client's website and extract brand context — tone of voice, target audience, products/services, USPs, trust signals, and optionally brand colours. Outputs organized markdown files to `context/` for use across all marketing channels.

## Command Format

```
/brand-context <URL> [--pages <paths>]
```

**Examples:**
- `/brand-context https://acme.com` — Homepage + auto-discover pages
- `/brand-context https://acme.com --pages /about,/products,/pricing` — Specific pages

## Process

### Step 1: Check Location

Verify you're inside a client folder. If not, ask the user which client this is for.

### Step 2: Fetch Homepage

Use WebFetch to retrieve the homepage. Extract:
- All text content (headings, paragraphs, navigation, footer)
- All internal navigation links (for page discovery)

### Step 3: Discover Additional Pages

From the homepage navigation, identify pages to analyze:

**Priority order:**
1. `/about` or `/about-us` — Company information
2. `/products` or `/services` — Offerings
3. `/pricing` — Pricing details
4. `/contact` — Contact info
5. Any other prominent navigation links (max 15 pages)

If user specified `--pages`, use those instead.

### Step 4: Fetch All Pages

Fetch each discovered page with WebFetch. Extract all text content.

Handle errors gracefully:
- 404: Skip and note
- Timeout: Retry once, then skip
- Blocked: Note and continue

### Step 5: Extract Brand Colours (Optional)

If Chrome DevTools MCP is available:

1. Navigate to the homepage
2. Take a full-page screenshot for visual reference
3. Run a colour extraction script (evaluate JavaScript to get computed styles)
4. Extract top colours by frequency, assign roles (Primary, Accent, Background, Text)
5. **Visually verify** against the screenshot — override script results with what you can see
6. Write `context/brand-colours/palette.md`

**If Chrome DevTools is not available:** Skip gracefully. Note it in the summary.

### Step 6: Generate Brand Analysis

Combine all page content and analyze. Write `context/brand.md`:

```markdown
# Brand Context — {Company Name}

*Source: {url} | Pages analyzed: {count} | Last updated: {date}*

## Company Overview
- **Name:** {name}
- **Tagline:** {tagline if found}
- **Industry:** {industry}
- **Website:** {url}

## Tone of Voice
{Description of how they communicate — formal/casual, technical/accessible, etc.}

**Examples from their site:**
- "{actual quote from website}"
- "{actual quote from website}"

## Target Audience
{Who they're talking to — B2B/B2C, demographics, pain points}

## Products & Services
{What they offer, organized by category}

## Pricing
{Pricing info if found, otherwise "Not publicly listed"}

## Unique Selling Propositions
{What makes them different — extracted from their messaging}

## Trust Signals
{Testimonials, case studies, certifications, client logos, awards}

## Calls to Action
{Primary CTAs used on the site — "Get a Demo", "Start Free Trial", etc.}

## Key Messages
{Core marketing messages repeated across the site}
```

### Step 7: Save Page Content

Write individual page files to `context/website/pages/`:

```markdown
# {Page Title}

**URL:** {full_url}
**Fetched:** {date}

## Content
{extracted content}
```

### Step 8: Present Summary

```markdown
## Brand Context Gathered

**Website:** {url}
**Pages analyzed:** {count}

### Files Created
- `context/brand.md` — Full brand analysis
- `context/brand-colours/palette.md` — Brand colours *(if Chrome DevTools available)*
- `context/website/pages/*.md` — {count} page files

### Brand Colour Status
{Extracted with X colours / Skipped — Chrome DevTools not available}

### Quick Insights
- {insight about their positioning}
- {insight about their audience}
- {insight about their tone}

### Next Steps
1. Review `context/brand.md` for accuracy
2. Run `/business-context` if not done yet
3. Start creating content — brand voice is now available for reference
```

## Error Handling

| Error | Response |
|-------|----------|
| Invalid URL | Ask for a valid URL starting with https:// |
| Site unreachable | Suggest checking URL in browser, offer to try specific pages |
| No content extracted | Suggest specific pages or manual content paste |
| Chrome DevTools unavailable | Skip colour extraction, continue with text analysis |

## Output Location

All files created relative to the current working directory:
- `context/brand.md`
- `context/brand-colours/palette.md` (if colours extracted)
- `context/website/pages/*.md`
