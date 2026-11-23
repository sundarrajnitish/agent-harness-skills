---
name: design-stitch-to-code
description: >-
  Use when converting Google Stitch screens, exported HTML, or Stitch MCP design
  assets into clean, typed, modular frontend components (React, Next.js, Vite,
  Tailwind, etc.) aligned to your repository's existing design tokens and architecture.
---

# Convert Google Stitch to Code `[DESIGN]`

Translate finalized Google Stitch screens into production-ready, maintainable frontend components—never raw copy-pasted HTML soup.

## Required Inputs
Inspect the repository first (framework, styling system, component conventions, `.stitch/DESIGN.md`). Ask only if missing:
1. Source Stitch screen ID / MCP reference or exported HTML/screenshot path.
2. Target route or component directory in the repository.
3. Whether to wire live/mock data props or keep the component purely presentational.

## Workflow

1. **Fetch & Inspect Design Assets**
   - Retrieve the screen's HTML, metadata, and screenshot via Stitch MCP (or read the exported files).
   - Identify the visual hierarchy, repeated patterns, interactive controls, and responsive breakpoints.

2. **Map Tokens First (Zero Magic Values)**
   - Cross-reference `.stitch/DESIGN.md` with the repo's real theme (`tailwind.config`, CSS custom properties, design-system primitives).
   - Map every color, font, spacing, and radius to existing tokens; add missing semantic variables to the theme layer rather than scattering hardcoded hex codes.

3. **Decompose into Modular, Typed Components**
   - Split flat exported markup into clean, reusable components matching the repo's folder structure, naming conventions, and TypeScript prop types.
   - Reuse existing UI primitives (buttons, inputs, dialogs, icons) instead of re-implementing them.
   - Separate static sample/mock data into clean typed props or fixtures so wiring real APIs is trivial.

4. **Harden Semantics, Accessibility & States**
   - Replace `<div>` click handlers with proper `<button>` / `<a>` / landmark elements (`<header>`, `<main>`, `<nav>`).
   - Add accessible labels (`aria-label`, `alt`, keyboard focus states) and responsive behavior for mobile + desktop.
   - Handle key UI states cleanly (loading, empty, error) where applicable.

5. **Verify Deterministically**
   - Run the repo's real typecheck, lint, and build/test commands (`npm run typecheck`, `npm run lint`, `npm run build`, etc.) and fix every error before finishing.
   - Confirm no unused assets, dead inline `<style>` tags, or broken imports remain.

## Rules / Never
- **Never** dump raw Stitch HTML verbatim into a single monolithic component file.
- **Never** hardcode raw hex colors or inline styles when the project has design tokens or CSS variables.
- **Never** duplicate existing UI library components already present in the codebase.
- **Never** mark the conversion done without running the project's typecheck/build verification.
