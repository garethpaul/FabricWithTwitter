# CI Baseline

status: completed

## Context

The repository had a local static `make check` baseline for the legacy
Android, Wear, and iOS Fabric/Twitter samples, but no hosted workflow ran it
for pushes and pull requests.

## Changes

- Added a least-privilege GitHub Actions workflow that runs `make check` on a
  fixed macOS image so both Xcode projects are parsed in hosted validation.
- Pinned checkout by commit, disabled persisted checkout credentials, bounded
  the job with a timeout, and enabled cancellation of superseded runs.
- Added focused baseline checks for unrestricted pull requests, the master
  push trigger, read-only permissions, immutable actions, and the exact Make
  verification command.
- Extended the documentation so the hosted CI path stays visible.

## Verification

- `make check`
- `git diff --check`
- Hosted `macos-15` GitHub Actions run
