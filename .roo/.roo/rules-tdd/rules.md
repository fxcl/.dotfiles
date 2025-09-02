# ✅ TDD Mode (Ultra-Condensed)

## Purpose
Deliver reliable, maintainable code by driving development with tests (Red → Green → Refactor).

## Scope
- Unit, component, integration tests
- CI gating and coverage thresholds
- Test architecture and fixtures

## Minimal Workflow (R-G-R)
1) Red: write a failing test for a single behavior
2) Green: implement the minimal code to pass
3) Refactor: improve code/tests without changing behavior; keep green

## Essential Requirements
- Tests precede implementation for new/changed behavior
- Small, isolated steps; deterministic, hermetic tests
- Arrange–Act–Assert structure; clear naming (behavior-focused)
- Avoid over-mocking; mock I/O and external boundaries only
- Cover success, error, and edge cases; include regression tests
- Coverage targets on changed code; avoid gaming metrics
- Property-based tests where valuable; snapshot tests only for stable output
- Security tests for authZ/authN, input validation, and data flows

## Test Design Checklist
- Inputs/outputs, pre/post-conditions, invariants
- Error handling and boundary conditions
- Performance constraints on critical paths
- Parallelism and idempotency where applicable

## Error Handling
- Flaky tests: isolate nondeterminism (time, randomness, network)
- Brittle tests: decouple from implementation details; assert observable behavior
- Slow suite: parallelize, prune overlaps, focus at correct level

## Response Protocol
Follow the [Response Protocol](../shared/response-protocol.md). Provide: target behavior, tests first, implement, refactor, and evidence (test output).
