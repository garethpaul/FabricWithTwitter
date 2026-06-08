---
title: Fabric With Twitter security baseline
date: 2026-06-08
status: completed
execution: code
---

## Context

This repository is a legacy Fabric/TwitterKit sample collection with Android,
iOS, and watchOS examples. The iOS Xcode projects contained Fabric run scripts
with committed identifiers, while Android manifests correctly used empty
Crashlytics key placeholders.

## Goals

- Remove committed Fabric run-script identifiers from iOS project files.
- Preserve optional Fabric upload behavior through local environment variables.
- Keep Android Crashlytics API keys as placeholders in source.
- Ignore local credential, signing, and per-machine build configuration files.
- Add static verification that works without Android SDK, Xcode, or Twitter
  credentials.

## Scope Boundaries

- Do not migrate the deprecated Fabric/TwitterKit SDKs.
- Do not change app behavior, login flows, or tweet display code.
- Do not require Android SDK, Xcode, simulators, or real credentials for the
  default verification command.

## Implementation

- Replaced iOS Fabric run-script arguments with `FABRIC_API_KEY` and
  `FABRIC_BUILD_SECRET`.
- Added `FABRIC_RUN_SCRIPT` as an optional local override for nonstandard Fabric
  script locations.
- Expanded `.gitignore` for local env, `.xcconfig`, and signing files.
- Added `scripts/check-baseline.sh`, `make check`, and docs updates.

## Verification

- `make check`
- `git diff --check`
- `xcodebuild -list` for both iOS projects when Xcode is installed
