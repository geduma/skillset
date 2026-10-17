# Observability Checklist

Instrumentation baseline for production code.

## Logging

- [ ] Structured logging (JSON) with consistent fields (timestamp, level, service, trace ID)
- [ ] No sensitive data in logs (passwords, tokens, PII)
- [ ] Log levels used correctly (debug/info/warn/error)
- [ ] Actionable error messages (include context, not just stack traces)

## Metrics (RED)

- [ ] Request rate (Requests per second)
- [ ] Request errors (error rate by endpoint/status)
- [ ] Request duration (latency histograms, p50/p95/p99)
- [ ] Custom business metrics where relevant

## Tracing

- [ ] Distributed tracing with trace ID propagation across service boundaries
- [ ] Span names meaningful and consistent
- [ ] Key operations instrumented (DB queries, external API calls)

## Alerting

- [ ] Symptom-based alerts (user-visible impact), not just resource-based
- [ ] Alert thresholds based on SLIs/SLOs, not arbitrary values
- [ ] On-call runbook or documentation for each alert

## Red flags

- Unstructured or plain-text logs
- Sensitive data in logs
- No request duration metrics
- Alerts firing on CPU/memory without user-impact correlation
- No trace ID propagation across services