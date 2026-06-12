# Wear Listener Service Export Contract

status: completed

## Goal

Remove the implicit Android service export flagged by CodeQL without breaking
background Wear data-layer message delivery through Google Play Services.

## Context

`ListenerService` extends `WearableListenerService` and declares the historical
`com.google.android.gms.wearable.BIND_LISTENER` action. An intent filter makes
the service implicitly exported on legacy Android targets, while current
Android manifests require that boundary to be explicit. Android's Wear data
layer guidance declares manifest-registered listener services with
`android:exported="true"` so the system can bind and deliver background events.

## Prioritized Engineering Work

1. **Make the required export explicit.** Set `ListenerService` to
   `android:exported="true"` while retaining the one Wear binding action.
2. **Enforce the complete manifest contract.** Parse the manifest in the
   offline baseline and reject missing or false export state, renamed service,
   missing or additional actions, and extra intent filters.
3. **Document the boundary.** Explain why this one service remains exported
   while `NotificationActivity` remains internal-only.
4. **Verify locally and in hosted analysis.** Run all Make aliases, focused
   hostile mutations, the configured pull-request workflow, and CodeQL. The
   workflow intentionally limits push execution to `master`, so a feature-head
   push run is unavailable before an authorized merge.

## Requirements

- R1. `.ListenerService` must remain declared exactly once.
- R2. The service must explicitly set `android:exported="true"` because Google
  Play Services binds it for background Wear events.
- R3. The service must expose exactly one intent filter containing exactly the
  `com.google.android.gms.wearable.BIND_LISTENER` action and no categories or
  data selectors.
- R4. `.NotificationActivity` must remain non-exported and filter-free.
- R5. The change must not add credentials, broaden Android backup, remove Wear
  message guards, or claim a functional legacy Android build on this host.

## Verification

- `make check`, `make lint`, `make test`, and `make build`.
- `sh -n scripts/check-baseline.sh` and `git diff --check`.
- Focused mutations for a missing export, `exported="false"`, a missing action,
  an additional action, and an additional intent filter.
- GitHub Actions pull-request check at the implementation head.
- CodeQL analysis with no implicit-export alert on the pull-request ref. The
  existing default-branch alert remains open until the fix is merged.

## Boundaries

- Do not make the listener private; that would prevent system binding.
- Do not add a launcher or other public filter to `NotificationActivity`.
- Do not modernize the retired Fabric/TwitterKit or Wear API stack in this
  narrowly scoped security contract.

## Work Completed

- Declared `.ListenerService` with explicit `android:exported="true"` while
  retaining the exact Wear binding action needed for background delivery.
- Extended the XML baseline to require one listener declaration, one filter,
  the exact export value and action, and no categories or data selectors.
- Documented the intentional system-binding boundary separately from the
  internal-only notification activity.

## Verification Completed

- `make check`, `make lint`, `make test`, and `make build` passed locally; the
  host truthfully skipped Xcode project listing because Xcode is unavailable.
- `sh -n scripts/check-baseline.sh` and `git diff --check` passed.
- Five focused manifest mutations were rejected: missing export, false export,
  missing binding action, an extra action, and an additional intent filter.
- Pull-request run `27408397355` passed the macOS static baseline and both Xcode
  project-listing checks at implementation commit
  `f2eadffa5cd107bbd74bf45c9032cf8ad2116d43`.
- CodeQL run `27408395236` passed Actions and Java/Kotlin analysis at the same
  commit, and `refs/pull/1/head` had zero open code-scanning alerts.
- Default-branch alert #1 remains open against `master` commit
  `561a54ca56f5283f278be9cf40cb096b14f22623` until an authorized merge. No
  feature-branch push run exists because the workflow's push trigger is
  intentionally limited to `master`.
