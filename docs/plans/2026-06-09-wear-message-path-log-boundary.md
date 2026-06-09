---
title: Wear Message Path Log Boundary
date: 2026-06-09
status: completed
execution: code
---

## Context

The Wear listener already rejects unexpected message paths before displaying a
tweet notification, but the diagnostic included the raw incoming path value.
Wear message paths are part of the cross-device protocol and can reveal app
behavior or test payload details without improving user-facing diagnostics.

## Goals

- Keep the unexpected-path guard in the Wear listener.
- Avoid logging raw incoming Wear message paths.
- Extend static verification so path-value logging does not return.
- Document the privacy boundary alongside the existing Wear message guards.

## Implementation

- Replaced the unexpected-path log with a generic diagnostic.
- Added a `scripts/check-baseline.sh` guard against logging
  `messageEvent.getPath()`.
- Updated README, VISION, and CHANGES with the Wear path logging boundary.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Android and Xcode verification remain unavailable in this environment.
