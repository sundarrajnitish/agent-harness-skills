# LLM Wiki Starter Templates

## 1. Starter `index.md`
```markdown
# Wiki Index

> Content catalog maintained automatically on every `ingest` and `lint`. Read this first before querying.

## Sources
- *(none yet)*

## Concepts
- *(none yet)*

## Entities
- *(none yet)*

## Syntheses
- *(none yet)*
```

## 2. Starter `log.md`
```markdown
# Wiki Log

> Append-only chronological audit trail. Use grep-friendly headings: `## [YYYY-MM-DD] <ingest|query|lint> | <Title>`.

## [YYYY-MM-DD] init | Initialized LLM Wiki structure
- Created `raw/`, `wiki/{sources,concepts,entities,syntheses}/`, `index.md`, and `log.md`.
```

## 3. Page Convention Snippet (for `CLAUDE.md` / `AGENTS.md`)
```markdown
## LLM Wiki Conventions
- `raw/` is strictly read-only ground truth. Never edit files in `raw/`.
- Every wiki page uses `[[wikilinks]]` for cross-references and cites its source(s) at the bottom under `## Sources`.
- Keep each page concise and factual; log contradictions explicitly with dates rather than overwriting silently.
- Every `ingest` must update `wiki/sources/`, affected `concepts/` and `entities/` pages, `index.md`, and append to `log.md`.
```
