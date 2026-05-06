---
name: api-response-validator
description: Validates API responses for status correctness, payload shape, required fields, error format, and consistency when testing REST or GraphQL endpoints
metadata:
  version: 1.0.0
---

# API Response Validator

## Provides

- Response shape validation
- Required field and type checks
- Status and error-format review
- Response consistency checks across similar endpoints

## Use When

- Testing REST or GraphQL APIs
- Validating backend changes
- Reviewing API behavior against expected contracts
- Checking whether clients can rely on response structure

---

## Instructions

### 1. Start with Expected Behavior

- Identify the endpoint, query, or mutation under test
- Define expected status codes, required fields, optional fields, and error shapes
- Check success, failure, empty, and edge-case responses

---

### 2. Validate Status and High-Level Structure

- Confirm the response status matches the actual outcome
- Check whether the payload envelope is consistent with the API style
- Flag responses that mix success and error structures unpredictably

---

### 3. Validate Required Fields and Types

- Check that required fields are present
- Verify field types are stable and predictable
- Flag missing fields, null mismatches, or unexpected type changes

---

### 4. Validate Error Responses

- Check validation, auth, not-found, and server-error responses
- Ensure errors use a consistent structure and do not leak internal details
- Confirm clients can distinguish failure types safely

---

### 5. Compare Similar Endpoints

- Review whether related endpoints return similar naming, nesting, and field conventions
- Flag inconsistent pagination, metadata, or resource representations

---

### 6. Report Findings Clearly

- Include endpoint, observed issue, expected behavior, and likely impact
- Separate confirmed mismatches from assumptions about undocumented behavior

## Standard Flow

```javascript
define expected response
-> check status and envelope
-> validate required fields and types
-> inspect error responses
-> compare consistency across similar endpoints
```
