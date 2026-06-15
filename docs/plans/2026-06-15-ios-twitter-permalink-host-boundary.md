---
title: iOS Twitter Permalink Host Boundary
type: security
status: pending
date: 2026-06-15
execution: code
---

# iOS Twitter Permalink Host Boundary

## Summary

Restrict the iOS TableView sample's selected-tweet navigation to exact canonical
Twitter and X hosts. The existing boundary rejects non-HTTPS, hostless, and
credential-bearing URLs but still permits unrelated HTTPS domains and explicit
ports from malformed or compromised tweet models.

## Prioritized Engineering Tasks

1. Add an exact, case-insensitive canonical-host helper to the legacy Swift
   navigation boundary.
2. Reject explicit ports before constructing `NSURLRequest` or `UIWebView`.
3. Extend the existing focused checker with a complete allowlist and URL matrix.
4. Synchronize security, maintenance, and manual sample guidance.

## Requirements

- R1. Accept only HTTPS URLs on `twitter.com`, `www.twitter.com`, `x.com`, or
  `www.x.com`.
- R2. Reject user information, explicit ports, unrelated hosts, subdomains,
  prefixes, and suffix lookalikes.
- R3. Match hosts case-insensitively by exact equality.
- R4. Complete validation before web-request construction and navigation.
- R5. Preserve existing Twitter loading, main-queue publication, table
  rendering, Android, Wear, and watch behavior.
- R6. The maintained checker must reject allowlist expansion or weakening and
  incomplete plan or guidance evidence.

## Non-Goals

- Replacing `UIWebView`, Fabric, TwitterKit, or vendored frameworks.
- Modernizing Android Gradle or Xcode project settings.
- Changing tweet loading, rendering, Wear transport, or notification behavior.
- Claiming Xcode, simulator, signed-device, Fabric, or live Twitter execution
  from Linux validation.

## Verification

- Pending focused host and URL boundary checks.
- Pending hostile mutations for exact matching, allowlist expansion, explicit
  ports, validation ordering, guidance, and completed-plan evidence.
- Pending repository and external-directory `make check`.
- Pending exact intended-path, artifact, project-file, whitespace,
  conflict-marker, and changed-line credential audits.
