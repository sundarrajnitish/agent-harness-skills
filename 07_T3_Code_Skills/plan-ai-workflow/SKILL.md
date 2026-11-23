---
name: plan-ai-workflow
description: >-
  Use before coding an AI feature or automation — applies the Complexity Ladder (single call vs. chain vs. router vs. agent), per-step model routing, and blast-radius gates.
---

# Architect AI Workflow `[ARCHITECTURE]`

Prevent over-engineering by choosing the **lowest rung on the complexity ladder** that reliably solves the task, with explicit model routing, safety gates, and blast-radius bounds.

> Core rule: **"Can a single well-crafted call do this? Then do that and go home."** Sophistication you do not need is debt.

## Required Inputs
If any of these are missing, ask before designing:
1. The job to automate, trigger, and expected output.
2. Volume / frequency and latency requirements (real-time vs. async/batch).
3. Failure cost: what happens if the output is wrong, and is it reversible?

## Workflow

1. **Score Automation Fit (3 Questions)**
   - **Volume**: How often does it run and how much human time does it save?
   - **Definability**: Can we write 10–20 real input → expected-output pairs? (If not, stop and define "correct" first.)
   - **Failure cost**: Reversible draft/log vs. irreversible money/message/delete?

2. **Climb the Complexity Ladder Only When Needed**
   Start at the bottom and justify every step upward:
   - **Single-shot**: `input → LLM → output` (default starting point).
   - **Fixed Chain**: `A → B → C` (cut where work changes character: gather → analyze → decide → write; validate at each seam).
   - **Router**: `input → fast classifier → specialized path`.
   - **Orchestrator–Workers**: lead splits work across parallel subagents → synthesis.
   - **Evaluator–Optimizer**: `draft → critic (named criteria) → revise` until bar is met.
   - **True Agent Loop**: `model decides → tool runs → observe → repeat` — **only** when steps genuinely cannot be known in advance.
   - **Human-in-the-Loop (HITL)**: compose with any pattern above before irreversible actions.

3. **Assign Model per Step (Tiered Routing)**
   - **Fast/Cheap tier (e.g., Haiku)**: routing, classification, tagging, extraction, mechanical transforms.
   - **Default workhorse (e.g., Sonnet)**: drafting, coding, analysis, synthesis.
   - **Frontier/Reasoning tier (e.g., Opus + thinking)**: rare, high-stakes, thorny judgment—promoted **only** when evals prove the default tier fails.
   - Store model IDs in one central config map.

4. **Apply Safety Tiers & Blast-Radius Test**
   Ask: *"If this goes completely haywire, what is the worst it can do?"* Engineer until the answer is survivable.
   | Blast Radius | Required Posture |
   |---|---|
   | Read & summarize | Automate freely; make verification cheap. |
   | Write to sandbox, draft, or log | Automate; review diff/output. |
   | Write to real data | Propose → human approves; idempotency keys; daily caps. |
   | Money, external messages, deletes | Human always clicks the final button. |

5. **Spec Minimal Tools (If Agentic)**
   - Start with the smallest non-destructive tool set.
   - Pair every write tool with a read tool so the model can verify its own action.
   - Require hard `max_iterations` and budget caps.

6. **Plan Narrow Rollout**
   - Build a 10–20 row eval set first → deploy to one narrow slice with every consequential action gated → watch traces for a week → loosen only the highest-confidence, lowest-risk category.

## Rules / Never
- **Never** recommend an open-ended agent loop when a single call, chain, or router + HITL works.
- **Never** default to the most expensive model for routing or classification.
- **Never** allow unguarded writes to money, external communications, or destructive deletes.
- **Never** skip the "riskiest step" and blast-radius analysis.
- **Never** pick Orchestrator–Workers for sequential reasoning; multi-agent helps breadth-first, parallelizable work and can hurt sequential work. Budget ~15x chat tokens when you do use it.
- **Prefer the advisor pattern** over a frontier model end to end: a cheap executor that consults a strong advisor when stuck often gets most of the quality at a fraction of the cost.
- **Treat harness + model as one system**; harness changes alone can move scores as much as swapping models. See [HARNESS_PRINCIPLES.md](../../HARNESS_PRINCIPLES.md).

## Output Format
Produce a concise **Architecture Spec** with:
1. **Selected Pattern & Why** (explicitly why simpler rungs were rejected).
2. **Step-by-Step Flow** (ASCII diagram + per-step model tier + validation at each seam).
3. **Tool & Data Boundaries** (minimal tools, read/write pairs, untrusted inputs).
4. **Riskiest Step & Containment** (blast radius, HITL gate, idempotency, caps).
5. **Pre-Flight Checklist** (eval set, spend cap, alerts, rollout slice).
