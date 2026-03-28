# Brand Schema Reference

Schema documentation for `my-brand/brand.json` — the machine-readable branding data file.

## Schema

```json
{
  "schemaVersion": "1.0",
  "company": {
    "name": "string (required) — Company or agency name",
    "tagline": "string (optional) — Short tagline or slogan",
    "email": "string (required) — Contact email for report footer",
    "website": "string (optional) — Website URL"
  },
  "colors": {
    "primary": "string (hex) — Headers, navigation, emphasis. e.g. #1a1a2e",
    "secondary": "string (hex) — Supporting elements, dark sections. e.g. #16213e",
    "accent": "string (hex) — CTAs, highlights, score badges. e.g. #e94560",
    "background": "string (hex) — Main background. Default: #ffffff",
    "backgroundAlt": "string (hex) — Alternate section background. Default: #f8f9fa",
    "text": "string (hex) — Body text. Default: #333333",
    "textLight": "string (hex) — Secondary/muted text. Default: #666666"
  },
  "fonts": {
    "heading": "string — Heading font family. e.g. Inter, Montserrat",
    "body": "string — Body font family. e.g. Inter, Open Sans"
  },
  "logo": {
    "path": "string — Logo filename relative to my-brand/. e.g. logo.png",
    "exists": "boolean — Whether the logo file is present"
  },
  "createdAt": "string (ISO 8601) — When branding was first created",
  "updatedAt": "string (ISO 8601) — When branding was last modified"
}
```

## Example

```json
{
  "schemaVersion": "1.0",
  "company": {
    "name": "Pitcocy Digital",
    "tagline": "Google Ads That Actually Work",
    "email": "hello@pitcocy.com",
    "website": "https://pitcocy.com"
  },
  "colors": {
    "primary": "#1a1a2e",
    "secondary": "#16213e",
    "accent": "#e94560",
    "background": "#ffffff",
    "backgroundAlt": "#f8f9fa",
    "text": "#333333",
    "textLight": "#666666"
  },
  "fonts": {
    "heading": "Inter",
    "body": "Inter"
  },
  "logo": {
    "path": "logo.png",
    "exists": true
  },
  "createdAt": "2026-03-26T10:00:00Z",
  "updatedAt": "2026-03-26T10:00:00Z"
}
```

## Colour Defaults

When the user doesn't specify or extraction fails, use these defaults:

| Role | Default | Usage |
|------|---------|-------|
| primary | `#1a1a2e` | Dark navy — professional, neutral |
| secondary | `#16213e` | Slightly lighter navy |
| accent | `#e94560` | Coral red — high contrast CTA |
| background | `#ffffff` | White |
| backgroundAlt | `#f8f9fa` | Light grey for alternating sections |
| text | `#333333` | Near-black body text |
| textLight | `#666666` | Muted secondary text |

## Font Defaults

| Role | Default |
|------|---------|
| heading | `system-ui, -apple-system, sans-serif` |
| body | `system-ui, -apple-system, sans-serif` |

When a Google Font name is specified (e.g., "Inter", "Montserrat"), the HTML template will include a Google Fonts `<link>` tag in the `<head>`.

## Validation Rules

- All hex colours must be 7 characters: `#` + 6 hex digits (e.g., `#e94560`)
- Company name must be non-empty
- Contact email must contain `@`
- Logo path must be a filename (no directory traversal)
- `schemaVersion` must be `"1.0"`
