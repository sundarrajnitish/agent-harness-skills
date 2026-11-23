---
name: code-autoresearch-loop
description: >-
  Use when running autonomous optimization experiments (ML, latency, evals, bundle size) — sets up immutable judge, mutable target, program.md, results.tsv, and Git ratchet.
---

# Karpathy Autoresearch Loop `[OPTIMIZATION]`

*Implements Andrej Karpathy's `autoresearch` architecture: turn iterative optimization into a disciplined, autonomous Git-ratcheted loop governed by an immutable metric and a plain-text strategy (`program.md`).*

See [program-template.md](./references/program-template.md) for a ready-to-adapt `program.md` and `results.tsv` schema.

## Required Inputs
If any of these are missing, ask before starting a loop:
1. **Mutable target**: exact file(s) the agent is allowed to modify (e.g., `train.py`, `src/query.ts`, `prompt.txt`).
2. **Immutable judge**: exact read-only benchmark/eval command and single scalar metric (and direction: lower-is-better or higher-is-better).
3. **Budget**: per-run time cap AND total iteration/time cap (or confirm an explicit bounded run count).

## Workflow

### Phase 1: Establish the Contract of Three
1. **Lock the Immutable Judge** (equivalent to `prepare.py`):
   - Verify the benchmark/eval command produces a deterministic, machine-parseable scalar metric (e.g., `val_bpb`, `p95_ms`, `eval_pass_rate`, `bundle_kb`).
   - Treat the judge script, dataset, and scoring code as **strictly read-only** to prevent reward hacking.
2. **Scope the Mutable Playground** (equivalent to `train.py`):
   - Restrict edits strictly to the designated target file(s).
3. **Author `program.md` (The Strategy)**:
   - Write the goal, metric direction, immutable vs. mutable files, run command, time budget, simplicity tie-breaker, and promising hypothesis directions (use [program-template.md](./references/program-template.md)).

### Phase 2: Clean Git Branch & Baseline
1. Confirm clean git state and create a dedicated experiment branch (e.g., `autoresearch/<topic>`).
2. Run the unmodified baseline once under the exact time budget.
3. Initialize `results.tsv` (keep it untracked or outside reset scope so reverted commits never erase experiment history!) with columns:
   `run_id	commit	metric	delta	status	hypothesis`
4. Record `run_id=0` with `status=baseline`.

### Phase 3: The Monotonic Git Ratchet Loop
Repeat up to the iteration/time budget:
1. **Review `results.tsv`** and recent diffs so you never repeat failed hypotheses.
2. **Form one clear, isolated hypothesis** (change one meaningful lever at a time).
3. **Edit only the mutable target file(s)** and make a small, focused commit (`git commit -am "exp(<id>): <short hypothesis>"`).
4. **Run the immutable judge** with the strict timeout/time budget and capture the exact metric.
5. **Apply the Keep / Discard Ratchet**:
   - **KEEP**: metric strictly improves (or matches baseline while meaningfully simplifying code) → keep the commit as the new best baseline.
   - **DISCARD**: metric regresses, ties with added complexity, or crashes → revert immediately (`git reset --hard HEAD~1`).
6. **Log every attempt** (keep, discard, or crash) as a single row in `results.tsv` with the metric, delta vs. best, status, and concise hypothesis.

### Phase 4: Summary Report
When the budget finishes, report:
- Starting baseline vs. final best metric (and net gain).
- Total runs (`kept / discarded / crashed`).
- The winning commits and what hypotheses moved the needle most (plus dead ends worth avoiding).

## Rules / Never
- **Never** modify the immutable judge, test fixtures, or metric calculation to inflate scores.
- **Never** run an unbounded `LOOP FOREVER` without explicit user approval and an explicit budget or kill switch.
- **Never** stack 5 unrelated changes in a single experiment—keep hypotheses attributable.
- **Never** keep a neutral/tiny gain that adds significant code complexity; prefer simplicity on ties.
- **Never** lose experiment logs during `git reset`—keep `results.tsv` preserved outside discarded commits.
