---
name: verify-and-audit-output
description: >-
  Runs a rigorous verification, sourcing, and safety audit on AI-generated code,
  diffs, research summaries, or high-stakes decisions using Claim Ledgers, exact
  passage citations, number reconciliation, blast-radius checks, and devil's-advocate
  critique. Use whenever the user asks to fact-check or verify an output, audit a
  PR or AI-generated diff, stress-test a technical decision, or check for hallucinations
  and unsourced claims before shipping.
---

# Verify and Audit Output `[VERIFICATION]`

Enforce the rule: **"Fluent output is not verified output."** Make human verification fast enough to actually happen on a busy day.

## Required Inputs
Inspect the file, diff, or text provided. If no target artifact or source material is given, ask for it before auditing. Do not guess.

## Workflow

Select the applicable audit tracks based on the target (run all that apply):

### 1. Claim Ledger (Research, Docs, Summaries, Specs)
- Extract every concrete factual claim, API behavior, price, limit, or config syntax.
- Cite the exact source (file path + line range, quoted passage, or verified doc) next to each claim.
- Explicitly mark any claim you cannot verify from provided sources or tools as **`UNSOURCED`** — never paper over uncertainty with confident prose.

### 2. Number & Data Reconciliation (Reports, Migrations, Metrics)
- Recompute totals, percentages, counts, or deltas with a script/command—never eyeball math.
- Reconcile derived figures against an independent source of truth.
- **Flag, don't delete**: list duplicates, anomalies, or uncertain matches for human review instead of silently dropping them.

### 3. Code & Diff Reviewer Discipline (PRs, AI-Generated Changes)
Review the diff like a skeptical senior code reviewer, not a relieved author:
- Verify every modified behavior against actual test execution (not assumed passes).
- Check for silent error swallowing, missing edge cases, unvalidated external inputs, leaked secrets/PII, or accidental edits outside task scope.
- Check blast radius: any irreversible write, migration, deletion, or external send must have a guardrail or human gate.

### 4. Devil's Advocate & Disagreement Check (Architecture / High-Stakes Decisions)
- Argue as strongly as possible **against** the proposed approach (do not flatter).
- Identify the single worst failure mode ("what error would catch everything?").
- Rate confidence (`low` / `medium` / `high`) and state explicitly **where your confidence runs out**.

## Rules / Never
- **Never** mark a claim verified without checking the underlying file, command output, or quoted passage.
- **Never** silently delete or overwrite uncertain data during an audit—flag it.
- **Never** flatter a weak design; surface the strongest counter-argument plainly.
- **Never** present unverified prices, model IDs, API limits, or legal/medical/financial advice as authoritative—flag them for official verification.
- **Never** let the agent that produced an output be its only grader; agents over-praise their own work. Use a separate verifier, calibrated with few-shot examples where possible. See [HARNESS_PRINCIPLES.md](../../HARNESS_PRINCIPLES.md).

## Output Format
Deliver a scannable **Verification Report** designed for a 30-second human scan:
1. **Verdict**: `PASS` / `PASS WITH FLAGS` / `BLOCK` (one sentence).
2. **Claim Ledger / Findings Table**: `Item | Status (VERIFIED / UNSOURCED / MISMATCH) | Evidence (file:line or quote)`.
3. **Top Risk & Counter-Argument** (with confidence level + where confidence runs out).
4. **Required Fixes Before Shipping** (numbered, concrete actions).
