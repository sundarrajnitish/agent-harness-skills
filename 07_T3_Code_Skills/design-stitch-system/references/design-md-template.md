# Google Stitch Starter Templates

## 1. Starter `.stitch/DESIGN.md`
```markdown
# Project: [APP NAME]
- **Platform:** [Web / Mobile]
- **Stitch Project ID:** `projects/[ID]` (optional)

## Visual Theme & Atmosphere
[2–3 sentences describing mood, visual density, contrast, and surface hierarchy.]

## Color Palette & Semantic Roles
- **Primary Surface:** [color description + hex] — main canvas background
- **Elevated Surface:** [color description + hex] — cards, modals, popovers
- **Primary Text:** [color description + hex] — headings and body copy
- **Muted Text:** [color description + hex] — metadata, captions, secondary labels
- **Primary Action (CTA):** [color description + hex] — main buttons and active links
- **Border / Divider:** [color description + hex] — subtle structural separation
- **Status (Success / Warning / Destructive):** [semantic colors]

## Typography
- **Display / Headings:** [font family, weight, tracking]
- **Body:** [font family, base size, line-height]
- **Mono / Data:** [font family for metrics, code, tables]

## Layout & Component Rules
- **Spacing rhythm:** [e.g., 4px/8px grid, generous section breathing room]
- **Radii & elevation:** [e.g., crisp 8px corners, 1px hairline borders over heavy shadows]
- **Navigation pattern:** [e.g., collapsible left sidebar + compact top bar]
```

## 2. Stitch MCP Config Snippet
```json
{
  "mcpServers": {
    "stitch": {
      "command": "npx",
      "args": ["-y", "@google-labs/stitch-mcp"],
      "env": {
        "GOOGLE_CLOUD_PROJECT": "${GOOGLE_CLOUD_PROJECT}"
      }
    }
  }
}
```
