# Continue Agents & Rules

This repository uses local Continue agents with very tight scopes and reusable rules.

- Agents live in `.continue/agents/*.yaml` and can be selected in the Continue panel.
- Rules live in `.continue/rules/*.yaml` and are imported by agents via `rules: - uses: repo/<name>`.
- If agents do not appear, click “Reload config” in the agent selector.

Assembly-line workflow for lifted migration:

1. DeepSeek — Lifted Scaffolder: create `lifted/<fn>/index.ts` + `index.test.ts`.
2. DeepSeek — Test Reviewer: improve correctness/coverage in tests only.
3. DeepSeek — Imports & Grouping: fix import grouping/order and blank lines.
4. DeepSeek — Envoy Comment Fixer: add/correct Envoy comments (comments only).
5. DeepSeek — Monadic Implementer: implement strict FP monadic version to pass tests (no test edits).
6. DeepSeek — Final Reviewer: small surgical fixes to pass all gates.

Guardrails:

- Each agent lists explicit Allowed/Forbidden changes in its YAML rules; stay within scope.
- Pre-commit hooks remain the hard gate (contracts, FP checks, tests, formatting, types, alias policy, coverage ignore audit).

Tips:

- Keep prompts small and include the exact folder you want to change.
- Use the prior step’s short “handoff” summary as the starting prompt for the next agent.

## Using cloud agents with worktrees

You can offload specific steps to cloud models (Anthropic/OpenAI) while the main worktree uses local DeepSeek:

- Cloud agent variants provided:
 	- `Claude — Imports & Grouping`
 	- `Claude — Final Reviewer`
 	- `GPT — Test Reviewer`
- Add your API keys in `.continue/config.json` for the matching providers.

### API keys (Anthropic/OpenAI)

- Anthropic: A single Anthropic API key works for all Anthropic models in your account/region. You can use the same key for both Sonnet and Opus entries below.
 	- Models defined in `.continue/config.json`:
  		- `Claude Opus 4.1 (Anthropic)` → `claude-opus-4.1`
  		- `Claude Sonnet 4 (Anthropic)` → `claude-sonnet-4`
 	- Paste your Anthropic key into each model's `apiKey` field or set the `ANTHROPIC_API_KEY` environment variable (Continue will pick it up if supported).
- OpenAI: Paste your OpenAI key into the `GPT-5 (OpenAI)` model's `apiKey` field or set `OPENAI_API_KEY`.

### Guardrails usage & toggle

- All cloud agents now include `repo/stable-header` and `repo/guardrails` first to increase cache hits and enforce safe scopes.
- To temporarily disable guardrails for an experiment, comment out the `- uses: repo/guardrails` line in the specific agent YAML; prefer creating a separate "-experimental" agent instead of editing the main one.
- If you revise the guardrails text, add a new versioned file (e.g., `guardrails-v2.yaml`) to preserve caching for existing agents.

## Troubleshooting

### Disable inline “ghost text” suggestions

- Continue tab autocomplete: removed in `.continue/config.json` (no `tabAutocompleteModel`).
- VS Code: set `"editor.inlineSuggest.enabled": false` (we set this in `.vscode/settings.json`).
- Copilot (if installed): set `"github.copilot.inlineSuggest.enable": false` in workspace settings.
- Other providers (if installed):
 	- Codeium: disable or set `"codeium.enable_search": false` in workspace settings.
 	- TabNine: disable inline features, e.g., `"tabnine.experimentalAutoImports": false`.

If suggestions persist, run “Developer: Show Running Extensions” and temporarily disable likely sources to isolate.

- Run `deno run -A scripts/setupWorktrees/syncContinueConfig.ts` to copy `.continue` to every worktree and set hooks.
- Use one worktree (e.g., `ai/toolsmith`) with local DeepSeek agents and assign well-scoped, parallel tasks to other worktrees using cloud agents (imports-only, tests-only, or final reviewer). Keep scopes tight to reduce conflicts.

Integration guidance:

- Prefer the same micro-agent assembly line in each worktree; avoid overlapping scopes.
- Let the main worktree perform the “Monadic Implementer” step to keep core logic centralized.
- Use your existing `integrate` task to merge completed worktrees back to `main` serially.

### Scripts folder refactor (Claude pipeline)

Run these agents in order, targeting `scripts/` with small, file/folder-scoped prompts:

1) Claude — Scripts Refactor Step 1: Extract Named Functions
2) Claude — Scripts Refactor Step 2: Extract Constants & Types
3) Claude — Scripts Refactor Step 3: Tests Pass & Cover
4) Claude — Scripts Refactor Step 4: Style Cleanup
5) Claude — Scripts Refactor Step 5: Envoy Comments

Notes:

- Step 1 will create subfolders (one function per folder) and replace inline lambdas with named default exports, placing shared helpers at the lowest common ancestor.
- Step 2 moves constants/types to `constants/index.ts` and `types/index.ts` as named exports.
- Steps 3–5 are read-only to production logic (tests-only, style-only, comments-only respectively).

## Cost estimator for GPT API

Use the built-in estimator to forecast monthly spend (USD/NZD):

- Basic (your rates):
 ```sh
 deno task estimate:gpt -- --in-rate 1.25 --out-rate 10 --light 30 --medium 10 --heavy 2 --fx 1.7
 ```

- With prompt caching (example: 70% cached at $0.125/M):
 ```sh
 deno task estimate:gpt -- --in-rate 1.25 --out-rate 10 --cached-in-rate 0.125 --cached-in-share 0.7 --light 30 --medium 10 --heavy 2 --fx 1.7
 ```

- The estimator assumes token footprints per run: light=20K/2K, medium=60K/6K, heavy=150K/12K (in/out).

### Prompt caching notes

- A new rule block `repo/stable-header` is included first in cloud agents to maximize cache hits. Keep it byte-identical.
- If you change the header text, create a new versioned file instead of editing the existing one to preserve cache effectiveness.
- In the estimator, use `--cached-in-rate` and `--cached-in-share` to model savings; set share to 0 if unsure.
