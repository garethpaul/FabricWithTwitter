# Changes

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
