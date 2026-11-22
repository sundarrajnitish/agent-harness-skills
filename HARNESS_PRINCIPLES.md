# Harness Principles

Rules and evidence for building agent harnesses, drawn from how Anthropic, OpenAI, Google/DeepMind, Microsoft, Meta and university labs build and use them.

> Source: research brief dated 22 Nov 2026, based on lab engineering blogs, papers and docs. Most numbers are lab-reported and not independently reproduced (see [Caveats](#caveats)).

A **harness** is everything around the model: the loop, tools, context management, memory, verification and stop rules.

---

## The 6 Rules

| # | Rule | Why (evidence) | Applied in |
|---|---|---|---|
| 1 | **Treat harness + model as one system.** Report both whenever you compare agents. | Harness-only changes moved LangChain Deep Agents 52.8% → 66.5% on Terminal Bench 2.0 with the model fixed; a position paper reports up to 15 pts of scaffold-only variation on SWE-bench Verified; ICML 2026 finds harness failure patterns replicate across models. | [`build-llm-eval-suite`](07_T3_Code_Skills/build-llm-eval-suite/SKILL.md) |
| 2 | **Externalize memory.** Progress files, feature lists, git history, traces, task/progress ledgers. | Anthropic's long-running harness treats sessions like engineers on shifts with no memory; Magentic-One keeps task + progress ledgers; Confucius uses long-term note-taking memory. | [`bootstrap-repo-harness`](07_T3_Code_Skills/bootstrap-repo-harness/SKILL.md), [`karpathy-context-engineering`](07_T3_Code_Skills/karpathy-context-engineering/SKILL.md) |
| 3 | **Use a separate evaluator/verifier.** Self-grading is unreliable. | Anthropic's three-agent harness added a few-shot-calibrated evaluator because agents over-praise their own work; LangChain's biggest gains came from self-verification + trace analysis; MAST lists task verification as one of 3 failure groups. | [`verify-and-audit-output`](07_T3_Code_Skills/verify-and-audit-output/SKILL.md) |
| 4 | **Go multi-agent only for breadth-first, parallelizable work**, and budget ~15x chat tokens. | Anthropic multi-agent research beat single-agent Opus by 90.2% at ~15x tokens; Google/DeepMind/MIT (180 configs) saw 39–70% drops on sequential reasoning; Berkeley MAST found gains over single agents often minimal. | [`architect-ai-workflow`](07_T3_Code_Skills/architect-ai-workflow/SKILL.md) |
| 5 | **Route by capability.** Strong model plans or advises; cheaper models execute. | Anthropic advisor strategy: Haiku + Opus advisor scored 41.2% vs 19.7% solo on BrowseComp, ~85% cheaper than Sonnet solo; AlphaEvolve reportedly uses Flash to explore, Pro to refine. | [`architect-ai-workflow`](07_T3_Code_Skills/architect-ai-workflow/SKILL.md), [`harden-llm-pipeline`](07_T3_Code_Skills/harden-llm-pipeline/SKILL.md) |
| 6 | **Keep tool surfaces small and model-friendly.** | Princeton SWE-agent: a purpose-built agent-computer interface (linting edits, file viewer, directory search) beats a raw shell. Secondary claim: Vercel went 80% → 100% after cutting 16 tools to bash (unverified). | [`design-mcp-integration`](07_T3_Code_Skills/design-mcp-integration/SKILL.md), [`architect-ai-workflow`](07_T3_Code_Skills/architect-ai-workflow/SKILL.md) |

### Supporting concepts

- **Context resets + handoff files.** For long runs, reset context and hand off through files instead of letting one window fill up. Anthropic saw "context anxiety" in Sonnet 4.5 without this.
- **Re-plan when stuck.** An orchestrator that tracks progress should detect stalls and re-plan (Magentic-One), not loop forever.
- **The context window is something the harness manages.** OpenAI's Codex loop counts context management as a core harness job, not something left to the model.
- **Harnesses can be optimized automatically.** Meta-Harness (outer loop where a coding agent edits harness code from prior traces) and Confucius's meta-agent (build-test-improve) both tune the scaffold itself. Pairs with [`karpathy-autoresearch-loop`](07_T3_Code_Skills/karpathy-autoresearch-loop/SKILL.md).
- **Pin subagents to models.** Claude Code subagents can each run on a different model (e.g. exploration on a cheap tier).

---

## Evidence by Lab

### Anthropic
- **Long-running coding harness (Nov 2025):** discrete memoryless sessions; the harness leaves structured artifacts (progress notes, feature lists, git history) for the next session.
- **Three-agent harness (Mar 2026, Anthropic Labs):** planner, generator, and a separate evaluator calibrated with few-shot examples. Context resets + handoff files were needed for Sonnet 4.5's "context anxiety".
- **Multi-agent Research (2025):** lead Opus 4 + Sonnet 4 subagents beat single-agent Opus 4 by 90.2% on an internal research eval, at ~15x chat tokens (single agents ~4x).
- **Advisor strategy:** Sonnet or Haiku executes end to end and consults Opus when stuck. Haiku + Opus advisor: 41.2% on BrowseComp vs 19.7% solo; ~85% cheaper per task than Sonnet solo, trailing it by 29% in score.
- **Claude Code subagents:** each can be pinned to its own model (per community guides, the built-in Explore agent runs on Haiku).

### OpenAI
- **Codex agent loop (Jan 2026):** the harness drives the model through the Responses API, calls tools, and manages the context window.
- **Agents SDK:** agents, handoffs, agents-as-tools, guardrails, sessions, tracing, and (2026) sandbox agents. Works with 100+ other LLMs, though community reports say non-OpenAI calls don't show in the built-in tracer.

### Google / DeepMind
- **AlphaEvolve:** evolutionary harness with an LLM ensemble, program database, prompt sampler and automated evaluators (Cloud docs call it an "agent harness"). Reportedly Flash explores widely, Pro refines.
- **AI Co-Scientist:** specialized generation, reflection and other agents running asynchronously.
- **ADK + A2A:** open-source, model-agnostic (via LiteLLM) multi-agent toolkit with an open agent-to-agent protocol.

### Microsoft Research
- **Magentic-One (AutoGen):** Orchestrator keeps a task ledger (facts, plan) and a progress ledger, re-plans when stuck, and delegates to WebSurfer, FileSurfer, Coder and Terminal agents. Evaluated on GAIA, AssistantBench, WebArena; open-sourced with AutoGenBench.

### Meta + Harvard
- **Confucius SDK / Code Agent:** orchestrator, long-term note-taking memory, modular tool extensions, and a meta-agent that builds and tunes agents (build-test-improve). Reports 59% Resolve@1 on SWE-Bench-Pro. A secondary source says Sonnet 4.5 in this scaffold (52.7%) beat Opus 4.5 in Anthropic's stock harness (52.0%).

### LangChain
- **Deep Agents CLI:** 52.8% → 66.5% on Terminal Bench 2.0 (Top 30 → Top 5) by changing only the harness (model fixed at gpt-5.2-codex). Self-verification and trace analysis helped most.

### Academic
- **Princeton, SWE-agent:** agent-computer interface beats a raw shell; 12.5% on SWE-bench at the time.
- **UC Berkeley, MAST:** 1,600+ annotated multi-agent traces → 14 failure modes in 3 groups: system design, inter-agent misalignment, task verification.
- **Google Research + DeepMind + MIT, scaling agent systems:** 180 configs across GPT, Gemini, Claude. Multi-agent helped parallelizable tasks, degraded sequential reasoning (39–70% drops).
- **Stanford / MIT / KRAFTON, Meta-Harness:** coding agent searches over harness code using prior traces. Cites up to a 6x gap from harness alone; beat hand-built baselines on TerminalBench-2; +7.7 pts on text classification with 4x fewer context tokens.

---

## How Strong Is the "Harness Matters" Evidence?

| Claim | Strength |
|---|---|
| Terminal-Bench 2 pass@1 69.7% → 77.0% with model fixed; up to 15 pts scaffold-only on SWE-bench Verified | Preprint (May 2026), not peer reviewed |
| Harness-specific failure patterns replicate across models | Peer reviewed (ICML 2026) |
| Opus 4.5 spread 45.9–55.4% across frameworks on SWE-bench Pro; Vercel 80% → 100% after cutting 16 tools to bash | Secondary blogs, not verified against primary sources |

---

## Caveats

- Most numbers are lab-reported on internal or public benchmarks and not independently reproduced.
- Cross-vendor mixing (e.g. Claude inside OpenAI's SDK) is supported by tooling, but there is little rigorous published evidence of its benefit. Most documented multi-model work mixes tiers within one vendor.
- Version names and scores change fast.

---

## Sources

- Anthropic, Effective harnesses for long-running agents: https://anthropic.com/engineering/effective-harnesses-for-long-running-agents
- Anthropic, Harness design for long-running application development: https://anthropic.com/engineering/harness-design-long-running-apps (InfoQ summary: https://www.infoq.com/news/2026/04/anthropic-three-agent-harness-ai)
- Anthropic, Multi-agent research system: https://www.anthropic.com/engineering/multi-agent-research-system
- Anthropic, The advisor strategy: https://claude.com/blog/the-advisor-strategy
- OpenAI, Unrolling the Codex agent loop: https://openai.com/index/unrolling-the-codex-agent-loop
- OpenAI Agents SDK: https://github.com/openai/openai-agents-python
- Google DeepMind, AlphaEvolve: https://deepmind.google/blog/alphaevolve-a-gemini-powered-coding-agent-for-designing-advanced-algorithms/ ; architecture docs: https://docs.cloud.google.com/gemini/enterprise/docs/alphaevolve/developer-guide/architecture-and-workflows
- Google Research, Scaling agent systems: https://research.google/blog/towards-a-science-of-scaling-agent-systems-when-and-why-agent-systems-work/ ; https://arxiv.org/abs/2512.08296
- Microsoft Research, Magentic-One: https://www.microsoft.com/en-us/research/articles/magentic-one/ ; https://arxiv.org/abs/2411.04468
- Meta/Harvard, Confucius Code Agent: https://arxiv.org/abs/2512.10398
- LangChain, Improving Deep Agents with harness engineering: https://blog.langchain.com/improving-deep-agents-with-harness-engineering
- Princeton, SWE-agent: https://arxiv.org/abs/2405.15793
- Berkeley, Why Do Multi-Agent LLM Systems Fail?: https://arxiv.org/abs/2503.13657
- Stanford et al., Meta-Harness: https://arxiv.org/abs/2603.28052
- Stop Comparing LLM Agents Without Disclosing the Harness: https://arxiv.org/abs/2605.23950
- The Scaffold Effect in Coding Agents (ICML 2026): https://icml.cc/virtual/2026/82739
- Secondary: https://dev.to/michaeltuszynski/the-model-doesnt-matter-the-harness-does-599 ; https://dev.to/gabrielanhaia/the-openai-agents-sdk-in-production-what-it-gives-you-and-what-it-hides-16a9
