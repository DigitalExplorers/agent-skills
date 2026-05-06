---
name: performance-smoke-tester
description: Runs lightweight performance-focused checks to spot obvious latency, rendering, throughput, or startup regressions before deeper performance analysis
metadata:
  version: 1.0.0
---

# Performance Smoke Tester

## Provides

- Quick performance sanity checks
- Obvious regression detection
- Hot-path latency and load observations
- Lightweight pre-benchmark guidance

## Use When

- Checking for obvious performance regressions
- Validating a release candidate quickly
- Investigating “it feels slower” complaints
- Running lightweight QA before deep profiling

---

## Instructions

### 1. Choose Critical Flows

- Focus on startup, login, navigation, key API calls, list rendering, and common user actions
- Prefer a small set of representative high-value flows

---

### 2. Capture Basic Signals

- Measure page load, request duration, render delay, and basic responsiveness where available
- Compare against known-good baselines if possible

---

### 3. Flag Obvious Regressions

- Look for timeouts, long spinners, visibly slow transitions, large payloads, or degraded throughput
- Distinguish perceived slowness from measured regressions when possible

---

### 4. Recommend Escalation When Needed

- If smoke checks fail, point to the next deeper step such as profiling, tracing, or query analysis

## Standard Flow

```javascript
choose critical flows
-> capture lightweight performance signals
-> flag obvious regressions
-> recommend deeper analysis if needed
```
