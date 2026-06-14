## Fabric With Twitter Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

Fabric With Twitter is a simple sample for integrating Fabric with Twitter.

The repository is useful as a historical TwitterKit/Fabric integration example,
with Android sample projects and setup notes in [`README.md`](README.md).

The goal is to keep the sample understandable while making credential handling
and legacy SDK status explicit.

The current focus is:

Priority:

- Preserve the Twitter integration tutorial structure
- Keep Android sample projects and Fabric setup recognizable
- Avoid committing Twitter keys, Fabric API keys, tokens, or signing material
- Keep legacy dependency assumptions visible
- Keep GitHub Actions aligned with the local `make check` baseline

Current baseline:

- Make verification resolves repository paths independently of the caller's
  working directory.
- `scripts/check-baseline.sh` verifies that iOS Fabric run scripts read
  `FABRIC_API_KEY` and `FABRIC_BUILD_SECRET` from the local environment instead
  of committed identifiers.
- Android `com.crashlytics.ApiKey` manifest values remain empty placeholders in
  source control.
- Android display, mobile, and wear samples opt out of platform app-data backup
  by default.
- Android and iOS display samples use generic Twitter diagnostics instead of
  logging raw tweet objects or raw errors.
- The iOS TableView sample resets its in-flight tweet-load flag on guest-login
  failure and tweet-load completion.
- The iOS TableView sample type-checks loaded TwitterKit objects before
  replacing visible rows.
- The Android Wear mobile sample guards Twitter login button setup and
  activity-result forwarding when legacy layouts drift.
- The Android Wear mobile sample verifies that its tweet display container
  exists before adding a TwitterKit `TweetView`.
- Wear tweet loading skips missing, empty, or whitespace-only tweet text before
  sending messages to the watch or displaying watch notifications.
- Wear tweet payloads are bounded to 1024 UTF-8 bytes before send and decode.
- Wear listener decoding rejects malformed or unmappable UTF-8 before
  notification construction.
- Wear notification display verifies that its text view target exists before
  setting tweet text.
- Wear notification PendingIntents refresh the latest validated tweet extra.
- The Wear notification detail activity is internal-only and has no launcher
  intent filter; explicit app notifications remain its only entry path.
- The Wear listener service declares its required system-binding export
  explicitly and limits its filter to the single Wear binding action.
- The Wear listener service uses only framework-managed background delivery and
  does not register a parallel message listener.
- Wear tweet messages are encoded and decoded with explicit UTF-8 instead of
  platform default charsets.
- Wear listener diagnostics do not include raw incoming message paths.
- `make lint`, `make test`, and `make build` run the static baseline while
  these legacy samples have no narrower installed gates here.
- Local `.env`, `.xcconfig`, keystore, and Fabric-generated credential files are
  ignored.
- Xcode project listing is attempted when `xcodebuild` is installed; otherwise
  static checks remain the minimum verification path.
- GitHub Actions runs the local `make check` baseline on macOS for pushes and
  pull requests, including both Xcode project-listing checks.
- Hosted checkout credentials are not persisted and actions remain pinned to
  immutable revisions.
- A per-sample verification matrix now separates Android DisplayTweets, Wear
  mobile/listener, iOS TableView, and WatchSample build/runtime evidence,
  privacy constraints, known unsafe/destructive paths, cleanup, and redaction
  without claiming that the matrix has been executed.

Next priorities:

- Preserve the Android legacy dependency pins while planning a separately
  verified replacement for the retired toolchain
- Document modern alternatives to Fabric/TwitterKit
- Add executable login, display, Wear transport, and lifecycle tests after the
  retired dependencies can be isolated or replaced

Contribution rules:

- One PR = one focused auth, build, sample, or documentation change.
- Do not mix SDK migration with UI or behavior changes unless required.
- Keep credential placeholders empty in committed source.
- Preserve Android backup opt-out when changing sample manifests.
- Preserve the exact Wear listener export and single binding-action contract
  when changing the wearable manifest.
- Preserve framework-managed Wear listener delivery; do not add a second
  `GoogleApiClient` listener lifecycle to the service.
- Preserve Wear mobile login button lifecycle guards when changing the legacy
  Twitter login flow.
- Preserve Wear mobile tweet display container guards when changing legacy
  tweet UI layouts.
- Verify Twitter login/display behavior with local credentials when changing it.
- Keep `.github/workflows/check.yml` in sync with the local static baseline.

## Security

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

Twitter credentials and user sessions are sensitive. Real keys and tokens must
remain in local configuration or platform tooling and out of git.

Do not add logging that exposes tokens, account IDs, or private timeline data.

## What We Will Not Merge (For Now)

- Hardcoded Twitter/Fabric credentials
- Silent account actions
- Broad dependency migrations without verification notes
- Generated signing files or local machine paths

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
