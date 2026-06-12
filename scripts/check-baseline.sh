#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-fabric-with-twitter-security-baseline.md"
WEAR_CHARSET_PLAN="$ROOT_DIR/docs/plans/2026-06-08-wear-message-utf8-decoding.md"
WEAR_SENDER_CHARSET_PLAN="$ROOT_DIR/docs/plans/2026-06-09-wear-message-utf8-sender.md"
TWITTER_LOG_PLAN="$ROOT_DIR/docs/plans/2026-06-09-twitter-display-log-boundary.md"
WEAR_PATH_LOG_PLAN="$ROOT_DIR/docs/plans/2026-06-09-wear-message-path-log-boundary.md"
IOS_TWEET_LOAD_PLAN="$ROOT_DIR/docs/plans/2026-06-09-ios-twitter-load-inflight-reset.md"
IOS_TWEET_TYPE_PLAN="$ROOT_DIR/docs/plans/2026-06-10-ios-twitter-tweet-type-guard.md"
WEAR_TWEET_PAYLOAD_PLAN="$ROOT_DIR/docs/plans/2026-06-09-wear-tweet-payload-guard.md"
WEAR_LOGIN_PLAN="$ROOT_DIR/docs/plans/2026-06-09-wear-login-button-guard.md"
WEAR_NOTIFICATION_VIEW_PLAN="$ROOT_DIR/docs/plans/2026-06-09-wear-notification-text-view-guard.md"
ANDROID_BACKUP_PLAN="$ROOT_DIR/docs/plans/2026-06-09-android-backup-opt-out.md"
WEAR_TWEET_VIEW_PLAN="$ROOT_DIR/docs/plans/2026-06-09-wear-tweet-view-container-guard.md"
CI_PLAN="$ROOT_DIR/docs/plans/2026-06-10-ci-baseline.md"
WEAR_ACTIVITY_PLAN="$ROOT_DIR/docs/plans/2026-06-12-wear-notification-activity-boundary.md"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"
CODEOWNERS="$ROOT_DIR/.github/CODEOWNERS"
WEAR_BUILD="$ROOT_DIR/Android/WearExample/build.gradle"
DISPLAY_ACTIVITY="$ROOT_DIR/Android/DisplayTweets/app/src/main/java/sample/twitterkit/fabric/twitter/com/twitterkit/MainActivity.java"
WEAR_MOBILE_ACTIVITY="$ROOT_DIR/Android/WearExample/mobile/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/MainActivity.java"
WEAR_LISTENER="$ROOT_DIR/Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/ListenerService.java"
WEAR_NOTIFICATION="$ROOT_DIR/Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/NotificationActivity.java"
WEAR_MANIFEST="$ROOT_DIR/Android/WearExample/wear/src/main/AndroidManifest.xml"
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
  ".github/CODEOWNERS" \
  ".github/workflows/check.yml" \
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
  "docs/plans/2026-06-09-ios-twitter-load-inflight-reset.md" \
  "docs/plans/2026-06-10-ios-twitter-tweet-type-guard.md" \
  "docs/plans/2026-06-09-wear-login-button-guard.md" \
  "docs/plans/2026-06-09-wear-message-utf8-sender.md" \
  "docs/plans/2026-06-09-wear-message-path-log-boundary.md" \
  "docs/plans/2026-06-09-android-backup-opt-out.md" \
  "docs/plans/2026-06-09-twitter-display-log-boundary.md" \
  "docs/plans/2026-06-10-ci-baseline.md" \
  "docs/plans/2026-06-12-wear-notification-activity-boundary.md" \
  "docs/plans/2026-06-09-wear-notification-text-view-guard.md" \
  "docs/plans/2026-06-09-wear-tweet-payload-guard.md" \
  "docs/plans/2026-06-09-wear-tweet-view-container-guard.md" \
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

if grep -R -F 'android:allowBackup="true"' "$ROOT_DIR/Android" --include='AndroidManifest.xml'; then
  printf '%s\n' "Android sample manifests must not opt into app-data backup by default." >&2
  exit 1
fi

for manifest in \
  "$ROOT_DIR/Android/DisplayTweets/app/src/main/AndroidManifest.xml" \
  "$ROOT_DIR/Android/WearExample/mobile/src/main/AndroidManifest.xml" \
  "$ROOT_DIR/Android/WearExample/wear/src/main/AndroidManifest.xml"; do
  if ! grep -Fq 'android:allowBackup="false"' "$manifest"; then
    printf '%s\n' "$manifest must explicitly disable app-data backup." >&2
    exit 1
  fi
done

python3 - "$WEAR_MANIFEST" <<'PY'
import sys
import xml.etree.ElementTree as ET

manifest = ET.parse(sys.argv[1]).getroot()
android = "{http://schemas.android.com/apk/res/android}"
activities = manifest.findall("./application/activity")
notification = next(
    (activity for activity in activities if activity.get(android + "name") == ".NotificationActivity"),
    None,
)
if notification is None:
    raise SystemExit("Wear NotificationActivity must remain declared.")
if notification.get(android + "exported") != "false":
    raise SystemExit("Wear NotificationActivity must remain non-exported.")
if notification.findall("intent-filter"):
    raise SystemExit("Wear NotificationActivity must not expose an intent filter.")
PY

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
  ! grep -Fq "tweet == null || tweet.text == null || tweet.text.trim().length() == 0" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "Skipping wear message without tweet text" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "final String safeTweetText = tweetText.trim()" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "safeTweetText.length() == 0" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "blockingConnect().isSuccess()" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "client != null && (client.isConnected() || client.isConnecting())" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq 'Charset.forName("UTF-8")' "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "safeTweetText.getBytes(UTF_8)" "$WEAR_MOBILE_ACTIVITY"; then
  printf '%s\n' "Wear mobile sender must guard missing messages, encode UTF-8 payloads, and disconnect clients safely." >&2
  exit 1
fi

wear_result_method=$(sed -n '/protected void onActivityResult/,$p' "$WEAR_MOBILE_ACTIVITY")
if ! grep -Fq "if (loginButton != null)" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "loginButton.setCallback" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq 'Log.w(TAG, "Twitter login button not found")' "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq 'Log.d(TAG, "Twitter login failed")' "$WEAR_MOBILE_ACTIVITY" ||
  ! printf '%s\n' "$wear_result_method" | grep -Fq "if (loginButton != null)" ||
  ! printf '%s\n' "$wear_result_method" | grep -Fq "loginButton.onActivityResult(requestCode, resultCode, data)"; then
  printf '%s\n' "Wear mobile login button setup and activity-result forwarding must be null-safe." >&2
  exit 1
fi

if ! grep -Fq "messageEvent == null || messageEvent.getPath() == null" "$WEAR_LISTENER" ||
  ! grep -Fq "Ignoring unexpected wear path" "$WEAR_LISTENER" ||
  ! grep -Fq "messageData == null || messageData.length == 0" "$WEAR_LISTENER" ||
  ! grep -Fq 'Charset.forName("UTF-8")' "$WEAR_LISTENER" ||
  ! grep -Fq "new String(messageData, UTF_8).trim()" "$WEAR_LISTENER" ||
  ! grep -Fq "tweet.length() == 0" "$WEAR_LISTENER" ||
  ! grep -Fq "Ignoring wear message without tweet text" "$WEAR_LISTENER"; then
  printf '%s\n' "Wear listener must guard message path and payload before notification display." >&2
  exit 1
fi

if grep -Eq 'Log\.[a-z]+\([^;]*messageEvent\.getPath\(\)' "$WEAR_LISTENER"; then
  printf '%s\n' "Wear listener must not log raw incoming message paths." >&2
  exit 1
fi

if ! grep -Fq "NotificationActivity.TWEET_KEY" "$WEAR_LISTENER" ||
  ! grep -Fq "removeListener(client, this)" "$WEAR_LISTENER" ||
  ! grep -Fq "client.disconnect()" "$WEAR_LISTENER"; then
  printf '%s\n' "Wear listener must use shared extras and release its GoogleApiClient listener." >&2
  exit 1
fi

if ! grep -Fq "tweet != null" "$WEAR_NOTIFICATION" ||
  ! grep -Fq "String safeTweet = tweet.trim()" "$WEAR_NOTIFICATION" ||
  ! grep -Fq "safeTweet.length() > 0" "$WEAR_NOTIFICATION"; then
  printf '%s\n' "Wear notification activity must guard missing tweet extras." >&2
  exit 1
fi

if ! grep -Fq "if (mTextView == null)" "$WEAR_NOTIFICATION" ||
  ! grep -Fq 'Log.w(TAG, "Wear notification text view not found")' "$WEAR_NOTIFICATION"; then
  printf '%s\n' "Wear notification activity must guard missing display targets." >&2
  exit 1
fi

if ! grep -Fq "final RelativeLayout tweetContainer" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "if (tweetContainer == null)" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq 'Log.w(TAG, "Tweet display container not found")' "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "tweetContainer.addView(new TweetView" "$WEAR_MOBILE_ACTIVITY" ||
  grep -Fq "myLayout.addView(new TweetView" "$WEAR_MOBILE_ACTIVITY"; then
  printf '%s\n' "Wear mobile tweet display must guard missing container targets." >&2
  exit 1
fi

if ! grep -Fq "lint: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "test: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "build: check" "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile must expose lint, test, and build gates." >&2
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

ios_loading_reset_count=$(grep -F "self.isLoadingTweets = false" "$IOS_TABLE_VIEW" | wc -l | tr -d ' ')
if ! grep -Fq "if session == nil" "$IOS_TABLE_VIEW" ||
  ! grep -Fq 'println("Twitter guest login failed")' "$IOS_TABLE_VIEW" ||
  [ "$ios_loading_reset_count" -lt 2 ]; then
  printf '%s\n' "iOS tweet loading must reset in-flight state on guest-login failure and tweet-load completion." >&2
  exit 1
fi

if ! grep -Fq "if let loadedTweetObjects = twttrs" "$IOS_TABLE_VIEW" ||
  ! grep -Fq "if let tweet = i as? TWTRTweet" "$IOS_TABLE_VIEW" ||
  ! grep -Fq "self.tweets = loadedTweets" "$IOS_TABLE_VIEW" ||
  grep -Fq "self.tweets.append(i as TWTRTweet)" "$IOS_TABLE_VIEW"; then
  printf '%s\n' "iOS loaded tweets must be type-checked before replacing table contents." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FABRIC_API_KEY" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FABRIC_BUILD_SECRET" "$ROOT_DIR/README.md" ||
  ! grep -Fq "tweet display container" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document static verification and local Fabric credentials." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Android" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Fabric run scripts" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "tweet display container guards" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe current Android and iOS credential guardrails." >&2
  exit 1
fi

if command -v xcodebuild >/dev/null 2>&1; then
  xcodebuild -list -project "$ROOT_DIR/iOS/TableViewTweetsSwift/TableViewTweetsSwift.xcodeproj" >/dev/null
  xcodebuild -list -project "$ROOT_DIR/iOS/WatchSample/WatchSample.xcodeproj" >/dev/null
else
  printf '%s\n' "Skipping xcodebuild project listing: xcodebuild is not installed."
fi

workflow_paths=$(find "$ROOT_DIR/.github/workflows" -type f \( -name '*.yml' -o -name '*.yaml' \) -print | LC_ALL=C sort)
if [ "$workflow_paths" != "$CI_WORKFLOW" ]; then
  printf '%s\n' "The reviewed check workflow must be the only GitHub Actions workflow." >&2
  exit 1
fi

codeowner_rules=$(grep -Ev '^[[:space:]]*(#|$)' "$CODEOWNERS" 2>/dev/null || true)
if [ "$codeowner_rules" != '* @garethpaul' ]; then
  printf '%s\n' "CODEOWNERS must retain repository-wide ownership." >&2
  exit 1
fi

if grep -E '^[[:space:]]*(-[[:space:]]+)?uses:' "$CI_WORKFLOW" | grep -Ev '@[0-9a-f]{40}([[:space:]]+#.*)?$' >/dev/null; then
  printf '%s\n' "GitHub Actions must use immutable commit revisions." >&2
  exit 1
fi

workflow_uses=$(grep -E '^[[:space:]]*(-[[:space:]]+)?uses:' "$CI_WORKFLOW" | sed -E 's/^[[:space:]]*(-[[:space:]]+)?//')
if [ "$workflow_uses" != 'uses: actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10 # v6.0.3' ]; then
  printf '%s\n' "GitHub Actions must use only the reviewed checkout action." >&2
  exit 1
fi

if [ "$(grep -Ec '^permissions:$' "$CI_WORKFLOW")" -ne 1 ] ||
  [ "$(grep -Ec '^  contents: read$' "$CI_WORKFLOW")" -ne 1 ] ||
  grep -Eq 'write-all|contents:[[:space:]]*write|pull-requests:[[:space:]]*write|actions:[[:space:]]*write' "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions permissions must remain globally read-only." >&2
  exit 1
fi

if [ "$(grep -Ec '^[[:space:]]*(-[[:space:]]+)?run:' "$CI_WORKFLOW")" -ne 1 ] ||
  ! grep -Eq '^[[:space:]]*run: make check[[:space:]]*$' "$CI_WORKFLOW" ||
  grep -Eq 'continue-on-error:[[:space:]]*true|if:[[:space:]]*false' "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions must run exactly the required Make gate without bypasses." >&2
  exit 1
fi

if [ "$(grep -Ec '^[[:space:]]*persist-credentials: false$' "$CI_WORKFLOW")" -ne 1 ] ||
  grep -Eq '^[[:space:]]*persist-credentials: true$' "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions checkout credentials must not persist." >&2
  exit 1
fi

for workflow_contract in \
  'push:' \
  'branches:' \
  '- master' \
  'pull_request:' \
  'workflow_dispatch:' \
  'contents: read' \
  'cancel-in-progress: true' \
  'runs-on: macos-15' \
  'timeout-minutes: 10' \
  'persist-credentials: false'; do
  if ! grep -Fq -- "$workflow_contract" "$CI_WORKFLOW"; then
    printf '%s\n' "GitHub Actions workflow must keep contract: $workflow_contract" >&2
    exit 1
  fi
done

if ! awk '
  /^  pull_request:$/ {
    found = 1
    if (getline <= 0 || $0 != "  push:") exit 1
  }
  END { if (!found) exit 1 }
' "$CI_WORKFLOW"; then
  printf '%s\n' "Pull request verification must apply without branch restrictions." >&2
  exit 1
fi

if ! grep -Fq "GitHub Actions" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "make check" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "docs/plans/2026-06-10-ci-baseline.md" "$ROOT_DIR/README.md"; then
  printf '%s\n' "Project docs must record the GitHub Actions CI baseline." >&2
  exit 1
fi
if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$WEAR_CHARSET_PLAN"; then
  printf '%s\n' "Wear message UTF-8 plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$WEAR_SENDER_CHARSET_PLAN"; then
  printf '%s\n' "Wear message UTF-8 sender plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TWITTER_LOG_PLAN"; then
  printf '%s\n' "Twitter display log boundary plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$WEAR_PATH_LOG_PLAN"; then
  printf '%s\n' "Wear message path log boundary plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$IOS_TWEET_LOAD_PLAN"; then
  printf '%s\n' "iOS tweet load in-flight reset plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$IOS_TWEET_TYPE_PLAN"; then
  printf '%s\n' "iOS tweet type guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$WEAR_TWEET_PAYLOAD_PLAN"; then
  printf '%s\n' "Wear tweet payload guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$WEAR_TWEET_PAYLOAD_PLAN"; then
  printf '%s\n' "Wear tweet payload guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$WEAR_LOGIN_PLAN"; then
  printf '%s\n' "Wear login button guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$WEAR_LOGIN_PLAN"; then
  printf '%s\n' "Wear login button guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$WEAR_NOTIFICATION_VIEW_PLAN"; then
  printf '%s\n' "Wear notification text view guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$WEAR_NOTIFICATION_VIEW_PLAN"; then
  printf '%s\n' "Wear notification text view guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$ANDROID_BACKUP_PLAN"; then
  printf '%s\n' "Android backup opt-out plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ANDROID_BACKUP_PLAN"; then
  printf '%s\n' "Android backup opt-out plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$WEAR_TWEET_VIEW_PLAN"; then
  printf '%s\n' "Wear tweet view container guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CI_PLAN"; then
  printf '%s\n' "CI baseline plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$WEAR_ACTIVITY_PLAN" ||
  ! grep -Fq "27392063786" "$WEAR_ACTIVITY_PLAN" ||
  ! grep -Fq "27392064680" "$WEAR_ACTIVITY_PLAN"; then
  printf '%s\n' "Wear notification activity plan must remain completed with hosted verification recorded." >&2
  exit 1
fi

if ! grep -Fq "make check" "$WEAR_TWEET_VIEW_PLAN"; then
  printf '%s\n' "Wear tweet view container guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "make check" "$CI_PLAN"; then
  printf '%s\n' "CI baseline plan must record make check verification." >&2
  exit 1
fi

printf '%s\n' "FabricWithTwitter baseline checks passed."
