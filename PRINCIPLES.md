# Basic Principles: Harness, Loops & Graphs

Every reliable agent setup separates three jobs that humans accidentally absorb when they just chat with a model:

| Layer | Question It Answers | Governs |
|---|---|---|
| **Harness** | What *can* the agent do? | Environment, tools, external memory, hard boundaries |
| **Loop** | What is actually *true*? | Verifiable checks, converging feedback, exit conditions |
| **Graph** | What happens *next*? | Task shape, parallelism, isolation, freeze & approval gates |

These are not a menu of independent tools—they are a **ladder**. Each level exists to fix a predictable failure in the level below it. **Do not skip levels**, and stop climbing once your current level solves the job reliably (most engineering tasks finish at Level 4).

---

## The 7-Level Maturity Ladder

| Level | Layer | What It Adds | Failure It Fixes |
|---|---|---|---|
| **0** | Chat | Prompting only; human runs code, checks results, decides next step | Starting point for one-off questions |
| **1** | Harness · Hands | Minimal tool access (files, shell, test runner, git) | Eliminates manual copy-paste |
| **2** | Harness · Memory & Walls | External state files (`PROGRESS.md`, git checkpoints) + real permission/sandbox walls | Stops context-compaction amnesia and unsafe writes |
| **3** | Loop · Verifiable Check | An objective check that can actually fail (watch it fail once first) | Eliminates unverified *"should pass now"* self-reports |
| **4** | Loop · Converging Feedback | Structured diff feedback (`EXPECTED / SAW / FENCE / DEAD ENDS`) + hard exit rules | Stops blind retry loops that burn budget on the same error |
| **5** | Graph · Shape & Isolation | Decomposed nodes, real dependency edges, isolated worker contexts, deterministic glue code | Fixes slow serial runs and shared-context groupthink |
| **6** | Graph · Freeze & Undo Gates | Freeze passed node outputs (read-only) + gate actions by cost of undo | Prevents reruns from breaking good work; focuses human attention |
| **7** | Cross-Layer Learning | Promote each failure into a structural constraint on the layer that owns it | Ensures the same class of mistake never costs you twice |

---

## Core Laws to Build By

### 1. Harness = Everything on the Diagram Except the Model
- **Smallest viable toolset**: Ten narrow, well-documented tools beat forty overlapping ones. Every extra tool is another choice the model can get wrong.
- **Context is RAM; the harness is disk**: Models forget across compactions; files do not. Keep durable state (`PROGRESS.md` with goal, tried approaches, known facts, next step, never-touch list), git checkpoints, and pass artifacts by file path rather than pasting huge logs.
- **Walls, not wishes**: *"Please don't touch migrations"* is a wish. Least-privilege permissions, isolated worktrees/sandboxes, command allow-lists, and hard token/time budgets are walls that hold even when the model is wrong.

### 2. Design From the Middle (Write the Level 3 Check First)
Before editing code or wiring a workflow, define what **GREEN** means on paper:
- **Evidence hierarchy** (strongest → weakest):
  1. **Deterministic** — tests exit `0`, build compiles, schema validates.
  2. **Observable** — execution trace proving the check actually ran.
  3. **Independent** — a reviewer in a fresh context with a separate prompt.
  4. **Self-report** *(weakest)* — *"looks good"*, *"all tests should pass"*.
- A check is only as strong as the weakest proof it accepts.
- For bug fixes, require a reproducing test that **fails before the fix** and **passes after**. If you cannot write the check, you do not understand the task yet.

### 3. Feedback Must Converge, and Every Loop Needs Exits
A red test is a verdict, not feedback. Feed the next iteration:
- **`EXPECTED`** vs. **`SAW`** (exact failure + file/line)
- **`FENCE`** (narrow edit scope)
- **`DEAD ENDS`** (already-tried approaches so attempt 3 never repeats attempt 1)

Every loop needs three hard exits:
1. **Green** → done.
2. **Same `SAW` repeats twice** → stop and escalate (more retries won't fix missing visibility or a misframed question).
3. **Budget spent** → stop and escalate.

### 4. Shape Graphs Around Real Dependencies, Not Habits
- **Early-start test**: For any arrow `A → B`, ask *"What breaks if B starts before A finishes?"* If nothing breaks, the arrow is a habit—parallelize it.
- **Cut along failure boundaries**: Split tasks that can fail independently; keep tightly coupled steps together.
- **One room per worker**: Multiple roles sharing one context degrade into one opinion. Isolate parallel workers in separate contexts.
- **Same-answer test**: If the same input must always produce the same output (sorting, merging, deduping, counting), write deterministic code—save LLMs for judgment.
- **Gate at node exits**: Catch errors as work leaves each node, not after everything is mixed together.

### 5. Freeze Good Work & Gate on the Cost of Undo
- **Freeze on pass**: Once a node passes its gate, mark its output read-only. On downstream failure, rerun *only* the failed node—never re-roll already-verified work.
- **Gate by undo cost, not model confidence**:

| Undo Tier | Examples | Required Gate |
|---|---|---|
| **One-click undo** | Docs, tests, isolated function (`git revert`) | Ships on green deterministic check |
| **Cleanup undo** | Shared helpers, schemas, auth/core flows | Green check + execution trace + independent review |
| **No undo** | Destructive migrations, deletes, external messages, money | **Human approves** — no confidence score bypasses this |

Let the model classify what a change touches; let **deterministic code/policy** decide what approvals that label unlocks. Spend human attention where undo does not exist.

### 6. Route Every Lesson to the Layer That Owns It (Level 7)
A lesson is a **structural constraint**, not a transcript pasted into future prompts.

| Failure | Structural Fix | Owning Layer |
|---|---|---|
| Agent lacked visibility into logs/state | Add a narrow read-only tool | **Harness (tools)** |
| Agent retried a known dead end | Add rule to standing `never` list / `CLAUDE.md` | **Harness (memory)** |
| Agent claimed "fixed" without proof | Add mandatory failing-first check | **Loop** |
| Parallel workers duplicated or collided | Add explicit split rule / ownership boundary | **Graph** |

---

## Quick Diagnostic: Which Level Are You Missing?

Find the **first** symptom from the top—that is the next level to build:

| Symptom | Missing Level |
|---|---|
| You copy-paste between chat and terminal | **L1** — Harness: hands |
| Agent forgets what it tried or touches forbidden files | **L2** — Harness: memory & walls |
| "Done" means nothing until you manually check it | **L3** — Loop: check that can fail |
| Retries burn budget hitting the same error repeatedly | **L4** — Loop: converging feedback & exits |
| Each step works, but the workflow is slow, serial, or biased | **L5** — Graph: shape & isolation |
| One failure forces full rework, or every tiny change needs you | **L6** — Graph: freeze-on-pass & undo gates |
| The same class of mistake recurs every week | **L7** — Layer-targeted learning |
