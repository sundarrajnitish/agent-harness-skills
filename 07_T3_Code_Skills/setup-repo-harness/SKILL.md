---
name: setup-repo-harness
description: >-
  Use when setting up a repo for T3 Code or Claude Code — scaffolds CLAUDE.md/AGENTS.md, least-privilege settings.json, and PreToolUse/PostToolUse safety hooks.
---

# Bootstrap Repo Harness `[SETUP]`

Turn a bare repository into a safe, high-signal workspace so coding agents stop rediscovering conventions, burning tokens, or running destructive commands.

## Required Inputs
Inspect the repository first (do not ask for what you can read from `package.json`, `pyproject.toml`, `Makefile`, `Cargo.toml`, `go.mod`, or `.git`). Ask only if genuinely ambiguous:
1. Target harness files to create (`CLAUDE.md`, `AGENTS.md`, `.claude/settings.json`, hooks).
2. Any frozen/legacy directories or project-specific "never do" rules.

## Workflow

1. **Explore read-only first**
   - Identify stack, package manager, dev/build/test/lint/format/typecheck commands, directory layout, and database/migration tools.
   - Check for existing `CLAUDE.md`, `AGENTS.md`, or `.claude/settings.json` so you merge rather than clobber.

2. **Generate concise standing context (`CLAUDE.md` and/or `AGENTS.md`)**
   Keep it under ~60 lines of high-signal facts:
   - **What this is**: 1–2 sentences + stack.
   - **Commands**: exact dev, test, lint, format, typecheck commands (note that tests must pass before work is done).
   - **Conventions**: 3–6 concrete codebase invariants (e.g., money in integer cents, UTC dates, thin handlers).
   - **Workflow**: plan before editing >2–3 files; one commit per task; use subagents for wide exploration.
   - **Never do**: frozen paths, secrets/PII rules, destructive DB commands.

3. **Configure least-privilege permissions (`.claude/settings.json`)**
   Use [settings-template.json](./references/settings-template.json) as a baseline and adapt commands to the repo's stack:
   - `allow`: read repo, edit source/tests, run safe test/lint/git-read commands.
   - `deny`: `Read(./.env)`, `Read(./.env.*)`, `Read(./secrets/**)`, `Bash(rm -rf *)`, `Bash(git push *)`.

4. **Install deterministic hooks**
   - **PreToolUse (Bash)**: copy [block-destructive-db.sh](./scripts/block-destructive-db.sh) to `.claude/hooks/block-destructive-db.sh` and `chmod +x` it. Blocks `db:reset`, `migrate:fresh`, `DROP TABLE/DATABASE`, and `TRUNCATE` unless `LOCAL_ONLY=1`.
   - **PostToolUse (Edit|Write)**: wire the repo's real formatter + typechecker so the agent sees and fixes errors immediately.
   - Use the nested Claude Code hook syntax: `{"matcher": "...", "hooks": [{"type": "command", "command": "..."}]}`.

5. **Verify**
   - Validate `.claude/settings.json` parses as valid JSON.
   - Test the PreToolUse hook script with a mock JSON payload (`echo '{"tool_input":{"command":"DROP TABLE users"}}' | .claude/hooks/block-destructive-db.sh`) and confirm it exits with code `2`.
   - Report created/updated files and any commands you could not verify locally.

## Rules / Never
- **Never** invent commands—verify every command exists in the repo's config files.
- **Never** dump a 300-line manual into `CLAUDE.md`; every line eats context on every turn.
- **Never** allow reading `.env` or `secrets/**` or running `rm -rf` / `git push` in default allow rules.
- **Never** overwrite existing `CLAUDE.md` or `settings.json` without showing or preserving existing rules.
- **Externalize memory** for long-running work: point `CLAUDE.md` at a progress file / feature list and git history so each new session can pick up where the last stopped. See [HARNESS_PRINCIPLES.md](../../HARNESS_PRINCIPLES.md).
- **Keep the tool surface small**; a few model-friendly tools beat many overlapping ones.
