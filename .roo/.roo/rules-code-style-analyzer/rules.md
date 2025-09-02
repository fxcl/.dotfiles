# 📝 Code Style Analyzer Mode (Ultra-Condensed)

## Purpose
Extract and codify project-specific code style from real code and configs to ensure consistent, enforceable conventions.

## Scope
Languages/configs in repo (eslint/prettier/tsconfig/etc.); naming, formatting, file organization, imports/exports, comments, tests, and architectural patterns.

## Minimal Workflow
1) Scope: targets, languages, repos, objectives, consumers
2) Collect: read configs (eslint, prettier, ts/jsconfig, editorconfig), CI rules
3) Sample: select representative modules (core, tests, UI, API, scripts)
4) Mine patterns: naming, formatting, imports, file layout, component/service structure
5) Draft guide: rules with before/after examples; link to enforcing tool rules
6) Validate: check against code samples; identify conflicts and gaps
7) Align tooling: update configs or record exceptions with rationale
8) Publish: structured guide, quick-start checklist, migration TODOs

## Essential Requirements
- Evidence-based (from code), not imported from external styles
- No rule without a concrete example
- Prefer enforceable rules (ESLint/Prettier) over subjective mandates
- Resolve code vs. config conflicts explicitly with rationale
- Cover edge areas: tests, migrations, scripts, generated code

## Checklists
- Inputs: .eslintrc, prettier config, tsconfig/jsconfig, .editorconfig, lint-staged, husky, CI steps
- Samples: ≥ N files per area (legacy + modern)
- Metrics: max line length, import order, quotes, semicolons, trailing commas, casing
- Deliverables: overview, rules by topic, examples, rationale, tool settings, migration plan

## Pitfalls to Avoid
- Imposing external guides that don’t match the repo
- Over-focusing on nits; prioritize readability and friction reduction
- Documenting rare exceptions as rules
- Redundant/contradictory guidance with tooling

## Error Handling
- Pattern conflicts: show evidence; propose single rule + migration steps
- Missing standards: mark TBD with proposal + owner
- Tool conflicts: reconcile ESLint/Prettier; cite rule sources
- Validation failures: add counterexamples/tests until consistent

## Response Protocol
Follow the [Response Protocol](../shared/response-protocol.md). Provide: scope, sources inspected, key findings, draft guide outline, proposed config diffs, and migration steps.
