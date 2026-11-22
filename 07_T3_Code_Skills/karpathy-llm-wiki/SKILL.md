---
name: karpathy-llm-wiki
description: >-
  Builds and maintains an Andrej Karpathy-style LLM Wiki—a persistent, interlinked
  local Markdown knowledge base (raw/, wiki/, index.md, log.md) compiled once by
  the agent instead of rediscovering facts via RAG. Use whenever the user asks to
  set up an LLM wiki, compile docs/papers/notes into a markdown knowledge base,
  ingest a source into a wiki, query a wiki, or lint a knowledge base for contradictions
  and orphan pages.
---

# Karpathy LLM Wiki `[KNOWLEDGE]`

*Implements Andrej Karpathy's `llm-wiki.md` pattern: stop rediscovering knowledge from scratch on every query—compile raw sources once into a persistent, interlinked Markdown wiki that compounds over time.*

See [wiki-schema-template.md](./references/wiki-schema-template.md) for starter `CLAUDE.md`/`AGENTS.md`, `index.md`, and `log.md` templates.

## Architecture (3 Layers + 2 Navigation Files)
```text
<wiki-root>/
├── CLAUDE.md (or AGENTS.md)  # Schema: conventions, page types, ingest/query/lint rules
├── index.md                  # Content catalog: every page linked with a 1-line summary
├── log.md                    # Chronological append-only audit trail (grep-friendly)
├── raw/                      # IMMUTABLE source docs (papers, PDFs, transcripts, exports)
└── wiki/                     # LLM-owned interlinked Markdown pages (Obsidian-ready)
    ├── sources/              # One summary page per ingested raw source
    ├── concepts/             # Cross-cutting concepts & methods
    ├── entities/             # People, orgs, tools, repos, products
    └── syntheses/            # Saved answers & deep-dive analyses from queries
```

## Required Inputs
If missing, ask before creating or modifying files:
1. Target wiki directory path (or confirm current repo).
2. Which operation to run: **`init`**, **`ingest`**, **`query`**, or **`lint`**.
3. For `ingest`: the exact source file(s) in `raw/` (ingest one source at a time for steering control).

## Operations

### 1. `init` — Scaffold a New LLM Wiki
- Create `raw/`, `wiki/{sources,concepts,entities,syntheses}/`, `index.md`, `log.md`, and the wiki schema rules (from [wiki-schema-template.md](./references/wiki-schema-template.md)).
- Record the initial setup line in `log.md`.

### 2. `ingest` — Compile a Raw Source into the Wiki
1. Read the target file in `raw/` completely (**never edit anything inside `raw/`**).
2. Create a concise summary page in `wiki/sources/<slug>.md` citing the exact raw filename and key claims.
3. Identify affected pages across `wiki/concepts/` and `wiki/entities/` (typically 3–15 pages) and update or create them with `[[wikilinks]]` and source citations.
4. **Surface contradictions**: if the new source conflicts with an existing claim, explicitly note both claims, their dates, and their sources—never silently overwrite history.
5. Update `index.md` with any new/changed one-line summaries.
6. Append one entry to `log.md` using the strict format:
   `## [YYYY-MM-DD] ingest | <Source Title>`

### 3. `query` — Answer from the Compiled Wiki (and Compound It)
1. Read `index.md` first to locate relevant pages (avoid brute-forcing `raw/` unless verifying a direct quote).
2. Read the targeted `wiki/` pages and synthesize a cited answer pointing to exact wiki pages and raw sources.
3. If the answer produces a valuable synthesis, comparison, or decision memo, offer to save it under `wiki/syntheses/<slug>.md`, link it in `index.md`, and append `## [YYYY-MM-DD] query | <Topic>` to `log.md`.

### 4. `lint` — Audit Wiki Health
Scan `index.md` and `wiki/` for decay and report actionable fixes:
- **Contradictions**: conflicting claims across pages without resolution notes.
- **Orphans**: pages with zero inbound `[[wikilinks]]` or missing from `index.md`.
- **Broken links / stale claims**: dead links, superseded versions, or unverified assertions.
- **Knowledge gaps**: frequently referenced concepts that lack a dedicated page or need a new `raw/` source.
- Append `## [YYYY-MM-DD] lint | <Summary>` to `log.md` after applying approved fixes.

## Rules / Never
- **Never** modify, rename, or delete files inside `raw/`—`raw/` is immutable ground truth.
- **Never** silently erase a prior claim when a newer source contradicts it; log the evolution and cite both.
- **Never** skip updating `index.md` and `log.md` after an `ingest` or saved synthesis.
- **Never** batch-ingest 20 raw documents blindly in one pass unless explicitly asked; ingest one at a time so quality stays high.
