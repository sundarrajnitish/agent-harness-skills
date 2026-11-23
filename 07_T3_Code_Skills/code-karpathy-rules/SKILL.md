---
name: code-karpathy-rules
description: >-
  Use when writing, fixing, or refactoring code — enforces Karpathy's 4 rules: Think Before Coding, Simplicity First, Surgical Changes, and Goal-Driven test loops.
---

# Karpathy Coding Guidelines `[CODING]`

*Derived from Andrej Karpathy's X field notes on coding with LLMs ("A few random notes from claude coding…"). Bias toward clarity, restraint, and verifiable correctness over speed.*

## 1. Think Before Coding
**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before writing code:
- State your assumptions explicitly; if a requirement is uncertain or underspecified, **stop and ask**.
- If multiple interpretations exist, present them briefly—never pick one silently and sprint 400 lines down the wrong path.
- If a simpler approach exists, propose it and push back when warranted.
- Name what is confusing rather than papering over ambiguity.

## 2. Simplicity First
**Minimum code that solves the problem. Nothing speculative.**

- Write **no features** beyond what was explicitly asked.
- Write **no abstractions, helpers, or factories** for single-use code.
- Add **no speculative configurability, flags, or future-proofing** that was not requested.
- Avoid defensive error-handling for impossible internal scenarios (validate at system boundaries only).
- **Self-check**: If you wrote 200 lines and it could be 50, rewrite it. Ask: *"Would a senior engineer call this overcomplicated?"* If yes, simplify before replying.

## 3. Surgical Changes Only
**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Do **not** "improve", reformat, or rewrite adjacent code, comments, or imports that aren't broken.
- Do **not** refactor working code outside the task scope.
- Match the repository's existing style even if you prefer another style.
- Remove imports, variables, or helpers that **your** edit made unused; if you spot pre-existing dead code, mention it in your summary—do **not** delete it unasked.
- **Diff test**: Every single changed line in `git diff` must trace directly back to the user's request.

## 4. Goal-Driven Execution
**Define verifiable success criteria. Loop until verified.**

Convert vague/imperative requests into declarative, testable loops:
- *"Fix the bug"* → Write a failing test (or reproduction command) that triggers the root cause, fix the root cause (not a superficial null-check), and loop until the test passes.
- *"Add validation"* → Write tests covering invalid and edge inputs first, then make them pass.
- *"Refactor X"* → Run tests before and after; confirm zero behavioral regression.
- Read full stack traces and actual command output; never assume a fix works until the verification check passes green.

## Rules / Never
- **Never** make silent product or architectural assumptions when the prompt is ambiguous.
- **Never** mix unrelated cleanup/formatting into a bugfix or feature diff.
- **Never** paper over a root-cause bug with a swallowed exception or defensive hack.
- **Never** declare a task done without running the concrete verification criteria.
