---
name: agent-system-principles
description: >-
  Applies the 7-level Harness, Loop, and Graph engineering principles to diagnose
  failing agent setups, design check-first verification and converging feedback
  loops, structure parallel isolated workflows, gate actions by cost-of-undo, and
  turn recurring failures into structural layer fixes. Use whenever the user asks
  to diagnose why an agent loop is failing or looping, design verification checks
  and exit conditions, decide human approval gates by undo cost, or apply Harness/
  Loop/Graph principles to a project.
---

# Agent System Principles `[FOUNDATIONS]`

Apply the **Harness → Loop → Graph** ladder so the system—not the human—handles environment, evidence, and orchestration, while keeping human attention strictly on irreversible decisions.

## Core Separation
- **Harness** = what the agent *can* do (minimal tools, external disk memory, real permission walls).
- **Loop** = what is actually *true* (checks that can fail, converging feedback, hard exits).
- **Graph** = what happens *next* (real dependencies, isolated contexts, freeze-on-pass, undo-cost gates).

## Required Inputs
Inspect the workspace or workflow first. Ask only if missing:
1. The current agent workflow or recurring failure symptom.
2. What target outcome defines **GREEN** (and what actions are irreversible).

## Workflow

1. **Diagnose the Missing Level (Top-Down)**
   Match the **first** symptom from the top—never skip levels, and stop at Level 4 if that suffices:
   - Copy-pasting between chat and terminal → **L1 (Hands)**: grant minimal tools.
   - Forgets prior attempts / edits forbidden files → **L2 (Memory & Walls)**: add `PROGRESS.md` + git checkpoints + real permission/sandbox walls (never rely on prompt "wishes").
   - Claims *"should pass"* without proof → **L3 (Check)**: add a deterministic check that can fail.
   - Retries repeat the same error → **L4 (Feedback & Exits)**: add structured diff feedback + stop rules.
   - Slow, serial, or groupthink across subtasks → **L5 (Graph Shape)**: split independent nodes into isolated contexts; move deterministic steps to code.
   - One failure reruns good work, or everything needs human review → **L6 (Freeze & Undo Gates)**: freeze passed outputs read-only; gate by cost of undo.
   - Same failure recurs across runs → **L7 (Learning)**: encode a structural constraint on the owning layer.

2. **Design From the Middle (Write the L3 Check First)**
   Before writing code or prompts, define **GREEN** using the strongest available evidence:
   `Deterministic (tests/build/schema) > Observable trace > Independent fresh-context review > Self-report (reject as sole proof)`.
   For bugs, require a reproducing check that **fails before** and **passes after**.

3. **Enforce L4 Converging Feedback & Hard Exits**
   On every retry, pass structured feedback instead of raw "red":
   - `EXPECTED` vs. `SAW` (exact error + location)
   - `FENCE` (allowed edit scope)
   - `DEAD ENDS` (tried approaches to avoid repeating)
   Require three exits: **Green** (done), **same `SAW` twice** (stop & escalate), **budget spent** (stop & escalate).

4. **Shape Graphs & Gate by Cost of Undo (L5–L6)**
   - **Early-start test**: If `B` doesn't break when started before `A`, remove the serial dependency and run in parallel in **separate contexts**.
   - **Same-answer test**: Deterministic transforms (merge, sort, dedupe, count) belong in code, not LLM calls.
   - **Freeze passed nodes**: Mark verified outputs read-only so retries never re-roll good work.
   - **Undo-cost gates**:
     - *One-click undo* (revertable docs/tests/single function) → ship on green.
     - *Cleanup undo* (shared helpers, schemas, auth) → green + trace + independent review.
     - *No undo* (migrations, deletes, external sends, money) → **human signs** (never bypass with a confidence score).

5. **Route Postmortem Lessons to the Owning Layer (L7)**
   Turn failures into constraints, not pasted transcripts:
   - Missing visibility → **Harness** (add narrow read-only tool)
   - Repeated dead end → **Harness memory** (add to `never` list / `CLAUDE.md`)
   - Unverified completion → **Loop** (add mandatory check)
   - Overlapping/colliding work → **Graph** (add explicit split rule)

## Rules / Never
- **Never** treat a prompt reminder (*"please don't edit X"*) as a security wall—enforce permissions/sandboxes.
- **Never** accept model self-report (*"looks good"*, *"should pass"*) as a passing loop check.
- **Never** let a retry loop run without a repeated-error exit and a hard budget cap.
- **Never** use a model confidence score to bypass human approval on **no-undo** actions.
