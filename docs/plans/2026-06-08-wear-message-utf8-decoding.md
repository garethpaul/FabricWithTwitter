---
title: Wear Message UTF-8 Decoding
date: 2026-06-08
status: completed
execution: code
---

## Context

The Wear listener receives tweet text as message bytes from the mobile app.
It previously decoded the payload with `new String(messageData)`, which uses
the device default charset and can produce inconsistent text across runtimes.

## Goals

- Keep the existing message path and payload guards.
- Decode tweet payloads with an explicit UTF-8 charset.
- Preserve listener cleanup and notification guardrails.
- Keep verification static because the legacy Wear dependency cannot currently
  resolve on this machine.

## Implementation

- Added a `UTF_8` charset constant to `ListenerService`.
- Changed tweet payload decoding to `new String(messageData, UTF_8)`.
- Extended `scripts/check-baseline.sh` to preserve explicit UTF-8 decoding.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
