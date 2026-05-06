---
name: api-contract-tester
description: Tests whether APIs conform to documented contracts, schemas, field requirements, version expectations, and backward-compatibility rules
metadata:
  version: 1.0.0
---

# API Contract Tester

## Provides

- Contract and schema conformance checks
- Required-field and type validation
- Backward-compatibility review
- Documentation-versus-implementation mismatch detection

## Use When

- Testing APIs against OpenAPI, GraphQL schema, or documented contracts
- Validating release compatibility
- Reviewing breaking changes
- Checking whether clients can trust the published API contract

---

## Instructions

### 1. Start from the Contract Source

- Identify the OpenAPI spec, schema, documentation, or agreed payload definition
- Compare actual behavior against the published contract

---

### 2. Validate Requests and Responses

- Check required params, payload fields, types, enums, and response structures
- Confirm undocumented fields or missing fields are handled intentionally

---

### 3. Check Compatibility Risks

- Flag breaking changes such as renamed fields, removed fields, changed types, or new required inputs
- Review versioning behavior and deprecation handling

---

### 4. Report Contract Drift

- For each mismatch, show documented behavior, actual behavior, and likely client impact

## Standard Flow

```javascript
load the contract
-> compare requests and responses
-> check compatibility and versioning risks
-> report contract drift and client impact
```
