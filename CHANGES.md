# Changes

## 2026-06-26 06:21 PDT - P1 - Stop destroyed DisplayTweets callbacks

### Summary

Prevented delayed Android DisplayTweets success callbacks from constructing or
adding activity-backed tweet views after `MainActivity` destruction.

### Work completed

- Added an activity-owned volatile destruction signal.
- Rejected delayed callbacks before tweet iteration and rechecked before every
  `CompactTweetView` construction/addition.
- Published destruction before superclass teardown.
- Added fail-closed source ordering contracts, design/implementation records,
  synchronized maintainer guidance, and a manual runtime scenario.

### Threads

- Started: None — the retired callback API and lifecycle owner were local to one
  activity.
- Continued: None.
- Stopped: None.

### Files changed

- Android DisplayTweets `MainActivity.java` — adds destroyed-activity callback
  guards.
- `scripts/check-baseline.sh` — enforces signal, callback, per-item, and teardown
  ordering.
- `README.md`, `SECURITY.md`, `VISION.md`, `AGENTS.md`, and
  `docs/manual-sample-verification.md` — document the lifecycle boundary.
- `docs/plans/2026-06-26-display-destroyed-callback*.md` — record the decision
  and implementation evidence.

### Validation

- RED baseline — failed on the missing volatile destruction signal.
- GREEN baseline — passed after callback and teardown guards were added.
- Initial synchronized-doc runs — exposed line wrapping and an arbitrary phrase
  distance cap; the contract now normalizes whitespace without that cap.
- `make check`, `make lint`, `make test`, `make build`, and external-directory
  `make -f ... check` — passed the Java policy harness, 19 Python tests, and
  full baseline; unavailable Swift/Xcode checks skipped truthfully.
- Maintained shell/Python syntax and `git diff --check` — passed.
- The first hostile-mutation harness assumed identical nested indentation and
  stopped before testing; corrected fixtures then rejected both callback-entry
  and per-item guard removals with the intended diagnostic.
- Hosted checks and exact-head review remain pending.

### Bugs / findings

- P1 lifecycle correctness: a TwitterKit callback could update a detached
  activity UI after destruction, with no cancellation handle available in the
  retired sample API.

### Blockers

- Compatible historical TwitterKit/Android runtime execution remains a manual
  verification boundary.

### Next action

- Open the focused PR, run hosted gates and exact-head review, then merge only
  the reviewed green head.

## 2026-06-25 21:32 PDT - P1 - Stop Wear sends after destruction

### Summary

Closed the remaining Wear mobile lifecycle race so activity destruction during
node lookup or between node sends stops further use of the activity-owned
`GoogleApiClient`.

### Work completed

- Rechecked the volatile destruction signal after connected-node lookup.
- Serialized destruction publication with every node send initiation so a
  multi-node loop cannot start another send after `onDestroy` owns the client.
- Strengthened the source contract for both asynchronous handoffs and documented
  the focused lifecycle decision.

### Threads

- None; the focused fix was investigated, implemented, and reviewed directly.

### Files changed

- Wear mobile `MainActivity` - stop node iteration and message delivery after
  activity destruction.
- Baseline, plans, and maintainer guidance - preserve the new guard ordering.

### Validation

- RED: `./scripts/check-baseline.sh` rejected the missing post-lookup and
  pre-send guards.
- GREEN: the focused baseline passed after adding the post-lookup guard and
  atomic lifecycle-check/send boundary.
- `make check` passed the executable Wear policy, Python suites, and baseline;
  Swift and Xcode execution skipped because those tools are unavailable locally.
- Hostile removal of the post-lookup guard or per-send lifecycle boundary failed
  with the expected lifecycle-ordering diagnostic.
- Shell syntax and `git diff --check` passed.

### Bugs / findings

- P1: destruction after the post-connect check could still race node lookup or
  later loop iterations and allow a send on a disconnected activity-owned client.

### Blockers

- Retired TwitterKit/Wear runtime behavior remains a hosted or manual validation
  boundary.

### Next action

- Open a focused pull request, run exact-head review, and merge after hosted gates.

## 2026-06-25 - P1 - Wear activity callback ownership

### Summary

Prevented delayed TwitterKit callbacks from reconnecting the Wear
`GoogleApiClient` or updating UI after the owning mobile activity is destroyed.

### Work completed

- Added a volatile activity-destruction signal checked by login and tweet
  callbacks before asynchronous work and again before UI publication, plus
  before message payload dispatch.
- Checked the message worker both before and after `blockingConnect`; a client
  connected while destruction races the worker is disconnected before return.
- Published destruction before client disconnection and superclass teardown.
- Added mutation-sensitive baseline contracts and manual device verification.

### Validation

- Observed `make check` fail first on the missing destruction signal.
- The focused Wear policy harness, Python suites, and full local baseline pass;
  Swift execution and Xcode project listing remain hosted requirements here.
- Hostile removal of the tweet callback guard and post-connect destruction
  cleanup were both rejected by the baseline.
- Exact-diff review identified callback/UI interleavings after the first guard;
  second guards now protect both login and tweet UI publication.

### Bugs / findings

- P1: A tweet callback completing after `onDestroy` could start a worker that
  reconnected the activity-owned Wear client and then attempted dead-UI work.

### Next action

- Run hostile lifecycle mutations, hosted checks, and exact-head review before
  merge.

## 2026-06-25 - P2 - modern platform alternatives

### Summary

Documented modern alternatives to the retired Fabric, TwitterKit, and legacy
Wear capabilities without rewriting or making runtime claims about the
historical samples.

### Work completed

- Mapped Fabric crash reporting to Firebase Crashlytics, TwitterKit login and
  data access to X OAuth 2.0 PKCE and X API v2, and wearable transport to the
  current Wear OS Data Layer.
- Preserved the validated HTTPS permalink as the credential-free browser
  fallback and carried forward existing secret, logging, UTF-8, payload-size,
  and listener-lifecycle boundaries.
- Defined staged migration and validation gates so future provider changes can
  be reviewed independently against primary documentation.

### Threads

- None; the focused documentation change was completed directly.

### Files changed

- `docs/modern-platform-alternatives.md` - capability map, security boundaries,
  migration stages, validation gates, and official provider references.
- `scripts/check-baseline.sh` - documentation and roadmap synchronization
  contracts.
- Maintainer guidance and design/implementation plans - link and preserve the
  new migration-planning boundary.

### Validation

- Observed `make check` fail first because the required guide was absent.
- All four Make aliases and absolute-Makefile `make check` passed locally;
  Swift execution and Xcode project listing remain hosted requirements here.
- Shell syntax, Python compilation, diff whitespace, generated-artifact, and
  high-confidence credential-pattern audits passed.
- Hosted Check run `28212810366` passed the Swift harness, Wear policy, Python
  tests, both Xcode project-listing checks, and secret scan on commit
  `b3d05df0581849cba97a51e033cc7b42d2fbea23`; CodeQL run `28212809543`
  passed for Actions, Java/Kotlin, and Python.
- The Codex review helper targeted `origin/master` but could not authenticate
  with the OpenAI API (HTTP 401); exact-head manual review found no actionable
  findings, and every cited primary documentation URL returned HTTP 200.

### Bugs / findings

- P2: The repository identified the integrations as retired but did not map
  their responsibilities to current platform capabilities.

### Blockers

- No documentation blocker remains. Any implementation still requires current
  provider access, supported toolchains, maintainer-owned credentials, and
  device/service validation.

### Next action

- Keep the legacy dependency pins stable while scoping one separately verified
  modernization stage at a time.

## 2026-06-25 - P1 - canonical permalink ASCII path grammar

### Summary

The iOS navigation policy now matches its ASCII-only reference grammar instead
of accepting Unicode-wide alphanumeric and decimal characters.

### Work completed

- Rejected Unicode handle lookalikes and non-ASCII decimal digits from
  otherwise canonical Twitter/X tweet permalink paths.
- Replaced Unicode-wide character sets with exact UTF-8 byte validation for
  `[A-Za-z0-9_]+` handles and `[0-9]+` status IDs.
- Added standalone hostile permalink cases and mutation-sensitive source
  contracts for the production policy.

### Threads

- None; the focused policy change was completed directly.

### Files changed

- `TweetPermalinkPolicy.swift` and its standalone Swift matrix - enforce and execute the ASCII grammar.
- `scripts/check-ios-tweet-permalink.py` and `scripts/check-baseline.sh` - preserve source, hostile-case, plan, and documentation contracts.
- Maintainer guidance and design/implementation plans - document the canonical path boundary.

### Validation

- Observed `make check` fail first on the missing production ASCII helpers.
- All four Make aliases, Python compilation, shell syntax, and diff checks passed locally; local Swift execution was unavailable.
- Hosted Check run `28212033264` compiled and executed the production Swift policy, passed the Wear policy and 19 Python tests, parsed both Xcode projects, and found no current-tree secrets.
- CodeQL passed for Actions, Java/Kotlin, and Python on implementation commit `7336934638ea66c9ae433bb922458d70af4003f3`.
- Codex review could not authenticate; exact-head manual review found no actionable findings.

### Bugs / findings

- P1: Foundation's Unicode-wide character sets admitted canonical-host paths that were not valid ASCII Twitter handle or status-ID grammar.

### Blockers

- No merge blocker remains; retired SDK runtime behavior remains covered only by the documented manual verification matrix.

### Next action

- Re-run hosted checks for this evidence-only head and squash merge if green.

- Removed literal Fabric/Twitter credentials from the tracked TableView plist,
  added a redacted current-tree secret gate, and documented mandatory
  provider-side revocation for the credentials that remain exposed in history.
- Rejected non-status paths on otherwise canonical Twitter/X permalink hosts.
- Centralized strict Wear payload decoding, Unicode whitespace normalization,
  control-character rejection, and API-aware immutable notification intents in
  a pure Java policy with executable tests.
- Replaced mismatched Gradle 1.6-snapshot wrapper JARs with the reviewed Gradle
  v2.1 source artifact and added mutation-sensitive provenance checks without
  executing the legacy wrapper.

## 2026-06-16

- Extracted the iOS tweet permalink decision into production Foundation source
  and added a standalone Swift harness that executes the same policy from every
  Make gate when `swiftc` is available.

## 2026-06-15

- Enforced canonical Twitter and X hosts with no explicit port for iOS selected-
  tweet navigation, rejecting unrelated domains and host lookalikes before web
  request creation.

## 2026-06-14

- Published iOS TwitterKit login, load, and table state on the main queue.
- Validated each selected iOS tweet as a credential-free HTTPS permalink with a
  host before constructing the web request.
- Added Android legacy dependency pins for the Fabric plugin, support-v4, and
  wearable-only Google Play Services artifacts.
- Removed redundant Wear message-listener registration so the framework-managed
  `WearableListenerService` callback is the sole background delivery path.

## 2026-06-13

- Made Make verification independent of the caller's working directory.
- Refreshed reused Wear notification PendingIntent extras so later taps open
  the latest validated tweet text instead of stale content.
- Reject malformed or unmappable Wear UTF-8 payloads before notification state
  is created.
- Bounded Wear tweet messages to 1024 UTF-8 bytes before mobile transport and
  listener decoding.
- Added a truthful per-sample Android, Wear, iOS, and watchOS verification matrix
  with privacy, legacy-service, permalink, destructive crash, cleanup,
  and redacted-evidence boundaries; the Linux session did not execute it.

## 2026-06-12

- Declared the Wear listener service export explicitly for required Google Play
  Services binding and constrained its filter to the single Wear binding
  action through structural baseline checks.
- Made the Wear notification detail activity internal-only and removed its
  launcher intent filter.
- Preserved explicit notification `PendingIntent` delivery while preventing
  unrelated applications from launching the display with injected tweet text.

## 2026-06-10

- Type-checked iOS TwitterKit response objects before replacing visible table
  contents, avoiding force-cast crashes and duplicate stale rows.
- Added a bounded, least-privilege macOS GitHub Actions workflow that runs
  `make check` and parses both Xcode projects.
- Disabled persisted checkout credentials and added focused workflow policy
  checks for triggers, permissions, immutable actions, and command bypasses.
- Added repository-wide ownership and corrected contributor guidance to cover
  the mixed Android, Wear, iOS, and watchOS sample structure.
- Extended the baseline checker and docs to require the hosted CI verification
  path.

## 2026-06-09

- Guarded the Android Wear mobile tweet display container before adding
  TwitterKit tweet views.
- Disabled Android app-data backups for the display, mobile, and wear samples
  so legacy Twitter/Fabric app state is not opted into device backup by
  default.
- Guarded the Android Wear notification display when the tweet text view target
  is missing.
- Guarded the Android Wear mobile Twitter login button setup and activity-result
  forwarding paths when the login view is missing.
- Reset the iOS TableView tweet-loading in-flight flag on guest-login failure
  and tweet-load completion, and exposed `make lint`/`make test`/`make build`
  baseline aliases.
- Guarded Wear tweet loading so missing, empty, or whitespace-only tweet text
  is not sent to the watch sample or displayed in watch notifications.
- Removed raw Wear message path values from listener diagnostics and added a
  static baseline guard.
- Encoded Wear tweet messages as UTF-8 on the mobile sender to match listener
  decoding.
- Replaced raw Android tweet object and Twitter exception logs with generic
  display diagnostics.
- Replaced iOS raw tweet-load error printing with a generic message.
- Added a static baseline guard and plan for the display log boundary.

## 2026-06-08

- Guarded Wear tweet message sending, notification display, and listener
  cleanup against missing payloads and disconnected clients.
- Decoded Wear tweet payload bytes with explicit UTF-8 instead of the platform
  default charset.
- Added Google Maven to the legacy WearExample project so Wear support and Play
  Services artifacts resolve outside the old local SDK/JCenter paths.
- Replaced committed iOS Fabric run-script identifiers with local
  `FABRIC_API_KEY` and `FABRIC_BUILD_SECRET` environment variables.
- Added a static `make check` baseline for iOS Fabric scripts, Android
  Crashlytics placeholder keys, local credential ignores, and optional Xcode
  project listing.
- Documented local credential setup and verification boundaries for the legacy
  Android and iOS samples.
