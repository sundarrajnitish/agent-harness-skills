---
name: author-agent-skill
description: >-
  Designs, writes, and trigger-tests a reusable agent Skill package (SKILL.md plus
  optional scripts/ and references/) for T3 Code, Antigravity, or Claude Code. Use
  whenever the user asks to create a new skill, turn a recurring workflow into a
  skill, refactor an existing SKILL.md, fix a skill that fails to trigger, or audit
  a skills folder for trigger collisions.
---

# Author Agent Skill `[SETUP]`

Package recurring, opinionated expertise into a lean, on-demand `SKILL.md` that triggers reliably and produces consistent outputs across projects.

## Qualification Gate (Check First)
Before writing a skill, verify it passes all three checks:
1. **Recurring**: you would otherwise re-explain it.
2. **Opinionated**: there is a specific right shape or judgment call.
3. **≥3 concrete rules or steps**: if not, it is a one-off prompt, not a skill.

If it is actually a **connection to an external system** → use MCP instead. If it is an **always-on rule for one repo** → put it in `CLAUDE.md` / `AGENTS.md` instead.

## Required Inputs
If any of these are missing, ask before drafting:
1. The exact recurring task and target deliverable.
2. Target location (`.agents/skills/<name>/`, `.claude/skills/<name>/`, or a custom folder).
3. Any hard rules, output format requirements, or sample good/bad outputs.

## Workflow

1. **Choose a clean verb-noun name**
   - Lowercase, hyphenated, one job per skill (e.g., `audit-sql-migrations`, `draft-release-notes`).
   - Check existing skills in the target directory for trigger overlap.

2. **Write the YAML frontmatter (`name` + `description`)**
   Follow the trigger formula: **`[Deliverable] + [Situation] + [the phrasings people actually use]`**.
   - Write in third person.
   - Bad: `Incident reports.` or `Helps with various reports.`
   - Good: `Formats a post-incident report after a production outage. Use when the user asks to write up an incident, document an outage, create a postmortem, or record a system failure and resolution.`

3. **Structure `SKILL.md` for progressive disclosure**
   Keep `SKILL.md` concise (~40–100 lines). Put bulky templates, schemas, or examples in `references/` and deterministic calculations/transforms in `scripts/`.
   Include these sections in order:
   - **Goal**: 1–2 sentences stating what a good result is *for*.
   - **Required Inputs**: what must be provided; explicitly state `"If any required input is missing, ask. Do not guess."`
   - **Workflow / Steps**: numbered, imperative steps focusing specificity on *judgment*, not generic advice the model already knows.
   - **Rules / Never**: loud, flat imperatives for non-negotiables.
   - **Output Format / Verification**: exact shape and how to verify the result.

4. **Offload deterministic work to `scripts/`**
   - If the skill involves math, exact parsing, or repeatable shell checks, create a small script in `scripts/` and instruct the skill: `"Run scripts/<name>; never eyeball the math."`

5. **Run the Trigger & Output Test Plan**
   Provide 6 test prompts in your summary so the user can verify the skill:
   - **3 positive triggers**: one formal, one rushed/lazy, one synonym phrasing.
   - **3 negative triggers**: adjacent requests that must *not* fire this skill.
   - **Output checks**: format followed, missing-input check works, script invoked (if any).

## Rules / Never
- **Never** write vague descriptions ("helps with coding", "general assistant").
- **Never** duplicate general engineering knowledge the model already has.
- **Never** combine two unrelated jobs in one skill—split them.
- **Never** change five sentences at once when tuning a broken trigger; change one sentence and re-test.
