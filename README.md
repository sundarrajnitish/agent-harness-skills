# agent-harness-skills

A curated, drop-in library of **13 reusable AI agent skills** and foundational engineering principles for **T3 Code**, **Claude Code**, and **Antigravity**.

Every skill is prefixed by **when you use it** (`/setup-*`, `/plan-*`, `/code-*`, `/check-*`, `/wiki-*`) with a front-loaded `Use when…` description so typing `/` in your chat composer immediately shows the right skill for the moment.

---

## Start Here: Basic Principles

Read **[PRINCIPLES.md](PRINCIPLES.md)** for the foundational **Harness → Loop → Graph** 7-level maturity ladder:
- **Harness** (environment, minimal tools, external disk memory, real permission walls)
- **Loop** (evidence hierarchy, check-first design, converging `EXPECTED/SAW/FENCE/DEAD ENDS` feedback, hard exits)
- **Graph** (early-start parallelism, isolated contexts, freeze-on-pass, cost-of-undo gates, and layer-targeted learning)

---

## Slash-Command Skill Catalog

### `/setup-*` — Configure Repos, MCP & Skills
| Slash Command | When to Use It |
|---|---|
| [`/setup-repo-harness`](07_T3_Code_Skills/setup-repo-harness/SKILL.md) | Starting or configuring a repo — scaffolds `CLAUDE.md`/`AGENTS.md`, least-privilege `settings.json`, and `PreToolUse`/`PostToolUse` safety hooks. |
| [`/setup-mcp-safely`](07_T3_Code_Skills/setup-mcp-safely/SKILL.md) | Connecting or designing an MCP server — enforces read-only defaults, env-var secrets, tool restraint, and a confused-deputy threat model. |
| [`/setup-new-skill`](07_T3_Code_Skills/setup-new-skill/SKILL.md) | Creating, refactoring, or trigger-testing a reusable `SKILL.md` package without trigger collisions. |

### `/plan-*` — Design Workflows, Context & Prompts Before Coding
| Slash Command | When to Use It |
|---|---|
| [`/plan-ai-workflow`](07_T3_Code_Skills/plan-ai-workflow/SKILL.md) | Before coding an AI feature — applies the Complexity Ladder (single call vs. chain vs. router vs. agent), per-step model routing, and blast-radius gates. |
| [`/plan-context-pack`](07_T3_Code_Skills/plan-context-pack/SKILL.md) | Packing agent context (`LLM = CPU, context = RAM`), writing declarative success-criteria briefs, isolating noisy subagents, or fixing context rot. |
| [`/plan-system-prompt`](07_T3_Code_Skills/plan-system-prompt/SKILL.md) | Writing, refactoring, or meta-prompt-debugging a system/user prompt with the 5-ingredient check, few-shot examples, strict JSON schemas, and injection guards. |

### `/code-*` — Write, Harden & Optimize Code
| Slash Command | When to Use It |
|---|---|
| [`/code-karpathy-rules`](07_T3_Code_Skills/code-karpathy-rules/SKILL.md) | Writing, fixing, or refactoring code — enforces Karpathy's 4 rules: Think Before Coding, Simplicity First, Surgical Changes, and Goal-Driven test loops. |
| [`/code-harden-llm`](07_T3_Code_Skills/code-harden-llm/SKILL.md) | Productionizing or auditing LLM/API code — adds centralized model config, retries with backoff, schema validation, idempotency, HITL queues, caching, and alerts. |
| [`/code-autoresearch-loop`](07_T3_Code_Skills/code-autoresearch-loop/SKILL.md) | Running autonomous optimization experiments (ML, latency, evals, bundle size) — sets up immutable judge, mutable target, `program.md`, `results.tsv`, and Git ratchet. |

### `/check-*` — Verify, Evaluate & Diagnose
| Slash Command | When to Use It |
|---|---|
| [`/check-verify-audit`](07_T3_Code_Skills/check-verify-audit/SKILL.md) | Before shipping high-stakes code, diffs, docs, or decisions — runs Claim Ledger sourcing (`UNSOURCED` flags), number reconciliation, skeptical PR review, and devil's advocate. |
| [`/check-llm-evals`](07_T3_Code_Skills/check-llm-evals/SKILL.md) | Testing a prompt systematically or comparing/downgrading models — builds a 10–20 row real-world eval dataset, pre-run rubric, and benchmark runner. |
| [`/check-agent-ladder`](07_T3_Code_Skills/check-agent-ladder/SKILL.md) | Diagnosing failing or looping agent setups — applies the 7-level Harness → Loop → Graph ladder, check-first design, undo-cost gates, and layer-targeted fixes. |

### `/wiki-*` — Compile Persistent Knowledge
| Slash Command | When to Use It |
|---|---|
| [`/wiki-llm-knowledge`](07_T3_Code_Skills/wiki-llm-knowledge/SKILL.md) | Building or updating a persistent local Markdown wiki (`raw/`, `wiki/`, `index.md`, `log.md`) via `init`, `ingest`, `query`, or `lint` instead of RAG. |

---

## Installation

### Per-project (recommended)
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
