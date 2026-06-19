---
title: iOS Twitter Permalink Host Boundary
type: security
status: completed
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

- The focused checker accepted exact canonical Twitter/X hosts, including
  mixed-case scheme/host input, and rejected nil, non-HTTPS, hostless,
  credential-bearing, explicit-port, unrelated-host, subdomain, and suffix-
  lookalike URLs.
- Thirteen isolated hostile mutations were rejected across missing and expanded
  host allowlists, suffix matching, X-host coverage, explicit-port and helper
  enforcement, pre-web-view ordering, and all six maintained guidance files.
- Repository-root and external-directory `make check` passed the portable
  cross-platform baseline; local Android, Xcode, simulator, physical-device,
  Fabric, and live Twitter behavior were not executed on Linux.
- Exact intended-path, generated-artifact, Android/Xcode-project preservation,
  whitespace, conflict-marker, and changed-line credential audits passed before
  delivery.
