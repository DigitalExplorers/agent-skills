---
name: ui-functional-tester
description: Tests whether user interface flows behave correctly across navigation, forms, actions, states, and user roles in web applications
metadata:
  version: 1.0.0
---

# UI Functional Tester

## Provides

- End-to-end UI behavior checks
- Navigation and interaction flow testing
- State and role-based behavior review
- Functional mismatch detection in web interfaces

## Use When

- Testing user-facing application flows
- Verifying form and navigation behavior
- Reviewing release readiness for UI features
- Checking whether the interface behaves correctly for real users

---

## Instructions

### 1. Identify Critical User Flows

- Focus on login, navigation, form submission, CRUD actions, filtering, and confirmation flows
- Include user roles or permissions where they affect behavior

---

### 2. Test Visible Behavior

- Verify buttons, links, forms, dialogs, loaders, empty states, and errors behave correctly
- Check that state changes are reflected clearly in the UI

---

### 3. Check Interaction Sequences

- Test forward flow, back navigation, cancel paths, retries, refresh, and repeated actions
- Confirm the UI remains consistent after failures or partial completion

---

### 4. Report Functional Gaps

- Describe broken steps, incorrect UI state, missing feedback, or role-specific mismatches

## Standard Flow

```javascript
identify critical flows
-> test visible behavior and interactions
-> check retries, failures, and role-based variations
-> report functional gaps
```
