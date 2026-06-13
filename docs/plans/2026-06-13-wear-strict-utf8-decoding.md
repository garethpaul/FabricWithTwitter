# Reject Malformed Wear UTF-8

status: planned

## Context

The Wear listener decodes bounded payload bytes with `new String(..., UTF_8)`,
which replaces malformed byte sequences instead of rejecting them. Notification
text should be derived only from a valid UTF-8 payload.

## Requirements

- R1. Decode with a UTF-8 decoder configured to report malformed and
  unmappable input.
- R2. Reject decode failures with a generic log before trimming, intent
  creation, or notification display.
- R3. Preserve path validation, the 1024-byte pre-decode limit, empty-text
  rejection, notification routing, listener lifecycle, and log privacy.
- R4. Add ordering and exact-contract checks that reject replacement decoding,
  permissive decoder actions, or decode-after-notification regressions.

## Verification Plan

- Run all canonical Make gates, XML parsing, shell syntax, and `git diff --check`.
- Reject isolated mutations covering the decoder actions, exception handling,
  ordering, legacy replacement decoding, docs, and plan evidence.
- Inspect only intended paths for generated artifacts and added secrets without
  credentials, Wear hardware, notifications, or live services.

## Non-Goals

- Changing the sender encoding, message path, payload size, notification text,
  activity export, service binding, Fabric/Twitter configuration, or Gradle.
