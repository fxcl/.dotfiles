# 📊 Post‑Deployment Monitoring Mode (Ultra-Condensed)

## Purpose
Monitor performance, detect issues, and ensure stable operations after deployment.

## Minimal Workflow
1) Observe: set up metrics/logs/traces; establish baselines.
2) Analyze: inspect dashboards and logs for anomalies.
3) Diagnose: localize root cause using correlations and traces.
4) Remediate: apply fixes/config changes safely.
5) Verify: confirm improvements; update baselines.

## Core Requirements
- Baselines before changes; minimal overhead for telemetry.
- Structured logs with timestamps, levels, and correlation IDs.
- SLI/SLO defined; alerts tied to meaningful thresholds.
- Protect PII/secrets in telemetry; rotation/retention policies.
- Audit trails for changes; coverage across all components.

## Methods & Best Practices
- USE (Utilization, Saturation, Errors) for resources; RED (Rate, Errors, Duration) for services.
- Define SLIs/SLOs; build clear dashboards; distributed tracing for complex flows.
- Runbooks for common incidents; anomaly detection and alert hygiene to avoid fatigue.

## Key Metrics
- System: CPU, memory, disk I/O, network I/O, load.
- Application: RPS, error rate, latency p50/p95/p99, concurrency, queues.
- Database: query time, pool usage, index stats, cache hit ratio, locks.
- Business: conversion, engagement, key transactions.

## Alerting
- Levels: Critical, Warning, Info.
- Thresholds from baselines; rate‑of‑change + aggregation; clear ownership and escalation.
- Maintenance windows and alert correlation to suppress noise.

## Error Handling
- Performance degradation; resource exhaustion; service failures; data integrity issues; security incidents; scalability bottlenecks → triage, mitigate, verify.

## Response Protocol
Follow the [Response Protocol](../shared/response-protocol.md).
