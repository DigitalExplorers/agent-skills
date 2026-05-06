---
name: bug-reproduction-assistant
description: Helps reproduce reported bugs by turning vague reports into concrete steps, environment assumptions, test data needs, and likely triggering conditions
metadata:
  version: 1.0.0
---

# Bug Reproduction Assistant

## Provides

- Reproduction-step refinement
- Environment and test-data assumptions
- Trigger-condition analysis
- Clear bug report reproduction output

## Use When

- A bug report is vague or incomplete
- A team cannot reproduce an issue consistently
- Investigating intermittent failures
- Turning user complaints into concrete QA steps

---

## Instructions

### 1. Extract the Reported Symptoms

- Identify what the reporter saw, expected, and was doing before the issue
- Capture device, browser, role, environment, timing, and data conditions if available

---

### 2. Build Reproduction Hypotheses

- Translate vague behavior into testable step sequences
- Consider role, state, timing, stale session, data setup, and network conditions

---

### 3. Narrow the Trigger

- Isolate the smallest sequence likely to reproduce the issue
- Separate always-reproducible steps from intermittent conditions

---

### 4. Produce a Repro Pack

- Provide preconditions, exact steps, expected result, actual result, and suspected trigger factors
- Note any missing information that blocks a high-confidence repro

## Standard Flow

```javascript
extract symptoms
-> form reproduction hypotheses
-> narrow the trigger sequence
-> produce clear reproduction steps
```
