# Wear Listener Lifecycle

status: completed

## Summary

Use `WearableListenerService` as the Wear app's sole background message receiver. Remove the redundant `GoogleApiClient` listener registration and cleanup lifecycle while preserving the existing fail-closed payload and notification behavior.

## Problem Frame

`ListenerService` is already managed and invoked by the Wear Data Layer through `WearableListenerService`, but it also creates a `GoogleApiClient` and registers itself with `Wearable.MessageApi`. That second listener is unnecessary, can duplicate delivery, and adds connection cleanup paths that do not belong to a framework-managed listener service.

Google's `WearableListenerService` reference states that the Wear lifecycle manages the service and recommends minimizing listener count: <https://developers.google.com/android/reference/com/google/android/gms/wearable/WearableListenerService>.

## Requirements

- **R1:** `ListenerService` must receive background messages only through the inherited `WearableListenerService` callback.
- **R2:** Existing path, size, strict UTF-8, empty-content, notification, and activity boundaries must remain unchanged.
- **R3:** The maintained baseline must reject restoration of client construction, explicit message-listener registration, explicit removal, or client disconnection in `ListenerService`.
- **R4:** Verification must remain SDK-independent and record unavailable Android/Wear runtime coverage truthfully.

## Key Technical Decisions

- **Framework-managed delivery only:** Keep the manifest-bound `WearableListenerService` callback and remove the parallel `GoogleApiClient` listener because the service already owns background event delivery.
- **Static lifecycle contract:** Extend the existing baseline checker instead of introducing an Android test dependency that the retired toolchain cannot resolve on this host.
- **No adjacent behavior change:** Do not alter sender connection handling, notification content, payload validation, manifest filters, or dependency versions.

## Implementation Units

### U1: Remove redundant listener lifecycle

**Files:**
- `Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/ListenerService.java`

Remove the client field, `onCreate` connection and registration, and `onDestroy` listener removal and disconnection. Preserve `onMessageReceived` and its validation/notification ordering.

### U2: Lock the framework-managed contract

**Files:**
- `scripts/check-baseline.sh`

Add mutation-sensitive checks that require the `WearableListenerService` inheritance and callback while rejecting redundant client/listener lifecycle fragments. Keep the existing payload and notification contracts intact.

### U3: Record completion evidence

**Files:**
- `docs/plans/2026-06-14-wear-listener-lifecycle.md`
- `CHANGES.md`
- `SECURITY.md`
- `VISION.md`
- `AGENTS.md`

Document the lifecycle boundary, actual bounded verification, unavailable platform coverage, and completed status using the repository's existing maintenance conventions.

## Validation

- Run `make check`, `make lint`, `make test`, and `make build` from the repository root.
- Run `make check` through an absolute Makefile path from outside the checkout.
- Apply isolated hostile mutations that restore client construction, listener registration, listener removal, and client disconnection; require each mutation to fail the baseline.
- Confirm the exact intended diff passes whitespace, conflict-marker, generated-artifact, and changed-line credential scans.

## Verification Results

- `make check`, `make lint`, `make test`, and `make build` passed the maintained static baseline; xcodebuild was unavailable on this Linux host.
- The absolute-Makefile external baseline passed from `/tmp`.
- All four isolated hostile mutations were rejected when they restored a `GoogleApiClient` import, parallel message registration, removed framework inheritance, or added explicit disconnect cleanup.
- The exact intended diff, whitespace, conflict-marker, generated-artifact, and changed-line credential scans passed.
- No Twitter or Fabric credentials, signing material, Android SDK, emulator, simulator, or physical device were used; no paired-device runtime behavior is claimed.

## Risks

- The historical Android/Wear toolchain and paired-device runtime are unavailable, so delivery behavior cannot be exercised on a device here.
- Removing the parallel listener assumes the documented `WearableListenerService` and existing manifest binding remain the intended background delivery mechanism; the static contract protects both.
