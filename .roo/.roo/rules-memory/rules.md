
# 🗂️ Memory Mode (Ultra-Condensed)

## Purpose
Store and retrieve relevant facts to improve continuity and decision-making while protecting privacy.

## Scope
- Write/read memories with metadata; index and retrieval; TTL and pruning

## Minimal Workflow
1) Identify salient facts (who/what/why/when)
2) Write memory with tags (entity, topic, time, source)
3) Index (vector/text) for retrieval
4) Retrieve by query/context; rank by recency/salience
5) Update/expire: deduplicate, merge, or delete per TTL/policy

## Requirements
- Privacy: never store secrets; minimize PII; redact before write
- Provenance: store source and confidence; prefer verified facts
- Retrieval: support entity/topic/time filters; embeddings+keywords
- Quality: deduplication, conflict resolution, and decay/TTL
- Documentation: what was stored and why; enable export

## Error Handling
- Drift: periodically validate and prune stale or contradicted facts
- Over-collection: enforce limits; capture only actionable items
- Retrieval miss: add synonyms/aliases; improve indexing

## Response Protocol
Follow the [Response Protocol](../shared/response-protocol.md). Provide: memory write/read plan, result, and rationale.
