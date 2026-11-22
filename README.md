# agent-harness-skills

A curated, drop-in library of **12 reusable AI agent skills** for **T3 Code**, **Claude Code**, and **Antigravity**.

Each skill is self-contained in its own folder with a progressive-disclosure `SKILL.md` (plus optional `scripts/` and `references/`) so agents load only the short trigger description until a task actually calls for it.

---

## Included Skills

### Part 1 — AI Engineering & Harness Skills (8)

| Label | Skill | Purpose |
|---|---|---|
| **`[SETUP]`** | [`bootstrap-repo-harness`](07_T3_Code_Skills/bootstrap-repo-harness/SKILL.md) | Scaffolds `CLAUDE.md`/`AGENTS.md`, least-privilege `.claude/settings.json`, `PreToolUse` DB-safety hook, and `PostToolUse` format/typecheck hooks. |
| **`[SETUP]`** | [`author-agent-skill`](07_T3_Code_Skills/author-agent-skill/SKILL.md) | Designs, writes, and trigger-tests new `SKILL.md` packages with progressive disclosure and zero trigger collisions. |
| **`[SETUP]`** | [`design-mcp-integration`](07_T3_Code_Skills/design-mcp-integration/SKILL.md) | Plans least-privilege MCP server configs or custom MCP tool specs with a confused-deputy threat model. |
| **`[ARCHITECTURE]`** | [`architect-ai-workflow`](07_T3_Code_Skills/architect-ai-workflow/SKILL.md) | Applies the Complexity Ladder ("earn the agent") and 6 automation patterns to spec an AI workflow, model routing, and blast-radius gates before coding. |
| **`[PRODUCTION]`** | [`harden-llm-pipeline`](07_T3_Code_Skills/harden-llm-pipeline/SKILL.md) | Audits or implements production LLM/API code: centralized model config, retries with backoff, strict schema validation, idempotency, HITL queues, caching/Batch API, and missing-output alerts. |
| **`[PROMPTING]`** | [`craft-system-prompt`](07_T3_Code_Skills/craft-system-prompt/SKILL.md) | Writes, refactors, or meta-prompt-debugs prompts using the 5-ingredient check, standing-order test, few-shot examples, structured schemas, and injection guards. |
| **`[EVALS]`** | [`build-llm-eval-suite`](07_T3_Code_Skills/build-llm-eval-suite/SKILL.md) | Creates a 10–20 row real-world eval dataset, pre-run scoring rubric, and lightweight runner to tune prompts or compare models. |
| **`[VERIFICATION]`** | [`verify-and-audit-output`](07_T3_Code_Skills/verify-and-audit-output/SKILL.md) | Runs Claim Ledger sourcing (`UNSOURCED` flags), number reconciliation, skeptical PR/diff review, and devil's-advocate critique with confidence bounds. |

### Part 2 — Karpathy-Style Agentic Engineering Skills (4)

| Label | Skill | Purpose |
|---|---|---|
| **`[CODING]`** | [`karpathy-coding-guidelines`](07_T3_Code_Skills/karpathy-coding-guidelines/SKILL.md) | Enforces 4 behavioral coding-agent guardrails: Think Before Coding, Simplicity First, Surgical Changes, and Goal-Driven Execution. |
| **`[KNOWLEDGE]`** | [`karpathy-llm-wiki`](07_T3_Code_Skills/karpathy-llm-wiki/SKILL.md) | Builds and operates a persistent, interlinked local Markdown wiki (`raw/`, `wiki/`, `index.md`, `log.md`) via `init`, `ingest`, `query`, and `lint`. |
| **`[OPTIMIZATION]`** | [`karpathy-autoresearch-loop`](07_T3_Code_Skills/karpathy-autoresearch-loop/SKILL.md) | Runs bounded autonomous optimization loops using the Contract of Three (immutable judge, mutable target, `program.md`), `results.tsv`, and a monotonic Git keep/discard ratchet. |
| **`[CONTEXT]`** | [`karpathy-context-engineering`](07_T3_Code_Skills/karpathy-context-engineering/SKILL.md) | Treats the context window as finite RAM: packs high-signal context, rewrites imperative prompts into declarative success-criteria briefs, isolates subagents, and prevents context rot and AI slop. |

---

## Harness Principles

[`HARNESS_PRINCIPLES.md`](HARNESS_PRINCIPLES.md) collects 6 rules for building agent harnesses, with the evidence behind them from Anthropic, OpenAI, Google/DeepMind, Microsoft, Meta and university research:

1. Treat harness + model as one system; report both when comparing.
2. Externalize memory: progress files, feature lists, traces.
3. Use a separate evaluator/verifier; self-grading is unreliable.
4. Go multi-agent only for parallelizable work, and budget ~15x tokens.
5. Route by capability: a strong model plans or advises, cheaper models execute.
6. Keep tool surfaces small and model-friendly.

---

## Installation

### Per-project (recommended)
Copy the skills into your project's `.agents/skills/` (T3 Code / Antigravity) or `.claude/skills/` (Claude Code):

```bash
mkdir -p /path/to/your-project/.agents/skills
cp -R 07_T3_Code_Skills/*/ /path/to/your-project/.agents/skills/
```

### Global (all projects on your machine)
```bash
for dest in "$HOME/.gemini/config/skills" "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$dest"
  cp -R 07_T3_Code_Skills/*/ "$dest/"
done
```

---

## License

Released under the [MIT License](LICENSE).
