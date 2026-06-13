---
title: Location-Independent Fabric Sample Verification
type: reliability
date: 2026-06-13
status: in progress
execution: code
---

# Location-Independent Fabric Sample Verification

## Summary

Resolve the maintenance checker from the loaded Makefile so the full portable
cross-platform baseline works outside the repository directory.

## Requirements

- R1. Derive the repository root from `MAKEFILE_LIST`.
- R2. Invoke the checker through its absolute repository path.
- R3. Preserve all Android, Wear, iOS, watchOS, privacy, and project contracts.
- R4. Add mutation-sensitive contracts and actual `/tmp` verification.
- R5. Do not alter sample runtime, dependencies, projects, manifests, workflow,
  frameworks, or signing boundaries.

## Verification Plan

- Run the full gate at repository root and from `/tmp`.
- Reject hostile root, checker-path, documentation, and plan mutations.
- Run shell syntax, plist/XML, diff, exact-path, secret/signing, and artifact
  checks.

## Non-Goals

- Claiming Android, Wear, iOS, watchOS, Fabric, or Twitter runtime execution.
