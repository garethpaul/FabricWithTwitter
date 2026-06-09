# Android Backup Opt Out

status: completed

## Context

The Android display, mobile, and wear sample manifests opted into platform
app-data backup by default. These legacy Twitter/Fabric samples can hold
session-adjacent app state, so the checked-in manifests should fail closed
rather than allowing backup unless a maintainer deliberately changes that
boundary.

## Objectives

- Set all Android sample manifests to `android:allowBackup="false"`.
- Keep Crashlytics placeholder-key behavior unchanged.
- Extend the static baseline checker so backup opt-in cannot return silently.
- Document the Android privacy boundary in README, SECURITY, VISION, and
  CHANGES.

## Work Completed

- Disabled backup in the DisplayTweets app manifest.
- Disabled backup in the WearExample mobile app manifest.
- Disabled backup in the WearExample wear app manifest.
- Extended `scripts/check-baseline.sh` to reject `allowBackup="true"` and
  require explicit opt-out in all three manifests.
- Updated top-level maintenance and security notes.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
