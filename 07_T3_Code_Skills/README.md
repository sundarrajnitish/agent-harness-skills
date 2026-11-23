# T3 Code Skills Library

**15 drop-in skills** named by workflow phase so typing `/` in T3 Code, Claude Code, or Antigravity immediately tells you which skill to pick.

See [../PRINCIPLES.md](../PRINCIPLES.md) for the foundational **Harness → Loop → Graph** principles behind these skills.

---

## Quick `/` Picker

| Prefix | Slash Command | When to Use It |
|---|---|---|
| **`/setup`** | [`/setup-repo-harness`](setup-repo-harness/SKILL.md) | Setting up a repo: `CLAUDE.md`/`AGENTS.md`, `settings.json`, and safety hooks |
| **`/setup`** | [`/setup-mcp-safely`](setup-mcp-safely/SKILL.md) | Connecting or designing a least-privilege MCP server + threat model |
| **`/setup`** | [`/setup-new-skill`](setup-new-skill/SKILL.md) | Creating, refactoring, or trigger-testing a new `SKILL.md` |
| **`/plan`** | [`/plan-ai-workflow`](plan-ai-workflow/SKILL.md) | Before coding an AI feature: single call vs. chain vs. router vs. agent |
| **`/plan`** | [`/plan-context-pack`](plan-context-pack/SKILL.md) | Packing agent context (RAM), writing declarative briefs, fixing context rot |
| **`/plan`** | [`/plan-system-prompt`](plan-system-prompt/SKILL.md) | Writing, refactoring, or debugging a system/user prompt & JSON schema |
| **`/design`** | [`/design-stitch-system`](design-stitch-system/SKILL.md) | Google Stitch MCP setup, `.stitch/DESIGN.md`, prompt enhancement & screen generation |
| **`/design`** | [`/design-stitch-to-code`](design-stitch-to-code/SKILL.md) | Converting Google Stitch screens/exports into modular, typed frontend components |
| **`/code`** | [`/code-karpathy-rules`](code-karpathy-rules/SKILL.md) | Coding with surgical diffs, simplicity, explicit assumptions & test loops |
| **`/code`** | [`/code-harden-llm`](code-harden-llm/SKILL.md) | Productionizing LLM/API code (retries, validation, idempotency, HITL, cost) |
| **`/code`** | [`/code-autoresearch-loop`](code-autoresearch-loop/SKILL.md) | Running a time-boxed Git-ratchet optimization loop on a measurable metric |
| **`/check`** | [`/check-verify-audit`](check-verify-audit/SKILL.md) | Fact-checking claims, reconciling numbers, auditing PR diffs, devil's advocate |
| **`/check`** | [`/check-llm-evals`](check-llm-evals/SKILL.md) | Building a 10–20 row eval set & rubric to tune prompts or compare models |
| **`/check`** | [`/check-agent-ladder`](check-agent-ladder/SKILL.md) | Diagnosing failing agent loops on the 7-level Harness → Loop → Graph ladder |
| **`/wiki`** | [`/wiki-llm-knowledge`](wiki-llm-knowledge/SKILL.md) | Init, ingest, query, or lint a persistent local Markdown LLM wiki |

---

## Install Everywhere
```bash
for dest in "$HOME/.gemini/config/skills" "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$dest"
  cp -R 07_T3_Code_Skills/*/ "$dest/"
done
```
