---
title: Wear Notification Text View Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

The Android Wear notification activity already trimmed tweet extras before
display, but it assumed `R.id.text_view` was present in the inflated layout. A
stale or modified legacy layout could therefore crash before showing or
skipping the sanitized tweet text.

## Goals

- Preserve the existing tweet extra trimming and blank-text skip behavior.
- Avoid a null dereference when the notification text view target is missing.
- Keep diagnostics generic and avoid logging tweet contents.
- Extend the static baseline and docs for the display-target boundary.

## Implementation

- Added an early null guard after resolving `R.id.text_view`.
- Logged a generic warning when the notification text view is unavailable.
- Extended `scripts/check-baseline.sh` to require the guard and completed plan.
- Updated README, SECURITY, VISION, and CHANGES.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`

Full Android behavior verification still requires a compatible local Android
SDK and Twitter/Fabric credentials.
