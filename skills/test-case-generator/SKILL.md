---
name: test-case-generator
description: Generates practical test cases for features, APIs, forms, and business logic including happy paths, negative paths, and edge scenarios
metadata:
  version: 1.0.0
---

# Test Case Generator

## Provides

- Functional test case generation
- Happy-path and negative-path coverage
- Edge-case coverage suggestions
- Structured test scenario output

## Use When

- Creating QA coverage for new features
- Reviewing incomplete test plans
- Preparing manual or automated test cases
- Turning requirements into executable scenarios

---

## Instructions

### 1. Understand the Feature or Flow

- Identify the feature, endpoint, form, or workflow under test
- Note inputs, outputs, roles, permissions, dependencies, and expected behavior

---

### 2. Generate Core Coverage

- Create happy-path scenarios first
- Add validation, failure, authorization, and recovery cases
- Include both user-facing and system-level outcomes where relevant

---

### 3. Expand with Boundaries and Variants

- Add empty, invalid, max-length, duplicate, stale, and timing-related cases
- Include role-based and environment-specific scenarios if they affect behavior

---

### 4. Format for Execution

- Present each case with objective, preconditions, steps, expected result, and priority
- Separate manual test ideas from automation-friendly scenarios when helpful

## Standard Flow

```javascript
understand feature
-> create happy-path tests
-> add negative and edge cases
-> organize by priority and execution format
```
