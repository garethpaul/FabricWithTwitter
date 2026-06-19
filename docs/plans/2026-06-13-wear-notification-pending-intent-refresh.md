---
title: Wear Notification PendingIntent Refresh
type: correctness
date: 2026-06-13
status: completed
execution: code
---

# Wear Notification PendingIntent Refresh

## Status: Completed

## Summary

Refresh the reused Wear notification `PendingIntent` so tapping a later
notification opens the latest validated tweet text instead of stale extras.

## Problem

The listener creates every notification activity intent with the same request
code and flags `0`. Android may return the existing `PendingIntent` unchanged,
retaining the first tweet extra even after a later notification is displayed.

## Requirements

- R1. Keep the existing explicit `NotificationActivity` intent and tweet extra.
- R2. Reuse the request code while applying `PendingIntent.FLAG_UPDATE_CURRENT`.
- R3. Preserve path, payload-size, strict UTF-8, non-empty text, notification,
  listener cleanup, and privacy boundaries.
- R4. Add exact static, documentation, completion, and mutation contracts.
- R5. Do not claim an Android/Wear build, emulator, device, Fabric, or Twitter
  runtime from the available maintenance environment.

## Verification Plan

- Run a focused PendingIntent source contract.
- Run `make check`, `make lint`, `make test`, and `make build`.
- Reject mutations that restore flags `0`, remove the explicit extra, stale the
  plan, or remove evidence.
- Audit exact paths, generated artifacts, credentials, and unchanged project,
  workflow, manifest, and dependency surfaces.

## Non-Goals

- Modernizing Android notification channels or mutability flags for current SDKs.
- Changing notification IDs, tweet payloads, Wear paths, or UI content.

## Work Completed

- Added `PendingIntent.FLAG_UPDATE_CURRENT` to the existing explicit
  notification activity intent.
- Preserved the request code and validated tweet extra while ensuring later
  notifications refresh stale PendingIntent state.
- Added source, documentation, and completed-plan contracts.

## Verification Completed

- The focused source contract required exactly one update-current PendingIntent,
  rejected flags `0`, and preserved the explicit validated tweet extra.
- `make check`, `make lint`, `make test`, and `make build` passed the maintained
  Linux baseline; local Android/Wear and xcodebuild toolchains were unavailable.
- `sh -n scripts/check-baseline.sh` and `git diff --check` passed.
- Four isolated hostile mutations were rejected: flags `0`, missing tweet extra,
  stale plan status, and missing mutation evidence.
- No Android/Wear emulator or device, Fabric/Twitter credential, network request,
  signing material, or live notification interaction was used.
