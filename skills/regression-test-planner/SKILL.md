---
name: regression-test-planner
description: Builds focused regression plans around changed features, dependencies, and user flows to reduce the risk of unintended breakage after releases
metadata:
  version: 1.0.0
---

# Regression Test Planner

## Provides

- Change-based regression planning
- Impacted flow identification
- Priority-based regression scope
- Release-focused validation guidance

## Use When

- Preparing for a release
- Reviewing a large change set
- Planning post-fix validation
- Deciding what must be retested after code changes

---

## Instructions

### 1. Start from the Change Surface

- Identify changed modules, endpoints, UI flows, integrations, and dependencies
- Map direct and indirect impact areas

---

### 2. Group Regression Risks

- Cover primary user flows first
- Add adjacent flows, shared components, permissions, integrations, and data dependencies
- Include fixed bugs likely to reappear

---

### 3. Prioritize the Plan

- Mark must-test, high-risk, and optional regression areas
- Bias toward critical business workflows, auth, payments, data integrity, and shared infrastructure

---

### 4. Produce an Executable Plan

- Output a concise checklist or scenario set that QA or developers can run
- Include what changed, what could break, and what evidence would confirm stability

## Standard Flow

```javascript
identify changed areas
-> map impacted flows
-> prioritize regression coverage
-> produce an executable retest plan
```
