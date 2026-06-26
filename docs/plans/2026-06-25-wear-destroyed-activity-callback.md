# Wear Destroyed Activity Callback Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

status: completed

**Goal:** Prevent delayed TwitterKit callbacks from reconnecting the Wear client or updating UI after `MainActivity` is destroyed.

**Architecture:** Keep `MainActivity` as the legacy client owner and add one volatile lifecycle signal checked at every asynchronous ownership handoff. Preserve the existing TwitterKit, `GoogleApiClient`, and raw-thread structure.

**Tech Stack:** Java 7, Android Activity lifecycle, legacy Google Play Services Wear API, shell/Python repository contracts.

---

## Tasks

1. Add failing baseline contracts for destroyed-activity callback and reconnect ordering.
2. Add the activity destruction signal and callback guard.
3. Guard worker dispatch before and after connection establishment.
4. Set destruction before disconnecting the client in `onDestroy`.
5. Update repository guidance and run mutation-sensitive verification.

## Verification Completed

- `make check` failed before implementation on the missing activity-destruction signal.
- `make check` and `git diff --check` pass after implementation.
- Removing the delayed tweet callback guard is rejected by the baseline.
- Removing the post-connect destruction cleanup is rejected by the baseline.
- Exact-diff review found and closed destruction races between callback work and
  login/tweet UI publication.
- Local Swift execution and Xcode project listing remain unavailable and require the hosted macOS gate.
