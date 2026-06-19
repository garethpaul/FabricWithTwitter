# Cross-Platform Sample Verification Matrix

Use this matrix to record build and runtime evidence separately for each legacy
sample.

## Status And Evidence Boundary

This matrix was not executed during the Linux maintenance session that added
it. Record a separate pass/fail/blocked result for every sample at the exact
tested commit. Static Linux checks and hosted Xcode project listing do not prove
that Android, Wear, iOS, watchOS, Fabric, TwitterKit, or Twitter service flows
run. Never turn `make check`, project listing, or one platform build
into evidence for a different sample or an external-service runtime flow.

Use only devices, emulators, accounts, credentials, and infrastructure owned by
the tester or explicitly authorized for testing. Keep Fabric/Twitter keys and
tokens, Android keystores, Apple signing data, `.env`, `.xcconfig`, account
identifiers, tweet IDs/text, Wear paths/payloads, raw errors, and private service
responses out of source control and evidence.

## Toolchain And Global Prerequisites

- Record the historical Android Studio, Gradle, Android SDK, Google Play
  Services, Xcode, Swift, iOS, watchOS, device/emulator, and signing versions
  used for each applicable sample.
- Start from a clean exact-commit checkout. Keep manifest API keys as empty
  placeholders and provide any authorized values through local tooling only.
- For the iOS TableView sample, copy
  `Config/LocalSecrets.xcconfig.example` to the ignored
  `Config/LocalSecrets.xcconfig`, populate it only with tester-owned authorized
  values, and pass it with `xcodebuild -xcconfig`. Never edit the tracked plist
  placeholders or retain the populated local file after verification.
- Android Twitter key/secret constants are also empty in checked-in Java source.
  If runtime testing requires an authorized fixture build, inject tester-owned
  values locally, keep the source change uncommitted, and restore it immediately.
- Use locally owned least-privilege test credentials. Do not test with
  production accounts or third-party private content.
- The samples use fixed public tweet IDs. Returned tweets may be third-party
  public content; do not copy, screenshot, publish, or retain it as evidence.
- If historical dependencies, repositories, SDKs, Fabric/TwitterKit, Google Play
  Services, or Twitter APIs are unavailable, mark dependent steps blocked with
  the exact compatibility/service reason rather than passed.

## Android DisplayTweets

1. Open `Android/DisplayTweets` with a compatible historical Android toolchain
   and build/install the debug app without changing checked-in key placeholders.
2. With an authorized uncommitted fixture/local credential injection, launch the
   app and verify successfully loaded fixed-ID tweets render as compact tweet views.
3. Verify diagnostics remain generic (`Loaded tweet for display` or
   `Tweet load failed`) and contain no tweet object, ID/text, username, token,
   credential, or raw Twitter exception.
4. Repeat with unavailable/invalid local credentials or inaccessible fixed IDs.
   Confirm the app remains responsive and no sensitive detail is logged.
5. Confirm app-data backup remains disabled in the installed manifest.

## Android Wear Mobile

1. Build/install the `Android/WearExample` mobile app and paired Wear app with a
   compatible historical Gradle/Android/Google Play Services toolchain.
2. Confirm a missing login button or tweet container fails safely with a generic
   diagnostic in an authorized fixture build rather than crashing.
3. Complete tester-controlled Twitter login from an authorized uncommitted
   fixture/local credential injection where the retired service permits it.
   Confirm the login control hides only after success and failures are generic.
4. Load the fixed-ID tweet. Confirm null, missing, empty, and whitespace-only
   tweet text is not displayed or sent to Wear.
5. Confirm valid trimmed text renders in the mobile tweet container and is UTF-8
   encoded for the expected `/new_tweet` path only when a Wear node is connected.
6. Confirm payloads over 1024 UTF-8 bytes are rejected before transport and raw
   paths, payload text, node IDs, account data, or exceptions are not logged.

## Wear Listener And Notification

1. Confirm the Wear listener service is exported only for the system
   `com.google.android.gms.wearable.BIND_LISTENER` action and the notification
   detail activity remains internal-only with no launcher intent filter.
2. Deliver an authorized fixture message on `/new_tweet`. Confirm the listener
   decodes UTF-8, trims non-empty text, posts one notification, and opens the
   internal detail activity with the same trimmed text.
3. Send fixture messages with a null/missing path, unexpected path, missing or
   empty payload, whitespace-only text, and payload over 1024 bytes. Confirm each
   is ignored without a notification or activity display.
4. Confirm diagnostics remain generic and do not expose the Wear path, payload,
   tweet text, node/device identifiers, account data, or raw exception details.
5. Destroy the listener and confirm it removes its message listener and
   disconnects or stops connecting the Google API client.

## iOS TableViewTweetsSwift

1. Open `iOS/TableViewTweetsSwift/TableViewTweetsSwift.xcodeproj` with a
   compatible Xcode/Swift toolchain, sign locally, and build/run the app.
2. With authorized local Fabric/Twitter configuration, confirm one guest load
   starts and overlapping loads are suppressed. The in-flight flag must remain
   set after guest-login success while tweet loading continues, then reset on
   guest-login failure or tweet-load completion.
3. Confirm only typed `TWTRTweet` objects replace visible rows and a refresh can
   start another load after completion.
4. Exercise controlled login/load failures where possible. Confirm generic
   diagnostics with no raw errors, account details, tweet IDs/text, or objects.
5. Treat tweet selection as a known unsafe legacy boundary: the current sample
   loads `tweet.permalink` directly into `UIWebView` without HTTPS/host/userinfo
   validation. Do not use untrusted fixture URLs or claim navigation is hardened.

## iOS WatchSample

1. Open `iOS/WatchSample/WatchSample.xcodeproj` with a compatible historical
   Xcode/watchOS toolchain and verify the project/schemes can be parsed and built
   without replacing checked-in placeholders with committed credentials.
2. Classify this sample as a placeholder Crashlytics demonstration rather than
   a Twitter display integration; record which app/watch extension targets build.
3. Do not invoke the `ForceCrash` action during routine verification. It calls
   `Crashlytics.sharedInstance().crash()` intentionally and is destructive.
4. Confirm watch lifecycle diagnostics do not include credentials, account data,
   tweet content, device identifiers, or signing details.

## Failure, Privacy, And Cleanup

- Keep every failure generic and avoid retaining console output that includes
  account, tweet, Wear path/payload, node/device, credential, or raw error data.
- Do not weaken empty Android manifest placeholders, local-only iOS Fabric build
  variables, app-data backup opt-outs, Wear component export boundaries, UTF-8
  validation, or the 1024-byte message limit to make a historical build work.
- Remove local keys/tokens, keystores, signing exports, `.env`/`.xcconfig` files,
  captured traffic, screenshots, logs, and build output after verification.
- Rotate any credential that appears in a transcript, screenshot, log, build
  artifact, or captured request.

## Evidence Record

For each sample, record commit SHA, toolchain versions, target/module/scheme,
device or emulator model and OS, build/install result, locally owned credential
source, fixed-content/service availability, and pass/fail/blocked result for
every applicable step. Record skipped steps and exact blockers explicitly.

Evidence must be scrubbed of keys/tokens, account identifiers, tweet IDs/text,
Wear paths/payloads, node/device identifiers, keystore/signing details, private
URLs, raw errors, and third-party content. Keep static `make check`, hosted Xcode
project listing, platform build/install, and external-service runtime results as
four separate evidence classes.
