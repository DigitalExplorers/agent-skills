---
name: input-validation-tester
description: Tests whether forms, APIs, and business logic correctly validate required fields, formats, ranges, unsafe input, and invalid combinations
metadata:
  version: 1.0.0
---

# Input Validation Tester

## Provides

- Required-field validation coverage
- Format, range, and constraint testing
- Invalid-combination and unsafe-input checks
- Error-message and validation-path review

## Use When

- Testing forms or APIs
- Reviewing validation logic
- Hardening user input handling
- Checking whether invalid data is blocked consistently

---

## Instructions

### 1. Identify Accepted Inputs

- List required, optional, derived, and restricted inputs
- Capture type, format, length, range, and combination rules

---

### 2. Test Valid and Invalid Inputs

- Cover valid baseline inputs first
- Add empty, malformed, oversized, out-of-range, duplicate, and incompatible values

---

### 3. Check System Behavior

- Confirm invalid input is rejected at the correct boundary
- Check whether error messages are clear, safe, and consistent
- Ensure invalid data does not silently pass deeper into the system

---

### 4. Report Gaps

- Note missing validation, inconsistent rules, weak error handling, or unsafe fallback behavior

## Standard Flow

```javascript
identify accepted inputs
-> test valid and invalid values
-> verify rejection behavior and error messages
-> report validation gaps
```
