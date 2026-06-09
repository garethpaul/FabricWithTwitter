---
title: Wear Message UTF-8 Sender
date: 2026-06-09
status: completed
execution: code
---

## Context

The Wear listener now decodes incoming tweet payload bytes with an explicit
UTF-8 charset, but the mobile sender still used `tweetText.getBytes()` without
a charset. That leaves the sender side dependent on the device default encoding
and can corrupt cross-device tweet text.

## Goals

- Encode mobile-to-watch tweet payloads with the same UTF-8 contract used by
  the listener.
- Preserve missing-message and disconnected-client guards in the sender.
- Keep raw Wear paths and payloads out of logs.
- Extend the static baseline so both sides of the message contract stay aligned.

## Implementation

- Added a `UTF_8` charset constant to the Wear mobile `MainActivity`.
- Changed `sendMessage` to call `tweetText.getBytes(UTF_8)`.
- Updated README, VISION, CHANGES, and the baseline checker with the sender-side
  encoding contract.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Android and Xcode builds are still skipped locally because the matching
legacy SDKs/toolchains are not installed in this environment.
