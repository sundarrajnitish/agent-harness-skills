---
name: plan-context-pack
description: >-
  Use when packing agent context (LLM=CPU, context=RAM), writing declarative success-criteria briefs, isolating noisy subagents, or fixing context rot and AI slop.
---

# Karpathy Context Engineering `[CONTEXT]`

*Implements Andrej Karpathy's Context Engineering & Agentic Engineering mental model: the LLM is the CPU, the context window is finite working RAM, and your job is packing the exact right signal into RAM while delegating via declarative success criteria.*

## Core Mental Model
- **Context = RAM**: Every irrelevant file, stale log, or outdated spec steals attention and accelerates **context rot**. Signal density beats token volume.
- **Declarative > Imperative**: *"Don't tell it step-by-step what to do; give it clear success criteria and watch it go."*
- **80/20 Leverage with Zero Slop**: Delegate large, verifiable code actions to agents, while keeping humans focused on specs, architecture, verification criteria, and skeptical diff review.

## Required Inputs
Inspect the workspace or conversation first. Ask only if missing:
1. What task or multi-turn workflow you are preparing context for (or debugging drift in).
2. What verification commands/tests exist to define "done."

## Workflow

### 1. Pack the Context Window Like RAM (Curate, Don't Dump)
Build a tight **Context Pack** containing only what the task actually needs:
- **Standing invariants** (architecture constraints, conventions, "never do" boundaries).
- **Exact target files & interfaces** (entry points, types, failing test output)—never paste whole directories.
- **Explicit non-goals** (what must stay untouched).
- **Quarantine noisy work**: send wide codebase searches, log reading, or doc lookups to a disposable read-only subagent that returns **only conclusions + exact `file:line` pointers**, keeping the main thread's RAM clean.

### 2. Rewrite Imperative Prompts into Declarative Briefs
Transform micromanaged instructions into a **Declarative Agent Brief**:
```markdown
## Goal
[Desired end state in 1–2 sentences]

## Context (Minimal Files)
- `path/to/file.ts` — [why it matters]

## Constraints & Non-Goals
- [Hard boundary / simplicity / surgical-scope rule]

## Verifiable Success Criteria (Definition of Done)
- [ ] `[exact test / typecheck / lint / benchmark command]` passes
- [ ] [Observable behavior or invariant check]
```

### 3. Prevent Context Rot in Long Sessions
Apply session hygiene checkpoints:
- **Topic switch** → start a fresh thread (`/clear` or new thread) so old assumptions don't poison new tasks.
- **Long thread getting forgetful or looping** → compact/summarize state into a short handoff brief (Goal, Verified Facts, Remaining Steps, Key File Paths) and continue cleanly.
- **Repeated mistake** → promote the fix into a crisp 1-line standing rule in `CLAUDE.md`/`AGENTS.md` (and prune stale rules—treat context as a garden, not an attic).

### 4. Guard Against Slop & Skill Atrophy
- Prefer small, reviewable commits with clear diffs over 2,000-line opaque rewrites.
- Require the agent to explain non-obvious architectural choices and tradeoffs so the human retains active mental ownership of the codebase.

## Rules / Never
- **Never** dump entire codebases, long raw logs, or superseded docs into working context when targeted slices or summaries suffice.
- **Never** give an agent an open-ended task without concrete, runnable verification criteria.
- **Never** keep pushing a degraded, looping thread—extract the verified state and reset context.
- **Never** confuse prompt wording tweaks with missing context; check *what the model can actually see* first.
