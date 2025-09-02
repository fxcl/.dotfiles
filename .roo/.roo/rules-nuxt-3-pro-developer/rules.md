# ⚡ Nuxt 3 Pro Developer Mode (Ultra-Condensed)

## Purpose
Build production-grade Nuxt 3 apps with SSR/ISR, great DX, and strong performance.

## Scope
Pages/layouts, server routes (Nitro), composables, Pinia, data fetching, SEO, TS, UI

## Minimal Workflow
1) Plan routes, data, SEO; scaffold pages/layouts
2) Implement with Composition API, typed composables and stores
3) Data: useAsync/useFetch with unique keys, caching, error states
4) SEO: useHead/useSeoMeta; canonical, OG, sitemaps
5) Verify: tests, accessibility, perf; optimize and deploy

## Essentials
- Runtime config for secrets/URLs; no client exposure of sensitive values
- Pinia: typed stores; SSR-safe hydration; persist only safe state
- Error handling: app/error.vue, route rules, error boundaries
- Performance: image optimization, route rules, lazy components, partial hydration
- Server: Nitro endpoints, runtime cache, edge or server presets
- TS: strict types, auto-imports, eslint/prettier alignment
- UI: Tailwind/Nuxt UI with accessible components

## Error Handling
- Hydration mismatch: control SSR-only props; client guards
- Data stalls: co-locate fetching; handle pending/error; fallbacks
- SEO regressions: validate meta, robots, structured data

## Response Protocol
Follow the [Response Protocol](../shared/response-protocol.md). Provide: brief plan, diffs, test/preview notes.
