# Colour Extraction Script

JavaScript function to execute via `mcp__chrome-devtools__evaluate_script` for extracting brand colours and fonts from a webpage.

## Script

```javascript
() => {
    const getStyle = (el, prop) => el ? getComputedStyle(el).getPropertyValue(prop).trim() : null;

    const colorMap = {};
    const addColor = (color, context) => {
        if (!color || color === 'transparent' || color === 'rgba(0, 0, 0, 0)') return;
        // Skip oklab/oklch (usually semi-transparent overlays, not brand colours)
        if (color.startsWith('oklab') || color.startsWith('oklch')) return;
        if (!colorMap[color]) {
            colorMap[color] = { count: 0, contexts: [] };
        }
        colorMap[color].count++;
        if (!colorMap[color].contexts.includes(context)) {
            colorMap[color].contexts.push(context);
        }
    };

    // Extract rgb() colours from gradient strings
    const extractGradientColors = (gradientStr, context) => {
        if (!gradientStr || gradientStr === 'none') return;
        const rgbPattern = /rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)/g;
        let match;
        while ((match = rgbPattern.exec(gradientStr)) !== null) {
            const r = parseInt(match[1]), g = parseInt(match[2]), b = parseInt(match[3]);
            // Skip near-black, near-white, and very low-opacity/transparent gradient stops
            if (r + g + b < 15) continue;       // near-black
            if (r > 245 && g > 245 && b > 245) continue; // near-white
            addColor(match[0], context);
        }
    };

    // Navigation
    const nav = document.querySelector('nav, header, [class*="nav"], [class*="header"]');
    if (nav) {
        addColor(getStyle(nav, 'background-color'), 'navigation-bg');
        extractGradientColors(getStyle(nav, 'background-image'), 'navigation-bg');
        addColor(getStyle(nav, 'color'), 'navigation-text');
    }

    // Headings
    const h1 = document.querySelector('h1');
    if (h1) {
        addColor(getStyle(h1, 'color'), 'h1-text');
        extractGradientColors(getStyle(h1, 'background-image'), 'h1-text');
    }

    const h2s = document.querySelectorAll('h2');
    h2s.forEach((h2, i) => {
        if (i < 5) {
            addColor(getStyle(h2, 'color'), 'h2-text');
            addColor(getStyle(h2, 'background-color'), 'h2-bg');
            extractGradientColors(getStyle(h2, 'background-image'), 'h2-bg');
        }
    });

    // Body
    const body = document.body;
    addColor(getStyle(body, 'background-color'), 'body-bg');
    addColor(getStyle(body, 'color'), 'body-text');

    // CTA buttons — class-based selectors
    const ctaSelectors = [
        'a[class*="btn"]', 'button[class*="btn"]',
        'a[class*="cta"]', 'button[class*="cta"]',
        '.hero a', '.hero button',
        'a[class*="button"]', 'button[class*="primary"]',
        'a[class*="action"]', 'button[class*="action"]',
        '[class*="cta"]', '[class*="signup"]',
        'a[class*="primary"]'
    ];
    const ctaButtons = document.querySelectorAll(ctaSelectors.join(', '));
    ctaButtons.forEach((btn, i) => {
        if (i < 5) {
            addColor(getStyle(btn, 'background-color'), 'cta-bg');
            extractGradientColors(getStyle(btn, 'background-image'), 'cta-bg');
            addColor(getStyle(btn, 'color'), 'cta-text');
        }
    });

    // CTA buttons — visual detection (any a/button with a non-trivial bg)
    const allClickables = document.querySelectorAll('a, button');
    let visualCtaCount = 0;
    allClickables.forEach((el) => {
        if (visualCtaCount >= 10) return;
        const bg = getStyle(el, 'background-color');
        const bgImage = getStyle(el, 'background-image');
        const hasSolidBg = bg && bg !== 'transparent' && bg !== 'rgba(0, 0, 0, 0)'
            && !bg.startsWith('rgb(255') && !bg.startsWith('rgb(250')
            && !bg.startsWith('rgb(28,') && !bg.startsWith('oklab');
        const hasGradientBg = bgImage && bgImage !== 'none' && bgImage.includes('gradient');
        if (hasSolidBg || hasGradientBg) {
            if (hasSolidBg) addColor(bg, 'cta-bg');
            if (hasGradientBg) extractGradientColors(bgImage, 'cta-bg');
            addColor(getStyle(el, 'color'), 'cta-text');
            visualCtaCount++;
        }
    });

    // Links
    const links = document.querySelectorAll('a:not([class*="nav"]):not([class*="btn"]):not([class*="cta"])');
    links.forEach((link, i) => {
        if (i < 5) {
            addColor(getStyle(link, 'color'), 'link-text');
        }
    });

    // Sections with background colours AND gradients
    const sections = document.querySelectorAll('section, [class*="section"], [class*="banner"], [class*="hero"]');
    sections.forEach((section, i) => {
        if (i < 5) {
            addColor(getStyle(section, 'background-color'), 'section-bg');
            extractGradientColors(getStyle(section, 'background-image'), 'section-bg');
        }
    });

    // Footer
    const footer = document.querySelector('footer, [class*="footer"]');
    if (footer) {
        addColor(getStyle(footer, 'background-color'), 'footer-bg');
        extractGradientColors(getStyle(footer, 'background-image'), 'footer-bg');
        addColor(getStyle(footer, 'color'), 'footer-text');
    }

    // Build sorted colour list
    const colors = Object.entries(colorMap)
        .map(([value, data]) => ({
            value,
            count: data.count,
            contexts: data.contexts
        }))
        .sort((a, b) => b.count - a.count);

    // Extract fonts
    const fonts = {
        heading: getStyle(h1, 'font-family') || getStyle(document.querySelector('h2'), 'font-family') || null,
        body: getStyle(body, 'font-family') || null
    };

    return { colors, fonts };
}
```

## Usage

Execute via Chrome DevTools MCP:

```
mcp__chrome-devtools__evaluate_script
  function: <script above>
```

## Return Format

```json
{
    "colors": [
        {
            "value": "rgb(26, 26, 46)",
            "count": 4,
            "contexts": ["navigation-bg", "h1-text", "footer-bg"]
        }
    ],
    "fonts": {
        "heading": "'Montserrat', sans-serif",
        "body": "'Open Sans', sans-serif"
    }
}
```

## Processing Notes

After receiving results:
1. Convert RGB values to hex (e.g., `rgb(26, 26, 46)` → `#1a1a2e`)
2. Filter out `transparent`, pure white (`#ffffff`), and pure black (`#000000`)
3. Keep top 10 colours by frequency
4. Assign roles based on context tags (see SKILL.md Phase 3.3)

## Key Improvements Over Basic Extraction

- **Gradient parsing**: Extracts `rgb()` values from `linear-gradient()` and `radial-gradient()` in `background-image`. Many modern sites (especially Tailwind) use gradients instead of solid `background-color`.
- **Visual CTA detection**: Scans all `<a>` and `<button>` elements for non-trivial backgrounds, catching buttons that don't use class names like "btn" or "cta".
- **oklab/oklch filtering**: Skips modern colour formats used for semi-transparent overlays.
