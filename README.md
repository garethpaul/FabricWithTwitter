# FabricWithTwitter

<!-- README-OVERVIEW-IMAGE -->
![Project overview](docs/readme-overview.svg)

## Overview

`garethpaul/FabricWithTwitter` is an Apple platform application or Objective-C/Swift sample. A simple application that showcases how to integrate Fabric with Twitter

This README is based on the checked-in source, manifests, scripts, and repository metadata on the `master` branch. The project language mix found during review was: C/C++ headers (43), Swift (9), Java (6).

## Repository Contents

- `README.md` - project overview and local usage notes
- `Android` - source or example code
- `Makefile` and `scripts/check-baseline.sh` - static maintenance checks
- `iOS` - source or example code
- `SECURITY.md` - security reporting and disclosure guidance
- `VISION.md` - project direction and maintenance guardrails

Additional scan context:

- Source directories: Android, iOS
- Dependency and build manifests: none detected
- Entry points or build surfaces: Gradle build files
- Test-looking files: Android/DisplayTweets/app/src/androidTest/java/sample/twitterkit/fabric/twitter/com/twitterkit/ApplicationTest.java, Android/WearExample/mobile/src/androidTest/java/samples/twitterkit/fabric/twitter/com/wearexample/ApplicationTest.java, iOS/TableViewTweetsSwift/TableViewTweetsSwiftTests/Info.plist, iOS/TableViewTweetsSwift/TableViewTweetsSwiftTests/TableViewTweetsSwiftTests.swift, iOS/WatchSample/WatchSampleTests/Info.plist, iOS/WatchSample/WatchSampleTests/WatchSampleTests.swift

## Getting Started

### Prerequisites

- Git
- macOS with Xcode for building Apple platform projects

### Setup

```bash
git clone https://github.com/garethpaul/FabricWithTwitter.git
cd FabricWithTwitter
```

The setup commands above are derived from repository files. Legacy mobile, Python, or JavaScript samples may require older SDKs or package versions than a modern workstation uses by default.

## Running or Using the Project

- Use Android Studio to open the project or run `gradle assembleDebug` when the Android SDK is configured.
- Open the Xcode project or workspace in Xcode and run the matching app/sample scheme.
- Configure `FABRIC_API_KEY` and `FABRIC_BUILD_SECRET` in local Gradle/Xcode
  environment settings when exercising Fabric upload behavior. The checked-in
  iOS build phases skip Fabric upload when those variables are absent.
- Android manifests keep `com.crashlytics.ApiKey` empty in source; populate
  real values through local Fabric tooling or local build configuration only.

## Testing and Verification

Run the static maintenance baseline:

```bash
make check
```

The baseline verifies that committed iOS Fabric run scripts use local
environment variables, Android Crashlytics manifest keys remain placeholders,
raw tweet/error display logs are avoided, local credential files stay ignored,
and Xcode project listing is attempted when `xcodebuild` is installed.

For functional verification, use Android Studio/Gradle and Xcode's test action
or `xcodebuild test` with the appropriate scheme and destination.

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- Detected references to Twitter. Keep API keys, OAuth credentials, tokens, and account-specific values in local configuration only.
- Keep `FABRIC_API_KEY`, `FABRIC_BUILD_SECRET`, Twitter keys/tokens, Android
  keystores, signing identities, `.env`, and `.xcconfig` files out of source
  control.
- Do not log raw tweet objects, Twitter exception messages, or account-specific
  display data from sample apps.

## Security and Privacy Notes

- Review changes touching authentication or token handling; examples from the scan include iOS/TableViewTweetsSwift/TableViewTweetsSwift/ViewController.swift, iOS/TableViewTweetsSwift/TwitterKit.framework/Versions/A/Headers/DGTAuthenticateButton.h, iOS/TableViewTweetsSwift/TwitterKit.framework/Versions/A/Headers/DGTSession.h, iOS/TableViewTweetsSwift/TwitterKit.framework/Versions/A/Headers/Digits.h, and 6 more.
- Review changes touching external API calls or credential-adjacent configuration; examples from the scan include Android/DisplayTweets/app/build.gradle, Android/DisplayTweets/app/src/androidTest/java/sample/twitterkit/fabric/twitter/com/twitterkit/ApplicationTest.java, Android/DisplayTweets/app/src/main/AndroidManifest.xml, Android/DisplayTweets/app/src/main/java/sample/twitterkit/fabric/twitter/com/twitterkit/MainActivity.java, and 6 more.
- Review changes touching network requests, sockets, or service endpoints; examples from the scan include Android/DisplayTweets/app/build.gradle, Android/DisplayTweets/app/src/androidTest/java/sample/twitterkit/fabric/twitter/com/twitterkit/ApplicationTest.java, Android/DisplayTweets/app/src/main/AndroidManifest.xml, Android/DisplayTweets/app/src/main/res/layout/activity_main.xml, and 6 more.
- Review changes touching mobile permissions or privacy-sensitive device data; examples from the scan include Android/DisplayTweets/app/src/main/AndroidManifest.xml, Android/DisplayTweets/gradlew, Android/WearExample/gradlew, Android/WearExample/mobile/src/main/AndroidManifest.xml, and 2 more.
- Review changes touching file, media, JSON, XML, CSV, OCR, or data parsing; examples from the scan include Android/DisplayTweets/app/src/main/AndroidManifest.xml, Android/DisplayTweets/app/src/main/java/sample/twitterkit/fabric/twitter/com/twitterkit/MainActivity.java, Android/DisplayTweets/app/src/main/res/values/strings.xml, Android/DisplayTweets/app/src/main/res/values-v21/styles.xml, and 6 more.
- Review changes touching database, model, or persistence code; examples from the scan include iOS/TableViewTweetsSwift/TableViewTweetsSwift/ViewController.swift, iOS/TableViewTweetsSwift/TwitterKit.framework/Versions/A/Headers/TWTRTweetTableViewCell.h, iOS/TableViewTweetsSwift/TwitterKit.framework/Versions/A/Headers/TWTRTweetViewDelegate.h, iOS/WatchSample/TwitterKit.framework/Versions/A/Headers/TWTRTweetTableViewCell.h, and 1 more.

## Maintenance Notes

- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.
- Run `make check` before pushing changes to Android manifests, Xcode project
  files, Fabric/Twitter integration, or credential handling.
- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `VISION.md` for project direction and contribution guardrails.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
