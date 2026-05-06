---
name: edge-case-detector
description: Identifies edge cases in product flows, APIs, forms, and business logic including boundary values, unusual states, and low-frequency failure scenarios
metadata:
  version: 1.0.0
---

# Edge Case Detector

## Provides

- Boundary-condition detection
- Unusual state and timing scenario review
- Low-frequency failure case discovery
- Missing test coverage suggestions

## Use When

- Reviewing feature completeness
- Expanding QA coverage beyond happy paths
- Investigating production-only failures
- Stress-testing assumptions in logic or workflows

---

## Instructions

### 1. Identify Assumptions

- Look for hidden assumptions about input, timing, ordering, state, permissions, or environment
- Focus on areas where the code or product assumes “normal” behavior

---

### 2. Probe Boundary Conditions

- Check empty, null, zero, one, max, min, duplicate, expired, and overflow-like cases
- Consider data volume, pagination boundaries, and partial-data states

---

### 3. Probe State and Timing Issues

- Check first-run, retry, refresh, race, stale-data, and interrupted-flow cases
- Look for issues during navigation changes, partial saves, or dependent-service failures

---

### 4. Report Actionable Edge Cases

- Describe the scenario, why it matters, and what behavior should be verified
- Prefer testable cases over abstract warnings

## Standard Flow

```javascript
identify assumptions
-> probe boundaries
-> probe state and timing changes
-> report actionable edge cases
```
