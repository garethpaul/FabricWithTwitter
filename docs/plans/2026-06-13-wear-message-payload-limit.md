---
title: Wear Message Payload Limit
type: security
status: completed
date: 2026-06-13
---

# Wear Message Payload Limit

## Summary

Bound the UTF-8 tweet payload sent from the Android phone sample and accepted by
the Wear listener so oversized cross-device messages fail closed.

## Priority

1. Reject oversized tweet payloads before wearable transport or decoding.
2. Keep sender and listener limits identical and explicit.
3. Preserve valid tweet display, notification, path, and UTF-8 behavior.

## Requirements

- R1. The mobile sender and Wear listener must each define a 1024-byte maximum.
- R2. The mobile sender must encode once, reject oversized bytes, and send only
  the validated byte array.
- R3. The listener must reject oversized message bytes before constructing a
  string, intent, pending intent, or notification.
- R4. Oversize diagnostics must remain generic and must not log paths, payloads,
  tweet text, IDs, usernames, or exception details.
- R5. Static count and ordering contracts must prevent sender/listener limit
  drift and validation bypass.
- R6. Existing null, empty, whitespace, path, activity export, and display-target
  guards must remain unchanged.

## Non-Goals

- Truncating tweets or changing notification text.
- Replacing the retired Wearable API, Fabric, TwitterKit, or Gradle toolchain.
- Adding message authentication or changing the `/new_tweet` path.
- Claiming Android/Wear runtime behavior without compatible historical SDKs and
  paired devices.

## Implementation Units

### 1. Mobile Sender Limit

Files: `Android/WearExample/mobile/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/MainActivity.java`

- Encode trimmed tweet text once as UTF-8.
- Reject payloads over 1024 bytes before starting the send thread.
- Reuse the validated byte array for every connected node.

### 2. Wear Listener Limit

Files: `Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/ListenerService.java`

- Reject message data over 1024 bytes before UTF-8 decoding.
- Keep path and empty-payload checks ahead of notification construction.

### 3. Static Contracts and Guidance

Files: `scripts/check-baseline.sh`, `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`

- Require equal constants and guard-before-send/decode ordering.
- Record platform limitations and completed hostile verification.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build`.
- Remove the sender guard, remove the listener guard, and drift one limit; the
  static gate must reject each mutation.
- Run shell syntax, XML parsing, `git diff --check`, and intended-file secret
  scans.
- Take one bounded exact-head pull-request and CodeQL snapshot after push; do not
  poll.

## Work Completed

- Added matching 1024-byte payload constants to the mobile sender and Wear
  listener.
- Encoded the outbound tweet once, rejected oversized bytes before starting the
  send thread, and reused the validated byte array for each connected node.
- Rejected oversized inbound bytes before UTF-8 decoding, intent construction,
  or notification creation.
- Extended the static gate with exact constants, generic diagnostics, shared
  limit checks, and fail-closed ordering contracts.
- Updated repository guidance and change history with the cross-device payload
  boundary.

## Verification Completed

- `make check`, `make lint`, `make test`, and `make build` passed against the
  final implementation. Each target ran the rooted static baseline gate;
  `xcodebuild` project listing was skipped because `xcodebuild` is not installed.
- `sh -n scripts/check-baseline.sh`, Android manifest XML parsing, and
  `git diff --check` passed.
- The intended-file secret scan returned no candidate credentials.
- The sender guard mutation failed with `Wear mobile sender must enforce and
  reuse the reviewed 1024-byte payload limit.`
- The listener guard mutation failed with `Wear listener must enforce the
  reviewed 1024-byte payload limit before decoding.`
- The limit drift mutation failed with `Wear listener must enforce the reviewed
  1024-byte payload limit before decoding.`
- The hosted pull-request check is not available before push; one bounded
  exact-head snapshot will be recorded in the engineering tracker without
  polling.
