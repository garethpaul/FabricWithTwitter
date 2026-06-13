---
title: Cross-Platform Sample Verification Matrix
type: verification
status: completed
date: 2026-06-13
---

# Cross-Platform Sample Verification Matrix

## Summary

Define per-sample build and runtime verification for the legacy Android,
Wear, iOS, and watchOS projects without treating static checks or hosted Xcode
project parsing as proof that retired Fabric/TwitterKit integrations still run.

---

## Problem Frame

The repository currently has one broad verification paragraph for several
independent historical applications. Their toolchains, credentials, devices,
data flows, and safe runtime expectations differ substantially. Reviewers need
a matrix that records exactly which sample built and ran, which external paths
were exercised, and which steps remain blocked by obsolete dependencies.

---

## Requirements

- R1. Identify every maintained sample surface and its required historical
  Android/Gradle or Xcode/watchOS toolchain, device/emulator, and local signing.
- R2. Keep Fabric/Twitter credentials, Android keystores, Apple signing data,
  `.env`, `.xcconfig`, account data, tweet content, Wear paths/payloads, and raw
  errors out of git and evidence.
- R3. Verify Android DisplayTweets success/failure rendering with the checked-in
  fixed tweet IDs while retaining generic logs and empty manifest placeholders.
- R4. Verify Wear mobile login, null-safe controls/containers, tweet display,
  UTF-8 message sending, blank-text rejection, 1024-byte rejection, connected
  node delivery, and generic failures.
- R5. Verify the Wear listener accepts only the expected system listener path,
  rejects wrong/blank/oversized payloads, decodes UTF-8, posts an internal
  notification, and displays trimmed non-empty text without exposing raw data.
- R6. Verify iOS TableViewTweets guest load, in-flight reset, typed tweet rows,
  generic failures, refresh behavior, and current unsafe permalink limitation
  without claiming navigation is hardened.
- R7. Classify iOS WatchSample as a placeholder Crashlytics demonstration;
  verify project/scheme behavior only and prohibit routine execution of its
  deliberate force-crash action.
- R8. Record commit, toolchain/device versions, sample, locally owned credential
  source, test-content provenance, per-step pass/fail/blocked result, and
  redacted evidence. Do not mark unavailable legacy services as passed.
- R9. State that this Linux session does not build, sign, install, authenticate,
  send Wear messages, render tweets, or execute watch behavior.
- R10. Enforce matrix sections, key safety assertions, completed local evidence,
  and roadmap updates in the maintenance gate.

---

## Key Technical Decisions

- K1. Keep the pass documentation-and-contract only; preserve all source,
  manifests, build files, vendored dependencies, projects, workflows, and keys.
- K2. Separate build evidence from runtime/external-service evidence per sample.
- K3. Use section-scoped normalized Markdown checks to prevent unrelated prose
  from masking weakened sample requirements.
- K4. Explicitly record known limitations, including retired services, fixed
  public tweet IDs, unsafe iOS permalink navigation, and destructive watch code.

---

## Scope Boundaries

### In Scope

- One cross-platform manual verification matrix and evidence template.
- Contracts for Android display, Wear sender/receiver, iOS table, watch
  placeholder, privacy/failure, cleanup, and evidence limitations.
- README, agent, security, roadmap, and change guidance updates.

### Deferred to Follow-Up Work

- Replacing dynamic or obsolete Android dependencies with reproducible versions.
- Replacing Fabric/TwitterKit, UIWebView, legacy Gradle, Swift, and WatchKit APIs.
- Hardening iOS tweet permalink navigation in this repository.
- Executable integration tests after dependency isolation or modernization.

### Non-Goals

- Building, signing, installing, authenticating, calling Twitter/Fabric,
  messaging Wear, posting notifications, or intentionally crashing a watch app.
- Adding credentials, account/tweet fixtures, keystores, signing material,
  captured payloads, screenshots, logs, or generated build output to git.

---

## Implementation Units

### U1. Cross-Platform Verification Matrix

**Goal:** Define precise prerequisites and outcomes for every sample surface.

**Requirements:** R1-R9

**Dependencies:** None

**Files:** `docs/manual-sample-verification.md`

**Approach:** Organize global evidence boundaries and per-sample sections for
Android DisplayTweets, Wear mobile, Wear listener/notification, iOS TableView,
iOS WatchSample, failure/privacy, cleanup, and evidence recording.

**Patterns to follow:** `docs/plans/2026-06-12-wear-notification-activity-boundary.md`,
`docs/plans/2026-06-13-wear-message-payload-limit.md`

**Test scenarios:**

- Each sample can be marked independently pass, fail, or blocked.
- Missing retired dependencies block runtime claims without weakening static
  source/project evidence.
- Android/Wear paths preserve placeholder keys, generic logs, UTF-8, 1024-byte,
  listener export, internal activity, and non-empty display boundaries.
- iOS TableView records typed-load and in-flight behavior while identifying
  unvalidated permalink navigation as a remaining risk.
- WatchSample verification never executes the force-crash action.

**Verification:** Every required assertion appears in its intended matrix
section, and the document clearly remains unexecuted by this Linux session.

### U2. Section-Scoped Maintenance Contract

**Goal:** Make matrix and evidence drift fail `make check`.

**Requirements:** R10

**Dependencies:** U1

**Files:** `scripts/check-baseline.sh`,
`docs/plans/2026-06-13-cross-platform-sample-verification.md`

**Approach:** Require the matrix file, parse sections with normalized whitespace,
and enforce current project guidance plus completed-plan evidence. Preserve all
existing source, manifest, CI, Wear payload, and hosted-evidence contracts.

**Execution note:** Validate in an isolated copy before marking the real plan
completed, then mutate each high-risk assertion independently.

**Test scenarios:**

- Removing any sample, credential/privacy, UTF-8/size, internal-activity,
  typed-load, unsafe-permalink, no-force-crash, cleanup, evidence-limit,
  roadmap, or plan-status assertion fails the gate.

**Verification:** All maintained targets pass and each hostile mutation fails
for the intended contract.

### U3. Project Guidance

**Goal:** Make the matrix discoverable and keep runtime claims truthful.

**Requirements:** R8-R10

**Dependencies:** U1, U2

**Files:** `README.md`, `AGENTS.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`

**Approach:** Link the matrix, describe evidence classes and known limitations,
and replace completed build/manual-note roadmap items with modernization and
executable-test follow-ups.

**Test expectation:** No source or runtime behavior change; documentation
contracts and exact-path review provide coverage.

**Verification:** Guidance consistently separates static, hosted project-parse,
build/install, and external-service runtime evidence.

---

## Risks And Dependencies

- Historical Gradle repositories, Android SDKs, Xcode/Swift versions, Fabric,
  TwitterKit, Google Play Services, or Twitter APIs may be unavailable.
- Fixed public tweet IDs may be deleted or inaccessible and may expose
  third-party public content during testing.
- Wear hardware/emulator pairing and GoogleApiClient behavior depend on obsolete
  platform components.
- The WatchSample deliberate crash path is destructive and unsuitable for
  routine verification.

---

## Verification Plan

- Run all maintained Make targets on Linux with explicit Xcode skip behavior.
- Parse Android manifests and Apple plists; run shell syntax and diff checks.
- Apply isolated hostile mutations across every sample and evidence boundary.
- Inspect exact intended paths, unchanged source/build/manifest/project/
  framework/workflow files, credential-like additions, signing artifacts, and
  generated artifacts.
- Push normally, open a stacked PR on the green Wear payload branch, and take one
  bounded exact-head configured-event/CodeQL snapshot without polling.

---

## Verification

- An isolated full `make check` passed with the completed-plan contract enabled;
  local `xcodebuild` was explicitly unavailable on Linux.
- Seventeen isolated hostile mutations were rejected for weakened evidence,
  fixed-public-content, DisplayTweets privacy, Wear null-safety/UTF-8/size,
  listener export/internal activity/wrong path, iOS typed-load/unsafe permalink,
  Android local credential injection, iOS login-success in-flight state,
  no-force-crash, credential rotation, roadmap, and plan-status requirements.
- The verification matrix remains unexecuted. No Android/iOS/watch build,
  signing/install, Fabric/Twitter login/load, Wear transport/notification, or
  deliberate crash action was performed.
- Plan-based review found and fixed the iOS in-flight reset timing and the need
  for explicitly uncommitted Android credential fixture injection; no actionable
  review findings remain.
- Shell syntax, all four maintained Make targets, three Android manifest parses,
  two Apple plist parses, `git diff --check`, exact eight-path review, unchanged
  source/build/manifest/project/framework/workflow/Makefile/ignore inspection,
  credential/signing inspection, and generated-artifact inspection passed.
- The exact pushed head still requires one bounded exact-head configured-event/CodeQL snapshot;
  hosted project listing will remain separate from sample runtime evidence.

## Work Completed

- Added independent Android DisplayTweets, Wear mobile, Wear listener/
  notification, iOS TableView, and iOS WatchSample verification paths.
- Recorded fixed public-content, unsafe iOS permalink, destructive WatchSample,
  privacy, cleanup, blocker, and four-class evidence boundaries.
- Added section-scoped maintenance contracts and updated project guidance without
  modifying source, build files, manifests, projects, workflows, or credentials.
