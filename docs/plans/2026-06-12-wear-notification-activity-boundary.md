# Wear Notification Activity Boundary

## Status: Completed

## Goal

Keep tweet text display internal to the Wear notification flow so unrelated
applications cannot launch `NotificationActivity` with attacker-controlled
extras.

## Prioritized Engineering Work

1. **Make the notification display activity internal-only (this change).**
   Remove its launcher intent filter and explicitly set `android:exported` to
   false while preserving the explicit notification `PendingIntent` path.
2. **Harden legacy PendingIntent mutability (follow-up).** Address immutable
   flags as part of an Android SDK migration where the required constants and
   target-level behavior can be compiled and tested.
3. **Constrain the wearable listener component (follow-up).** Document and test
   the Google Play Services binding/export contract before changing the retired
   listener-service manifest behavior.
4. **Modernize or archive retired Fabric/TwitterKit samples (follow-up).** Make
   a deliberate product decision rather than implying current SDK support.

## Requirements

- R1. `NotificationActivity` must declare `android:exported="false"`.
- R2. The activity must not declare `MAIN`, `LAUNCHER`, or any other intent
  filter.
- R3. `ListenerService` must continue creating an explicit intent targeting
  `NotificationActivity.class` and passing the shared `TWEET_KEY` extra.
- R4. Existing null, trim, blank-text, path, UTF-8, payload, and display-target
  guards must remain unchanged.
- R5. The mobile and phone launcher activities must remain available; this
  change is limited to the Wear notification detail target.
- R6. The static baseline and security documentation must reject an exported or
  implicitly addressable notification activity.

## Verification

- `make check`.
- XML parsing of all Android manifests.
- Hosted macOS baseline and iOS Xcode project listing through GitHub Actions.
- `git diff --check`.
- Mutation check: restoring `android:exported="true"` must fail the manifest
  contract.
- Mutation check: restoring the notification activity launcher intent filter
  must fail the manifest contract.

## Compatibility Boundary

The Android projects use an obsolete Gradle/SDK/Fabric stack that is not built
by current CI. This focused manifest hardening is verified structurally; a full
SDK migration remains separate work.

## Work Completed

- Set the Wear `NotificationActivity` component to
  `android:exported="false"`.
- Removed its `MAIN`/`LAUNCHER` intent filter so it is not implicitly
  addressable or shown as a standalone launcher target.
- Preserved the explicit `Intent(this, NotificationActivity.class)` and shared
  `TWEET_KEY` extra used by the notification `PendingIntent`.
- Added XML parsing that locates the exact component and rejects export or any
  nested intent filter.
- Updated project, security, roadmap, and changelog documentation without
  changing existing tweet sanitization or Wear message handling.

## Verification Completed

- `make check` passes locally; Xcode listing is skipped because this Linux host
  does not provide `xcodebuild`.
- `git diff --check` passes.
- Restoring `android:exported="true"` makes `make check` fail.
- Adding an intent filter to `NotificationActivity` makes `make check` fail.
- GitHub Actions push run `27392063786` passed on `macos-15`.
- GitHub Actions pull-request run `27392064680` passed on `macos-15`; both runs
  completed both iOS Xcode project listings.
