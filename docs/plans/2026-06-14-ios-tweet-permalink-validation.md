---
title: iOS Tweet Permalink Validation
type: security
status: completed
date: 2026-06-14
---

# iOS Tweet Permalink Validation

## Summary

Validate selected tweet permalinks before the legacy iOS table sample creates a
web request. Only credential-free HTTPS URLs with a non-empty host may navigate.

## Prioritized Engineering Tasks

1. Add a pure permalink validator at the navigation boundary.
2. Use only the validated URL for request construction and navigation.
3. Reject invalid URLs with a generic diagnostic and no URL details.
4. Add a source-order and URL-matrix checker and update the manual runbook.

## Requirements

- R1. HTTP, hostless, credential-bearing, nil, and non-web URLs must fail closed.
- R2. Validation must occur before `NSURLRequest` and navigation.
- R3. Rejected URLs must not be logged or loaded.
- R4. Existing tweet loading, rendering, and row-height behavior must remain
  unchanged.
- R5. Static contracts must prove both accepted and rejected URL boundaries.

## Non-Goals

- Replacing `UIWebView`, Fabric, or TwitterKit in this legacy sample.
- Restricting navigation to a Twitter-owned hostname.
- Claiming simulator, signed-device, or live Twitter execution from Linux.

## Verification

- The focused URL matrix accepted credential-free HTTPS links with a host and
  rejected nil, HTTP, hostless, credential-bearing, and JavaScript URLs.
- Seven hostile mutations were rejected across scheme, user, password, host,
  callback use, request ordering, and completed-plan evidence.
- `make check`, `make lint`, `make test`, and `make build` passed the portable
  maintenance baseline from the repository root and `make check` passed through
  the absolute Makefile path from an external working directory.
- Local Xcode compilation, simulator execution, signed-device testing, and live
  Twitter navigation were not run because this Linux host lacks the historical
  Apple toolchain, signing identity, and service credentials.
- Exact intended-path, generated-artifact, whitespace, conflict-marker,
  project-file preservation, and changed-line credential-pattern audits passed.
