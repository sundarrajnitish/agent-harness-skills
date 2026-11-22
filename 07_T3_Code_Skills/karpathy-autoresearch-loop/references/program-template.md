# Autoresearch Strategy (`program.md`) Template

```markdown
# Experiment Program: [GOAL]

## Objective
Optimize `[METRIC_NAME]` ([lower / higher] is better).

## Contract of Three
- **Immutable Judge (NEVER EDIT):** `[path/to/eval_or_benchmark]`
- **Mutable Target (ONLY EDIT THIS):** `[path/to/target_file]`
- **Experiment Log (APPEND-ONLY, DO NOT RESET):** `results.tsv`

## Command & Budget
- Run command: `[EXACT BENCHMARK COMMAND]`
- Per-run timeout: `[e.g., 5 minutes / 60 seconds]`
- Max iterations: `[e.g., 15 runs]`

## Ratchet Rules
1. Change one clear hypothesis per run.
2. Commit the edit, run the judge, extract `[METRIC_NAME]`.
3. If `[METRIC_NAME]` improves (or ties with strictly simpler code): KEEP commit.
4. If `[METRIC_NAME]` worsens, ties with extra complexity, or crashes: `git reset --hard HEAD~1` (DISCARD).
5. Always append one line to `results.tsv` before starting the next run.

## Hypothesis Queue (Ideas to Explore)
- [Idea 1]
- [Idea 2]
- [Idea 3]
```

## Starter `results.tsv` Header
```tsv
run_id	commit	metric	delta	status	hypothesis
0	<base_sha>	0.0000	0.0000	baseline	Initial unmodified baseline
```
