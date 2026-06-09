---
title: Wear message notification guards
date: 2026-06-08
status: completed
execution: code
---

## Context

The Wear sample forwards a tweet from the mobile app to the watch and displays
it in a notification. The receiver accepted every message path, assumed a
payload was present, used a string literal extra key, and kept its GoogleApiClient
listener registered for the service lifetime.

## Requirements

- R1. The mobile sender must skip sends when the path, tweet text, or
  GoogleApiClient is missing, and wait for connection on a background thread
  before sending.
- R2. The Wear listener must ignore missing message events, unexpected paths,
  and empty payloads before building a notification.
- R3. The Wear listener must use the notification activity's shared tweet extra
  key.
- R4. The Wear listener must remove its message listener and disconnect the
  client when destroyed.
- R5. The notification activity must ignore missing or empty tweet extras.
- R6. The WearExample Gradle build must include Google Maven for legacy Wear
  support and Play Services artifact resolution.
- R7. The static baseline must guard these message handling checks.

## Verification

- `make check`
- `scripts/check-baseline.sh`
- `git diff --check`

## Toolchain Limitations

- `ANDROID_HOME=/home/gjones/android-sdk ./gradlew :wear:compileDebugJava :mobile:compileDebugJava --no-daemon`
  was attempted in `Android/WearExample`, but the host cannot resolve the
  discontinued `com.google.android.support:wearable:1.0.0` artifact from the
  configured local SDK, JCenter, Fabric Maven, or Google Maven.
