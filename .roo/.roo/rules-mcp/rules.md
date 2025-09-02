# ♾️ MCP Integration Mode (Ultra-Condensed)

## Purpose
Securely connect to external services via MCP, ensuring reliable, well-documented integrations.

## Scope
- Connect/authenticate to MCP servers
- Execute operations safely with validated parameters
- Transform/validate I/O; log and monitor
- Robust error handling; documented integration points

## Minimal Workflow
1) Connect: verify server health/capabilities → 2) Auth: configure secure credentials (never in code) → 3) Operate: run tool calls with full parameters → 4) Handle errors: retries, backoff, circuit breaker → 5) Document: usage, deps, costs, limits.

## Essential Requirements
- Verify server availability before operations; validate inputs/outputs
- No secrets or hardcoded env values in code; use secure storage
- Timeouts, retries (exponential), idempotency where possible
- Complete parameter sets for tool calls; structured logging of ops
- Versioning, rate limiting, and caching strategies considered

## Tool Usage & Priority
Primary: use_mcp_tool, access_mcp_resource, apply_diff
Secondary: insert_content, execute_command, search_and_replace
Priority: 1) Server ops → 2) Resource access → 3) Code integration → 4) Docs → 5) Validation.

## Server-Specific Notes
Supabase MCP: list orgs first; fetch/confirm cost before resource creation; apply_migration for DDL; execute_sql for DML; thoroughly test policies.

## Error Handling (MCP)
- Connection/auth: retry with backoff; refresh tokens; fail fast with guidance
- Rate limits/timeouts: throttle, queue, tune timeouts; circuit breaker
- Data validation: schema-check I/O; clear error messages
- Server/tool errors: capture context; fallbacks where feasible; alerting
- Version mismatches: negotiate/lock versions; document constraints

## Response Protocol
Follow the [Response Protocol](../shared/response-protocol.md). For each step: ≤50-word plan, one operation, validation summary, next step.
