---
title: Legacy Android Dependency Pins
type: supply-chain
status: planned
date: 2026-06-14
---

# Legacy Android Dependency Pins

## Summary

Remove every dynamic `+` dependency selector from the Android samples while
preserving the Gradle 2.1 / Android plugin 0.13.2 toolchain. Pin versions already
resolved by this checkout and align both Wear modules on the same wearable-only
Google Play Services artifact.

## Prioritized Engineering Tasks

1. Pin `io.fabric.tools:gradle` to the locally resolved `1.14.4` in all three
   Android application modules.
2. Pin Wear support-v4 to `20.0.0`, matching its compile SDK and local artifact.
3. Replace the phone module's full `play-services:+` dependency with
   `play-services-wearable:6.1.71`, matching the paired Wear module and actual API
   usage.
4. Add a repository-wide static contract rejecting dynamic dependency selectors.

## Requirements

- R1. No Android Gradle dependency or buildscript classpath may contain `+`,
  `latest`, a version range, or another dynamic selector.
- R2. Both Wear modules must use `play-services-wearable:6.1.71` rather than the
  full Play Services bundle.
- R3. Existing TwitterKit, Tweet UI, wearable support, Gradle wrapper, Android
  plugin, SDK, and build-tools versions must remain unchanged.
- R4. Static checks and project guidance must record the exact pinned versions
  and explain that this is reproducibility hardening, not dependency currency.
- R5. Hosted verification must remain offline and credential-free.

## Non-Goals

- Reviving retired Fabric repositories or upgrading Gradle, Android plugins,
  SDK targets, TwitterKit, or Google Play Services APIs.
- Claiming that pinned legacy dependencies are secure or currently supported.
- Running Fabric uploads, Twitter login, Wear transport, or signed app builds.

## Planned Verification

- Run focused dynamic-selector and exact-version checks.
- Run `make check` from the checkout and `/tmp`.
- Reject isolated hostile mutations for each pin, dynamic selectors,
  documentation, and completed-plan evidence.
- Inspect exact intended paths, wrapper/project preservation, artifacts,
  conflict markers, whitespace, and changed-line credential patterns.
- Take one bounded exact-head hosted check and code-scanning snapshot after push;
  do not poll pending jobs.
