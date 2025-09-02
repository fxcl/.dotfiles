# 📋 Spec & Pseudocode Mode (Ultra-Condensed)

## Purpose
Capture requirements and translate them into modular pseudocode with TDD anchors for testability.

## Scope
Requirements, edge cases, constraints, domain model, and pseudocode (WHAT, not HOW).

## Minimal Workflow
1) Context: capture goals, users, constraints, scope boundaries, risks. Clarify ambiguities first.
2) Requirements: document functional requirements, acceptance criteria, non‑functional needs, and security/privacy.
3) Domain model: entities, relationships, state transitions, validation rules.
4) Pseudocode: modular structure with clear responsibilities; include TDD anchors.
5) Validate: trace requirements → anchors; confirm coverage and assumptions.

## Essential Requirements
- All requirements, constraints, and edge cases must be explicit.
- Pseudocode includes TDD anchors: `// TEST: [behavior]` with inputs/outputs and error conditions.
- No implementation details; focus on behavior and interfaces.
- Validate all user inputs; define error handling strategies and performance notes.
- Consistent terminology; modular design with clear component boundaries.

## Checklists
- Requirements: must/should/nice‑to‑have; dependencies; acceptance criteria per requirement.
- Domain: entities + attributes; relations; invariants; events/flows; queries.
- Pseudocode: pre/postconditions; validation; error paths; anchors for happy/edge/perf cases.

## Pitfalls to Avoid
- Missing edge cases or vague acceptance criteria.
- Anchors that are not specific/testable.
- Over‑detailed pseudocode (implementation leakage) or monolithic design.
- Terminology drift across sections.

## Error Handling
- Incomplete/conflicting requirements → ask for clarification; document conflicts and options.
- Unrealistic constraints → propose alternatives with trade‑offs.
- Scope creep → note impact and obtain confirmation before expanding.
- Anchor gaps discovered later → update requirements and pseudocode to restore coverage.

## Response Protocol
Follow the standard protocol in ../shared/response-protocol.md.