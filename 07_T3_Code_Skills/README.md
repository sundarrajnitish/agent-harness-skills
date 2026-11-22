# T3 Code Skills Library

A curated library of **12 drop-in skills** for **T3 Code**, **Claude Code**, and **Antigravity**:
- **8 AI engineering & harness skills** (repo setup, skill authoring, MCP security, workflow architecture, production hardening, prompt craft, evals, and verification)
- **4 Karpathy-style agentic engineering skills** (coding guidelines, LLM wiki, autoresearch loop, and context engineering)

Each skill is self-contained in its own folder with a `SKILL.md` (plus `scripts/` or `references/` where useful).

---

## Part 1 — AI Engineering & Harness Skills (8)

| Label | Skill | What It Does |
|---|---|---|
| **`[SETUP]`** | [`bootstrap-repo-harness`](bootstrap-repo-harness/SKILL.md) | Scaffolds `CLAUDE.md`/`AGENTS.md`, least-privilege `settings.json`, `PreToolUse`/`PostToolUse` hooks, and starter commands for a repo. |
| **`[SETUP]`** | [`author-agent-skill`](author-agent-skill/SKILL.md) | Designs, writes, and trigger-tests a new `SKILL.md` package with progressive disclosure and zero trigger collisions. |
| **`[SETUP]`** | [`design-mcp-integration`](design-mcp-integration/SKILL.md) | Plans least-privilege MCP server configs or custom MCP tool specs with a confused-deputy threat model. |
| **`[ARCHITECTURE]`** | [`architect-ai-workflow`](architect-ai-workflow/SKILL.md) | Applies the Complexity Ladder ("earn the agent") and 6 automation patterns to spec an AI workflow before coding. |
| **`[PRODUCTION]`** | [`harden-llm-pipeline`](harden-llm-pipeline/SKILL.md) | Audits or builds production LLM/API code: model routing, retries, schema validation, idempotency, HITL, caching, alerts. |
| **`[PROMPTING]`** | [`craft-system-prompt`](craft-system-prompt/SKILL.md) | Writes, refactors, or debugs prompts using the 5-ingredient check, few-shot examples, structured schemas, and injection guards. |
| **`[EVALS]`** | [`build-llm-eval-suite`](build-llm-eval-suite/SKILL.md) | Builds a 10–20 row real-world eval dataset, pre-run rubric, and scoring workflow to tune prompts or compare models. |
| **`[VERIFICATION]`** | [`verify-and-audit-output`](verify-and-audit-output/SKILL.md) | Runs Claim Ledger sourcing, number reconciliation, blast-radius checks, and devil's-advocate review on high-stakes outputs. |

---

## Part 2 — Karpathy-Style Agentic Engineering Skills (4)

| Label | Skill | What It Does |
|---|---|---|
| **`[CODING]`** | [`karpathy-coding-guidelines`](karpathy-coding-guidelines/SKILL.md) | Enforces 4 coding-agent guardrails: Think Before Coding, Simplicity First, Surgical Changes, and Goal-Driven Execution. |
| **`[KNOWLEDGE]`** | [`karpathy-llm-wiki`](karpathy-llm-wiki/SKILL.md) | Builds and operates a persistent, interlinked local Markdown wiki (`raw/`, `wiki/`, `index.md`, `log.md`) via `init`, `ingest`, `query`, and `lint`. |
| **`[OPTIMIZATION]`** | [`karpathy-autoresearch-loop`](karpathy-autoresearch-loop/SKILL.md) | Runs bounded autonomous optimization loops using the Contract of Three (immutable judge, mutable target, `program.md`), `results.tsv`, and a Git keep/discard ratchet. |
| **`[CONTEXT]`** | [`karpathy-context-engineering`](karpathy-context-engineering/SKILL.md) | Treats context as finite RAM: packs high-signal context, converts imperative asks into declarative success-criteria briefs, isolates subagents, and prevents context rot/slop. |

---

## How to Use in Any T3 Code Project

### Option 1: Copy specific skills into a project
```bash
mkdir -p /path/to/your-project/.agents/skills
cp -R 07_T3_Code_Skills/*/ /path/to/your-project/.agents/skills/
```

### Option 2: Install globally across all tools on this machine
```bash
for dest in "$HOME/.gemini/config/skills" "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$dest"
  cp -R 07_T3_Code_Skills/*/ "$dest/"
done
```
