---
name: design-mcp-integration
description: >-
  Plans and configures least-privilege MCP server connections or specs a custom MCP
  server with a confused-deputy threat model, read-only defaults, and tool-restraint
  rules. Use whenever the user asks to connect an MCP server, add Postgres/GitHub/
  Slack/filesystem MCP access, audit MCP permissions, or design a custom MCP server
  and its tool schemas.
---

# Design MCP Integration `[SETUP]`

Connect agents to external systems with minimal blast radius, tight tool surfaces, and explicit protection against prompt injection and confused-deputy attacks.

## Required Inputs
If missing, ask before generating config or code:
1. Which external systems the agent needs to reach (limit to recurring work).
2. Whether each system needs **read-only** (`resources`/read tools) or **write** (`tools`/actions) access.
3. Where the config lives (project `.mcp.json`, `mcp_config.json`, or custom server codebase).

## Workflow

1. **Apply the Tool Restraint Filter**
   - **Six well-chosen tools beat forty.** Every extra server adds tool-selection noise.
   - Map only the systems tied to recurring tasks; leave everything else disconnected.

2. **Enforce Least Privilege per System**
   | System | Least-Privilege Default |
   |---|---|
   | **Filesystem** | One explicit working folder; never `~`; read-only if only reading. |
   | **GitHub** | Narrowest PAT scopes via env var; read-only unless PR/issue writes are required. |
   | **Database (Postgres/SQL)** | Dedicated **read-only DB user**, ideally against a read replica. |
   | **Slack / Email / Workspace** | Specific channels/scopes only; read-only first; human confirm before posting/sending. |
   | **Web / Search** | Treat all results as untrusted data; isolate from outbound action servers. |

3. **Run the Confused-Deputy Threat Model**
   Whenever an agent can **both read untrusted content** (web, email, tickets, external repos) **and take external actions** (send email, post Slack, write DB, open PRs):
   - Require a **human-approval gate** on every outbound or destructive action.
   - Narrow send/write targets (allowlisted domains, channels, or schemas).
   - Wrap untrusted tool responses in explicit data delimiters so injected text cannot trigger tool calls.

4. **Handle Secrets Safely**
   - Reference credentials exclusively via environment variables (e.g., `${READONLY_REPLICA_DATABASE_URL}`, `${GITHUB_TOKEN_READONLY}`).
   - Verify `.env` and local secret files are gitignored.

5. **When Specifying a Custom MCP Server**
   For each tool, define:
   - **Name & single purpose** (read-only tools first; run over `stdio` locally before exposing HTTP).
   - **When to use** AND **"Do NOT use this when…"** in the tool description.
   - **Strict input schema**: enums, required fields, formats, bounds.
   - **Verification pair**: every write tool must have a corresponding read tool so the agent can verify its own change.
   - **Informative errors**: return actionable error messages so the agent can recover cleanly.

## Rules / Never
- **Never** commit tokens, API keys, or connection strings into MCP JSON configs.
- **Never** connect a production write-enabled database user to an exploratory MCP server.
- **Never** mount the user's home directory (`~`) in a filesystem MCP server.
- **Never** combine untrusted web/email ingestion with unguarded outbound write tools.

## Output Format
Deliver:
1. **Access Matrix**: System · Access Level (Read/Write) · Least-Privilege Scope · Env Var Name.
2. **Threat Model**: Top 2–3 confused-deputy / injection risks and the exact mitigation for each.
3. **Config or Tool Spec**: Ready-to-use JSON snippet (referencing env vars) or custom tool definitions.
