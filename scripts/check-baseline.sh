#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-fabric-with-twitter-security-baseline.md"
WEAR_CHARSET_PLAN="$ROOT_DIR/docs/plans/2026-06-08-wear-message-utf8-decoding.md"
TWITTER_LOG_PLAN="$ROOT_DIR/docs/plans/2026-06-09-twitter-display-log-boundary.md"
WEAR_BUILD="$ROOT_DIR/Android/WearExample/build.gradle"
DISPLAY_ACTIVITY="$ROOT_DIR/Android/DisplayTweets/app/src/main/java/sample/twitterkit/fabric/twitter/com/twitterkit/MainActivity.java"
WEAR_MOBILE_ACTIVITY="$ROOT_DIR/Android/WearExample/mobile/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/MainActivity.java"
WEAR_LISTENER="$ROOT_DIR/Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/ListenerService.java"
WEAR_NOTIFICATION="$ROOT_DIR/Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/NotificationActivity.java"
IOS_TABLE_VIEW="$ROOT_DIR/iOS/TableViewTweetsSwift/TableViewTweetsSwift/ViewController.swift"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".gitignore" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "Android/DisplayTweets/app/src/main/AndroidManifest.xml" \
  "Android/DisplayTweets/app/src/main/java/sample/twitterkit/fabric/twitter/com/twitterkit/MainActivity.java" \
  "Android/WearExample/build.gradle" \
  "Android/WearExample/mobile/src/main/AndroidManifest.xml" \
  "Android/WearExample/mobile/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/MainActivity.java" \
  "Android/WearExample/wear/src/main/AndroidManifest.xml" \
  "Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/ListenerService.java" \
  "Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/NotificationActivity.java" \
  "iOS/TableViewTweetsSwift/TableViewTweetsSwift.xcodeproj/project.pbxproj" \
  "iOS/TableViewTweetsSwift/TableViewTweetsSwift/ViewController.swift" \
  "iOS/WatchSample/WatchSample.xcodeproj/project.pbxproj" \
  "docs/plans/2026-06-09-twitter-display-log-boundary.md" \
  "docs/plans/2026-06-08-wear-message-utf8-decoding.md" \
  "docs/plans/2026-06-08-fabric-with-twitter-security-baseline.md"; do
  require_file "$path"
done

if grep -R -E './Fabric\.framework/run [0-9a-f]{32,}|~/Downloads/Fabric\.framework/run [0-9a-f]{32,}' "$ROOT_DIR/iOS" --include='project.pbxproj'; then
  printf '%s\n' "iOS Fabric run scripts must not contain committed API keys or build secrets." >&2
  exit 1
fi

for project in \
  "$ROOT_DIR/iOS/TableViewTweetsSwift/TableViewTweetsSwift.xcodeproj/project.pbxproj" \
  "$ROOT_DIR/iOS/WatchSample/WatchSample.xcodeproj/project.pbxproj"; do
  if ! grep -Fq "FABRIC_API_KEY" "$project" ||
    ! grep -Fq "FABRIC_BUILD_SECRET" "$project" ||
    ! grep -Fq "FABRIC_RUN_SCRIPT" "$project" ||
    ! grep -Fq "Skipping Fabric upload" "$project"; then
    printf '%s\n' "Fabric run scripts must use local environment variables and skip safely when unset." >&2
    exit 1
  fi
done

if grep -R -E 'com\.crashlytics\.ApiKey" android:value="[A-Za-z0-9_./+-]{6,}"' "$ROOT_DIR/Android" --include='AndroidManifest.xml'; then
  printf '%s\n' "Android Crashlytics API keys must remain placeholders in source." >&2
  exit 1
fi

if ! grep -Fq ".env" "$ROOT_DIR/.gitignore" ||
  ! grep -Fq "*.xcconfig" "$ROOT_DIR/.gitignore" ||
  ! grep -Fq "*.keystore" "$ROOT_DIR/.gitignore" ||
  ! grep -Fq "crashlytics.properties" "$ROOT_DIR/.gitignore"; then
  printf '%s\n' "Local credential and signing files must stay ignored." >&2
  exit 1
fi

if ! grep -Fq "https://dl.google.com/dl/android/maven2" "$WEAR_BUILD"; then
  printf '%s\n' "WearExample build must include Google Maven for legacy wearable artifacts." >&2
  exit 1
fi

if ! grep -Fq "path == null || tweetText == null || messageClient == null" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "blockingConnect().isSuccess()" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "client != null && (client.isConnected() || client.isConnecting())" "$WEAR_MOBILE_ACTIVITY"; then
  printf '%s\n' "Wear mobile sender must guard missing messages and disconnect clients safely." >&2
  exit 1
fi

if ! grep -Fq "messageEvent == null || messageEvent.getPath() == null" "$WEAR_LISTENER" ||
  ! grep -Fq "Ignoring unexpected wear path" "$WEAR_LISTENER" ||
  ! grep -Fq "messageData == null || messageData.length == 0" "$WEAR_LISTENER" ||
  ! grep -Fq 'Charset.forName("UTF-8")' "$WEAR_LISTENER" ||
  ! grep -Fq "new String(messageData, UTF_8)" "$WEAR_LISTENER"; then
  printf '%s\n' "Wear listener must guard message path and payload before notification display." >&2
  exit 1
fi

if ! grep -Fq "NotificationActivity.TWEET_KEY" "$WEAR_LISTENER" ||
  ! grep -Fq "removeListener(client, this)" "$WEAR_LISTENER" ||
  ! grep -Fq "client.disconnect()" "$WEAR_LISTENER"; then
  printf '%s\n' "Wear listener must use shared extras and release its GoogleApiClient listener." >&2
  exit 1
fi

if ! grep -Fq "tweet != null && tweet.length() > 0" "$WEAR_NOTIFICATION"; then
  printf '%s\n' "Wear notification activity must guard missing tweet extras." >&2
  exit 1
fi

if grep -Fq "tweet.toString()" "$DISPLAY_ACTIVITY" ||
  grep -Fq "exception.getMessage()" "$DISPLAY_ACTIVITY" ||
  grep -Fq 'Log.v("tweet"' "$DISPLAY_ACTIVITY" ||
  grep -Fq 'Log.v("hi"' "$DISPLAY_ACTIVITY" ||
  grep -Fq "println(error)" "$IOS_TABLE_VIEW"; then
  printf '%s\n' "Twitter display samples must not log raw tweets or raw Twitter errors." >&2
  exit 1
fi

if ! grep -Fq "private static final String TAG = MainActivity.class.getSimpleName()" "$DISPLAY_ACTIVITY" ||
  ! grep -Fq 'Log.v(TAG, "Loaded tweet for display")' "$DISPLAY_ACTIVITY" ||
  ! grep -Fq 'Log.v(TAG, "Tweet load failed")' "$DISPLAY_ACTIVITY" ||
  ! grep -Fq 'println("Twitter tweet load failed")' "$IOS_TABLE_VIEW"; then
  printf '%s\n' "Twitter display samples must use generic log messages." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FABRIC_API_KEY" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FABRIC_BUILD_SECRET" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document static verification and local Fabric credentials." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Android" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Fabric run scripts" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe current Android and iOS credential guardrails." >&2
  exit 1
fi

if command -v xcodebuild >/dev/null 2>&1; then
  xcodebuild -list -project "$ROOT_DIR/iOS/TableViewTweetsSwift/TableViewTweetsSwift.xcodeproj" >/dev/null
  xcodebuild -list -project "$ROOT_DIR/iOS/WatchSample/WatchSample.xcodeproj" >/dev/null
else
  printf '%s\n' "Skipping xcodebuild project listing: xcodebuild is not installed."
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$WEAR_CHARSET_PLAN"; then
  printf '%s\n' "Wear message UTF-8 plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TWITTER_LOG_PLAN"; then
  printf '%s\n' "Twitter display log boundary plan must be marked completed." >&2
  exit 1
fi

printf '%s\n' "FabricWithTwitter baseline checks passed."
