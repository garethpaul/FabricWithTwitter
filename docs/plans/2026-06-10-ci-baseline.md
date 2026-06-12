# CI Baseline

status: completed

## Context

The repository had a local static `make check` baseline for the legacy
Android, Wear, and iOS Fabric/Twitter samples, but no hosted workflow ran it
for pushes and pull requests.

## Changes

- Added a GitHub Actions workflow that runs `make check`.
- Extended the baseline script and documentation so the hosted CI path stays
  visible and covered by local verification.

## Verification

- `make check`
