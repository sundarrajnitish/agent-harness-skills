---
name: design-stitch-system
description: >-
  Use when working with Google Stitch UI design — sets up the Stitch MCP server,
  extracts or maintains .stitch/DESIGN.md design tokens, enhances rough UI ideas
  into structured Stitch prompts, and generates or iterates UI screens and variants.
---

# Design with Google Stitch `[DESIGN]`

Bridge code and Google Stitch cleanly using a declarative `.stitch/DESIGN.md` spec, structured UI prompts, and the Stitch MCP server.

See [design-md-template.md](./references/design-md-template.md) for the starter `.stitch/DESIGN.md` and Stitch MCP configuration snippet.

## Required Inputs
Inspect the repo first (check for `.stitch/DESIGN.md`, existing CSS/Tailwind tokens, and MCP config). Ask only if missing:
1. Target workflow: **`setup-mcp`**, **`extract-design-md`**, **`enhance-prompt`**, or **`generate-screens`**.
2. Platform (Web / Mobile) and the screen or feature goal.

## Workflow

### 1. `setup-mcp` — Connect Google Stitch MCP Safely
- Configure `@google-labs/stitch-mcp` with `GOOGLE_CLOUD_PROJECT` passed via environment variable (never hardcode credentials or commit tokens).
- Remind the user to authenticate locally (`gcloud auth login` / application default credentials) and enable the Stitch API on their GCP project.

### 2. `extract-design-md` — Capture Design DNA into `.stitch/DESIGN.md`
- Scan the repo's styling layer (CSS variables, Tailwind config, theme tokens, typography, key layouts).
- Write `.stitch/DESIGN.md` using **design intent and semantic roles** rather than framework-specific utility class dumps:
  - **Project Metadata**: name, target platform, Stitch Project ID (if linked).
  - **Visual Theme & Atmosphere**: tone, density, elevation/surface philosophy.
  - **Color Palette & Semantic Roles**: `surface-primary`, `surface-elevated`, `text-primary`, `text-muted`, `action-primary`, `border-subtle`, status roles.
  - **Typography & Layout Rules**: font families, scale hierarchy, spacing rhythm, corner radii, responsive breakpoints.
- Sync `.stitch/DESIGN.md` back to Stitch when generating new screens so branding stays consistent.

### 3. `enhance-prompt` — Turn Rough UI Ideas into High-Signal Stitch Prompts
Before calling Stitch to generate a screen:
1. Read `.stitch/DESIGN.md` if present and inject its theme, color roles, and typography rules into a dedicated **Design System** block.
2. Fill missing requirements (platform, viewport, page type, key states like empty/loading/error).
3. Translate vague phrasing (*"make it look cool"*) into concrete UI/UX terms (layout grid, hierarchy, card density, primary CTA placement, navigation pattern).
4. Structure the final prompt into numbered visual sections (Header/Nav → Hero/Summary → Main Workspace/Content → Secondary Rail/Actions → States).

### 4. `generate-screens` — Generate & Iterate via Stitch MCP
- Generate the screen (or 2–3 targeted variants, e.g., light/dark or layout alternatives) using the enhanced prompt and `.stitch/DESIGN.md`.
- Keep iterations focused: edit one layout or visual dimension at a time instead of regenerating everything from scratch.

## Rules / Never
- **Never** dump raw Tailwind/CSS utility classes into `.stitch/DESIGN.md` without semantic roles.
- **Never** commit GCP credentials, tokens, or private keys into MCP config files.
- **Never** send a 5-word vague prompt to Stitch when `.stitch/DESIGN.md` exists—always inject the project's design DNA first.
- **Never** regenerate already-approved screens unnecessarily; iterate on targeted variants.
