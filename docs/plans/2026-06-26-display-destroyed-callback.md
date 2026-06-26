# DisplayTweets Destroyed Callback Implementation Plan

status: completed

## Goal

Prevent delayed DisplayTweets load callbacks from updating UI after their
`MainActivity` owner is destroyed.

## Tasks

1. Require the design and implementation records from the baseline.
2. Add a failing callback/onDestroy ordering contract.
3. Add the volatile lifecycle signal and callback guards.
4. Synchronize maintainer guidance and `CHANGES.md`.
5. Run focused hostile mutations, `make check`, hosted checks, and exact-head
   review before merge.

## Verification Evidence

- RED: `scripts/check-baseline.sh` failed on the missing volatile destruction
  signal before source changes.
- GREEN: the baseline passed after callback-entry, per-item, and `onDestroy`
  ordering guards were added.
- Initial documentation contracts missed wrapped lifecycle wording and imposed
  an arbitrary phrase-distance cap; matching now normalizes whitespace without
  that cap.
- `make check`, `make lint`, `make test`, `make build`, and external-directory
  Make invocation passed; Swift and Xcode checks skipped truthfully because the
  tools are unavailable.
- The first hostile harness assumed identical indentation and stopped before
  mutation; corrected fixtures rejected callback-entry and per-item guard
  removal with the intended lifecycle diagnostic.
- Maintained shell/Python syntax and `git diff --check` passed.
- Hosted checks and exact-head review remain the publication gate.
