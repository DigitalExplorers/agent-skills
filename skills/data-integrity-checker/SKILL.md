---
name: data-integrity-checker
description: Checks whether data remains correct, complete, and consistent across validation, storage, transformation, sync, and reporting flows
metadata:
  version: 1.0.0
---

# Data Integrity Checker

## Provides

- Data consistency validation
- Transformation and sync review
- Missing, duplicated, or corrupted data checks
- Cross-layer integrity risk analysis

## Use When

- Investigating incorrect records or mismatched reports
- Validating migrations, imports, or sync jobs
- Testing write flows that touch multiple systems
- Checking whether stored data remains trustworthy over time

---

## Instructions

### 1. Identify the Source of Truth

- Determine where authoritative data should live
- Map how values are created, transformed, stored, synced, and displayed

---

### 2. Check Write and Update Paths

- Review creation, update, deletion, merge, and sync flows
- Look for dropped fields, duplicate writes, stale overwrites, and partial updates

---

### 3. Compare Across Layers

- Compare input, stored records, derived data, downstream copies, and reported output
- Flag mismatches in IDs, status, timestamps, totals, or relationships

---

### 4. Report Integrity Risks

- Describe what becomes inconsistent, where the drift occurs, and the likely business impact

## Standard Flow

```javascript
identify source of truth
-> trace write and sync paths
-> compare data across layers
-> report integrity mismatches and risks
```
