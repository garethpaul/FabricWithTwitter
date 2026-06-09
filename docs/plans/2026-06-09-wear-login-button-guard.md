---
title: Wear Login Button Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

The Android Wear mobile sample assumed `R.id.login_button` was present before
setting Twitter callbacks and forwarding `onActivityResult`. A stale or
modified legacy layout could therefore crash before tweet loading or Wear
message sending started.

## Goals

- Guard Twitter login callback setup when the login button view is unavailable.
- Guard activity-result forwarding when the login button was not initialized.
- Keep diagnostics generic and avoid logging raw Twitter exception details.
- Preserve successful login behavior and tweet loading when the view is present.
- Extend the static baseline and docs for the lifecycle boundary.

## Implementation

- Wrapped `loginButton.setCallback(...)` in a null check.
- Added a generic warning when the login button view is missing.
- Added a generic login failure diagnostic.
- Guarded `loginButton.onActivityResult(...)` behind the same null check.
- Extended `scripts/check-baseline.sh`, README, SECURITY, VISION, and CHANGES.

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
