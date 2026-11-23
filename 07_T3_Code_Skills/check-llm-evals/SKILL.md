---
name: check-llm-evals
description: >-
  Use when testing a prompt systematically or comparing/downgrading models — builds a 10-20 row real-world eval dataset, pre-run rubric, and benchmark runner.
---

# Build LLM Eval Suite `[EVALS]`

Replace prompt-tuning guesswork with a small, real-world test set so every prompt edit or model switch is backed by evidence.

See [eval_set_template.csv](./references/eval_set_template.csv) for the starter dataset schema.

## Required Inputs
If missing, ask before generating:
1. The prompt, workflow, or endpoint being evaluated.
2. What "good" looks like (must be written down **before** running any model).
3. Whether this is for **prompt regression** (10–20 rows) or a **model comparison** (3+ real weekly tasks across candidate models).

## Workflow

1. **Define the Scoring Rubric First (Before Running Anything)**
   Write 3–5 concrete pass/fail or 1–5 criteria covering:
   - **Correctness / Schema validity** (exact fields, allowed enums, zero hallucinated facts).
   - **Judgment / Quality** (follows constraints, tone, edge-case handling).
   - **Safety / Guardrails** (resists prompt injection, escalates uncertain inputs, obeys hard rules).
   - **Cost & Latency** (tokens/latency per row).

2. **Build a Real 10–20 Row Eval Set**
   Seed from real examples (never only happy-path toy inputs). Include:
   - **~50% typical cases**: representative everyday inputs.
   - **~25% edge cases**: missing fields, ambiguous intent, long/messy inputs.
   - **~25% adversarial / failure cases**: prompt injection attempts, out-of-scope requests, past real failures.
   - Save as `eval_set.csv` or `eval_set.jsonl` with columns: `id, input, expected_output_or_category, must_not_do, notes`.

3. **Write a Lightweight Eval Runner**
   - Load the dataset, call the target prompt/function with the model ID from config, run deterministic assertions first (JSON parse, enum check, forbidden phrases), then log results for human or LLM-as-judge grading.
   - Output a concise summary table: `Pass Rate | Schema Failures | Hard-Rule Violations | Avg Latency | Est. Cost`.

4. **Run Model-Downgrade / Comparison Discipline**
   - **Default to the mid-tier workhorse** (e.g., Sonnet).
   - Test **demoting** mechanical/routing steps to the fast tier (e.g., Haiku) — adopt it if eval scores hold.
   - Test **promoting** to the frontier/reasoning tier (e.g., Opus) **only** on rows where the default tier demonstrably fails.
   - When comparing across providers, allow minor prompt re-tuning per model (prompts don't port identically).

5. **Iterate Cleanly**
   - Change **one variable at a time** (prompt edit OR model change, not both).
   - Read every failing trace before changing the model—most failures are missing instructions or unclear tool descriptions.

## Rules / Never
- **Never** grade outputs without defining "good" beforehand (prevents hindsight bias).
- **Never** rely solely on vendor benchmarks or toy 2-row happy-path tests.
- **Never** treat a 1-row improvement as a win without re-running the full eval set for regressions.
- **Never** include real unredacted PII or secrets in committed eval CSV/JSONL files.
