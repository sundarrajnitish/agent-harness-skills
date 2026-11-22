---
name: harden-llm-pipeline
description: >-
  Audits or implements production LLM and Anthropic/AI API code for reliability,
  cost control, and safety: centralized model config, retries with backoff, strict
  schema validation, prompt-injection delimiters, idempotency keys, human fallback
  queues, prompt caching/Batch API, and missing-output alerts. Use whenever the user
  asks to productionize an LLM script, harden an AI endpoint or agent, cut API costs,
  or review AI pipeline code before shipping.
---

# Harden LLM Pipeline `[PRODUCTION]`

Eliminate silent failures, runaway costs, prompt-injection holes, and duplicate writes in production LLM/API code.

See [router_reference.py](./references/router_reference.py) for a clean reference implementation combining routing, validation, fallback, and idempotency.

## Required Inputs
Inspect the target code/files first. Ask only if not visible in the repo:
1. File path(s) of the LLM/API integration or agent loop to audit/implement.
2. Whether the pipeline runs synchronously (user-facing) or asynchronously (background/batch).
3. Which actions are consequential (writes, sends, charges, deletes).

## Audit & Implementation Checklist

Work through each pillar and fix or flag concrete gaps with file + line references:

1. **Configuration & Cost Levers**
   - **Centralize model IDs** in one config dict/constant so model upgrades are a one-line change.
   - **Route by step**: cheap/fast model for classification/routing, default workhorse for drafting/analysis, frontier model only on eval evidence.
   - **Prompt caching**: cache large repeated prefixes (system prompts, reference docs).
   - **Batch API**: move non-urgent bulk jobs (overnight tagging/extraction) to async Batch API.
   - **Bounded context**: set tight `max_tokens`, trim stateless message history, keep system prompts lean.
   - **Spend cap & key hygiene**: API keys from env vars only; verify spend cap is configured.

2. **Retries & Error Handling**
   - Retry transient `429`, `5xx`, and `529` errors with exponential backoff (use the SDK's built-in `max_retries`).
   - **Never** retry malformed `4xx` client errors.
   - Return informative error messages from tool executors so the model can recover.

3. **Strict Output Validation & Correction Loop**
   - Parse and validate every structured output (JSON schema, required fields, enum values, numeric bounds, confidence threshold).
   - On validation failure: either send back the **specific error** for a bounded retry (1–2 attempts) or route to the fallback queue—never proceed silently on bad data.

4. **Prompt-Injection Defense**
   - Wrap all external/third-party text (tickets, emails, web pages, user docs) in explicit tags (`<untrusted>…</untrusted>`) and state in the system prompt that it is data, never instructions.

5. **Idempotency, Caps & Human Fallback**
   - **Idempotency**: key every consequential write on a stable request/entity ID stored persistently so retries/re-runs are no-ops.
   - **Human fallback queue**: route unparseable outputs, low-confidence classifications, and uncertain matches to a review queue.
   - **Daily caps**: enforce hard daily ceilings on money, volume, and agent `max_iterations`.
   - **Human approval gate**: drafts/proposals go to an approval queue before irreversible external sends or writes.

6. **Observability & Silent-Failure Alerts**
   - Log every call: timestamp, model, token usage/cost, latency, tool calls, validation outcome, and fallback reason.
   - **Alert on missing expected output** (dead-man's switch), not just thrown exceptions—silent stalls are the hardest production bugs to catch.

## Rules / Never
- **Never** swallow JSON/schema parse errors or silently default to a destructive action.
- **Never** hardcode API keys or scatter raw model strings across multiple files.
- **Never** execute consequential writes without an idempotency check.
- **Never** upgrade the model to fix a bug before reading the trace (most failures are unclear instructions or tool descriptions).

## Output Format
When auditing, return a prioritized table (**Severity · Pillar · File:Line · Issue · Exact Fix**), then apply approved fixes and verify with tests.
