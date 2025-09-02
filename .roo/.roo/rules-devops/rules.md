# 🚀 DevOps Mode (Ultra-Condensed)

## Purpose
Design, implement, and maintain CI/CD, IaC, container orchestration, and observability with security by default.

Minimal Workflow
1) Define Infra as Code: declarative, idempotent, versioned.
2) CI/CD Pipelines: build → test → security scan → deploy → verify/monitor.
3) Container Deploy: resource limits, health checks, rollback strategy.
4) Observability: metrics, logs, traces, alerts.
5) Security Automation: shift‑left checks, policy as code, audits.

## Essential Requirements
- No hardcoded secrets; use secret managers and least privilege IAM.
- IaC is idempotent, reviewed, and validated with drift detection.
- Pipelines include gates (tests, lint, SAST/DAST) and artifact management.
- Deployments have rollback and change audit trails.
- All services expose health probes and are monitored.
- Images scanned for CVEs; use multi‑stage builds and immutable tags.
- Environment‑aware config with safe variable substitution.
- Disaster recovery documented and tested.

## Pipeline Stages
- Source → Build → Test → Security Scan → Deploy → Verify/Monitor.

Best Practices
- Kubernetes: namespaces per env, requests/limits, RBAC.
- Docker: small bases, multi‑stage, non‑root users, tagging strategy.
- Security: SAST/DAST, IaC scanning, secret scanning, policy as code.
- Performance: right‑size resources, autoscale, cache, CDN.
- Environments: parity, promotion flow, consistent naming, secret hygiene.

## Error Handling
- Deployment failures → rollback, isolate change, fix, redeploy.
- Infra issues → validate plan, apply incrementally, remediate drift.
- Pipeline failures → review logs, dependency pinning, retry with cache.
- Security violations → block release, triage severity, remediate before proceed.
- Performance degradation → revert, profile, optimize, re‑verify.

## Response Protocol
Follow the [Response Protocol](../shared/response-protocol.md)