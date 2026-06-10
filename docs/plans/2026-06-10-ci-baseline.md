# CI Baseline

status: completed

## Context

The repository had a local static `make check` baseline for the legacy
Android, Wear, and iOS Fabric/Twitter samples, but no hosted workflow ran it
for pushes and pull requests.

## Changes

- Added a least-privilege GitHub Actions workflow that runs `make check` on a
  fixed macOS image so both Xcode projects are parsed in hosted validation.
- Pinned the checkout action by commit, bounded the job with a timeout, and
  enabled cancellation of superseded runs.
- Extended the baseline script and documentation so the hosted CI path stays
  visible and covered by local verification.

## Verification

- `make check`
- Hosted `macos-15` GitHub Actions run
