---
title: Wear Notification PendingIntent Refresh
type: correctness
date: 2026-06-13
status: planned
execution: code
---

# Wear Notification PendingIntent Refresh

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
