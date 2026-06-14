---
title: iOS Twitter Main Queue Publication
type: reliability
date: 2026-06-14
status: completed
execution: code
---

# iOS Twitter Main Queue Publication

## Summary

Keep the TableViewTweetsSwift controller's asynchronous TwitterKit state and UI
publication on the main queue. Preserve the existing in-flight guard, generic
failure diagnostics, and typed tweet filtering.

## Prioritized Engineering Tasks

1. Dispatch guest-login completion state to the main queue.
2. Dispatch tweet-load completion, in-flight release, and tweet publication to
   the main queue.
3. Keep the login failure path from starting tweet loading.
4. Add source-order and documentation contracts for both boundaries.

## Requirements

- R1. `isLoadingTweets` changes from TwitterKit callbacks must occur on the main
  queue.
- R2. `tweets` assignment and its table reload must occur on the main queue.
- R3. Login failure must clear in-flight ownership and return before tweet load.
- R4. Loaded response objects must remain conditionally cast to `TWTRTweet`.
- R5. No live Twitter login or credential-backed request may run in validation.

## Non-Goals

- Replacing retired Fabric or TwitterKit dependencies.
- Changing hard-coded sample tweet IDs or refresh behavior.
- Claiming simulator or device execution from Linux validation.

## Verification

- The focused static baseline passed callback ordering, in-flight reset, typed
  tweet filtering, generic diagnostics, and permalink contracts before stopping
  only at the pending completed-plan assertion.
- Six in-memory hostile mutations were rejected across either main-queue
  boundary, login/load reset ordering, tweet publication, and typed filtering.
- Full `make check`, `make lint`, `make test`, and `make build` pass from the
  repository, and `make check` passes from `/tmp` through the absolute Makefile
  path; unavailable historical Android/Xcode toolchains remain truthful skips.
- Exact intended-path, generated-artifact, protected-file, whitespace,
  conflict-marker, and changed-line credential-pattern audits pass before
  delivery.
