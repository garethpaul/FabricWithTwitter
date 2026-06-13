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
WEAR_LISTENER_EXPORT_PLAN="$ROOT_DIR/docs/plans/2026-06-12-wear-listener-service-export-contract.md"
WEAR_PAYLOAD_LIMIT_PLAN="$ROOT_DIR/docs/plans/2026-06-13-wear-message-payload-limit.md"
SAMPLE_VERIFICATION_PLAN="$ROOT_DIR/docs/plans/2026-06-13-cross-platform-sample-verification.md"
WEAR_STRICT_UTF8_PLAN="$ROOT_DIR/docs/plans/2026-06-13-wear-strict-utf8-decoding.md"
WEAR_PENDING_INTENT_PLAN="$ROOT_DIR/docs/plans/2026-06-13-wear-notification-pending-intent-refresh.md"
SAMPLE_VERIFICATION="$ROOT_DIR/docs/manual-sample-verification.md"
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
  "docs/manual-sample-verification.md" \
  "docs/plans/2026-06-09-ios-twitter-load-inflight-reset.md" \
  "docs/plans/2026-06-10-ios-twitter-tweet-type-guard.md" \
  "docs/plans/2026-06-09-wear-login-button-guard.md" \
  "docs/plans/2026-06-09-wear-message-utf8-sender.md" \
  "docs/plans/2026-06-09-wear-message-path-log-boundary.md" \
  "docs/plans/2026-06-09-android-backup-opt-out.md" \
  "docs/plans/2026-06-09-twitter-display-log-boundary.md" \
  "docs/plans/2026-06-10-ci-baseline.md" \
  "docs/plans/2026-06-12-wear-notification-activity-boundary.md" \
  "docs/plans/2026-06-12-wear-listener-service-export-contract.md" \
  "docs/plans/2026-06-13-wear-message-payload-limit.md" \
  "docs/plans/2026-06-13-cross-platform-sample-verification.md" \
  "docs/plans/2026-06-13-wear-strict-utf8-decoding.md" \
  "docs/plans/2026-06-13-wear-notification-pending-intent-refresh.md" \
  "docs/plans/2026-06-09-wear-notification-text-view-guard.md" \
  "docs/plans/2026-06-09-wear-tweet-payload-guard.md" \
  "docs/plans/2026-06-09-wear-tweet-view-container-guard.md" \
  "docs/plans/2026-06-08-wear-message-utf8-decoding.md" \
  "docs/plans/2026-06-08-fabric-with-twitter-security-baseline.md"; do
  require_file "$path"
done

if [ "$(grep -Fc 'PendingIntent.getActivity(this, 0, viewIntent, PendingIntent.FLAG_UPDATE_CURRENT)' "$WEAR_LISTENER")" -ne 1 ] ||
  grep -Fq 'PendingIntent.getActivity(this, 0, viewIntent, 0)' "$WEAR_LISTENER" ||
  ! grep -Fq 'viewIntent.putExtra(NotificationActivity.TWEET_KEY, tweet)' "$WEAR_LISTENER"; then
  printf '%s\n' "Wear notification PendingIntent must refresh the latest validated tweet extra." >&2
  exit 1
fi

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

services = [
    service
    for service in manifest.findall("./application/service")
    if service.get(android + "name") == ".ListenerService"
]
if len(services) != 1:
    raise SystemExit("Wear ListenerService must remain declared exactly once.")

listener = services[0]
if listener.get(android + "exported") != "true":
    raise SystemExit("Wear ListenerService must remain explicitly exported for system binding.")

filters = listener.findall("intent-filter")
if len(filters) != 1:
    raise SystemExit("Wear ListenerService must retain exactly one intent filter.")

listener_filter = filters[0]
actions = [action.get(android + "name") for action in listener_filter.findall("action")]
if actions != ["com.google.android.gms.wearable.BIND_LISTENER"]:
    raise SystemExit("Wear ListenerService must expose only the Wear binding action.")
if listener_filter.findall("category") or listener_filter.findall("data"):
    raise SystemExit("Wear ListenerService binding filter must not add categories or data selectors.")
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

if [ "$(grep -Fc "private static final int MAX_TWEET_PAYLOAD_BYTES = 1024;" "$WEAR_MOBILE_ACTIVITY")" -ne 1 ] ||
  ! grep -Fq "final byte[] tweetPayload = safeTweetText.getBytes(UTF_8);" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "tweetPayload.length > MAX_TWEET_PAYLOAD_BYTES" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq 'Log.d(TAG, "Skipping oversized wear tweet payload")' "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "messageClient, node.getId(), path, tweetPayload).await();" "$WEAR_MOBILE_ACTIVITY" ||
  grep -Fq "path, safeTweetText.getBytes(UTF_8)).await();" "$WEAR_MOBILE_ACTIVITY"; then
  printf '%s\n' "Wear mobile sender must enforce and reuse the reviewed 1024-byte payload limit." >&2
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
  ! grep -Fq "decodeTweetPayload(messageData)" "$WEAR_LISTENER" ||
  ! grep -Fq "CodingErrorAction.REPORT" "$WEAR_LISTENER" ||
  ! grep -Fq "CharacterCodingException" "$WEAR_LISTENER" ||
  grep -Fq "new String(messageData, UTF_8)" "$WEAR_LISTENER" ||
  ! grep -Fq "tweet.length() == 0" "$WEAR_LISTENER" ||
  ! grep -Fq "Ignoring wear message without tweet text" "$WEAR_LISTENER"; then
  printf '%s\n' "Wear listener must guard message path and payload before notification display." >&2
  exit 1
fi

if [ "$(grep -Fc "private static final int MAX_TWEET_PAYLOAD_BYTES = 1024;" "$WEAR_LISTENER")" -ne 1 ] ||
  ! grep -Fq "messageData.length > MAX_TWEET_PAYLOAD_BYTES" "$WEAR_LISTENER" ||
  ! grep -Fq 'Log.e(TAG, "Ignoring oversized wear tweet payload")' "$WEAR_LISTENER"; then
  printf '%s\n' "Wear listener must enforce the reviewed 1024-byte payload limit before decoding." >&2
  exit 1
fi

python3 - "$WEAR_MOBILE_ACTIVITY" "$WEAR_LISTENER" <<'PY'
import re
import sys
from pathlib import Path

sender = Path(sys.argv[1]).read_text()
listener = Path(sys.argv[2]).read_text()

constant = re.compile(r"private static final int MAX_TWEET_PAYLOAD_BYTES = (\d+);")
sender_limits = constant.findall(sender)
listener_limits = constant.findall(listener)
if sender_limits != ["1024"] or listener_limits != sender_limits:
    raise SystemExit("Wear payload limits must be single, equal 1024-byte constants.")

sender_contract = (
    "final String safeTweetText = tweetText.trim();",
    "final byte[] tweetPayload = safeTweetText.getBytes(UTF_8);",
    "tweetPayload.length > MAX_TWEET_PAYLOAD_BYTES",
    "new Thread(new Runnable()",
    "messageClient, node.getId(), path, tweetPayload).await();",
)
listener_contract = (
    "messageData == null || messageData.length == 0",
    "messageData.length > MAX_TWEET_PAYLOAD_BYTES",
    "decodeTweetPayload(messageData)",
    "decodedTweet == null",
    "String tweet = decodedTweet.trim()",
    "new Intent(this, NotificationActivity.class)",
    "notificationManager.notify(NOTIFICATION_ID, notificationBuilder.build())",
)

for name, source, contract in (
    ("sender", sender, sender_contract),
    ("listener", listener, listener_contract),
):
    positions = [source.find(fragment) for fragment in contract]
    if -1 in positions or positions != sorted(positions) or len(set(positions)) != len(positions):
        raise SystemExit(f"Wear {name} payload validation ordering must remain fail-closed.")
PY

python3 - "$WEAR_LISTENER" <<'PY'
import pathlib
import sys

source = pathlib.Path(sys.argv[1]).read_text()
required = (
    "UTF_8.newDecoder()",
    ".onMalformedInput(CodingErrorAction.REPORT)",
    ".onUnmappableCharacter(CodingErrorAction.REPORT)",
    "decoder.decode(ByteBuffer.wrap(messageData)).toString()",
    "catch (CharacterCodingException exception)",
    'Log.e(TAG, "Ignoring malformed UTF-8 wear tweet payload")',
)
if any(item not in source for item in required):
    raise SystemExit("Wear listener must reject malformed UTF-8 without replacement decoding")

decode = source.find("decodeTweetPayload(messageData)")
decode_failure = source.find("if (decodedTweet == null)", decode)
trim = source.find("String tweet = decodedTweet.trim()", decode_failure)
intent = source.find("new Intent(this, NotificationActivity.class)", trim)
notify = source.find("notificationManager.notify", intent)
if -1 in (decode, decode_failure, trim, intent, notify) or not (
    decode < decode_failure < trim < intent < notify
):
    raise SystemExit("Strict UTF-8 decoding must precede notification construction and display")
PY

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

if ! grep -Fq "reject UTF-8 payloads over 1024 bytes" "$ROOT_DIR/README.md" ||
  ! grep -Fq "reject UTF-8 payloads over 1024 bytes" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "bounded to 1024 UTF-8 bytes" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Bounded Wear tweet messages to 1024 UTF-8 bytes" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project docs must record the Wear tweet payload boundary." >&2
  exit 1
fi

if ! grep -Fq "rejects malformed UTF-8 instead of" "$ROOT_DIR/README.md" ||
  ! grep -Fq "reject malformed or unmappable UTF-8" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "rejects malformed or unmappable UTF-8" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Reject malformed or unmappable Wear UTF-8 payloads" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project docs must preserve strict Wear UTF-8 decoding." >&2
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

python3 - "$WEAR_LISTENER_EXPORT_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
statuses = re.findall(r"^status: .+$", plan, flags=re.MULTILINE)
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "Pull-request run `27408397355` passed",
    "CodeQL run `27408395236` passed",
    "`refs/pull/1/head` had zero open code-scanning alerts",
)

if (
    statuses != ["status: completed"]
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run)\b", verification, re.IGNORECASE)
):
    raise SystemExit(
        "Wear listener export plan must remain completed with actual hosted verification recorded."
    )
PY

python3 - "$WEAR_PAYLOAD_LIMIT_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text()
statuses = re.findall(r"^status: .+$", plan, flags=re.MULTILINE)
required = (
    "sender guard mutation failed",
    "listener guard mutation failed",
    "limit drift mutation failed",
    "hosted pull-request check",
)

if statuses != ["status: completed"] or any(item not in plan for item in required):
    raise SystemExit(
        "Wear payload limit plan must record completed status and actual verification."
    )
PY

if ! grep -Fq "status: completed" "$WEAR_STRICT_UTF8_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$WEAR_STRICT_UTF8_PLAN" ||
  ! grep -Fq "xcodebuild was unavailable" "$WEAR_STRICT_UTF8_PLAN" ||
  ! grep -Fq "No Twitter or Fabric credentials" "$WEAR_STRICT_UTF8_PLAN"; then
  printf '%s\n' "Wear strict UTF-8 plan must record completed local verification." >&2
  exit 1
fi

for pending_intent_plan_contract in \
  "status: completed" \
  "## Status: Completed" \
  "FLAG_UPDATE_CURRENT" \
  "make build" \
  "Four isolated hostile mutations were rejected" \
  "Android/Wear and xcodebuild toolchains were unavailable" \
  "No Android/Wear emulator or device"; do
  if ! grep -Fq "$pending_intent_plan_contract" "$WEAR_PENDING_INTENT_PLAN"; then
    printf '%s\n' "Wear PendingIntent plan must record completed verification: $pending_intent_plan_contract" >&2
    exit 1
  fi
done

if ! grep -Fq "notification intents refresh their tweet extra" "$ROOT_DIR/README.md" ||
  ! grep -Fq "notification PendingIntents should update" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "notification PendingIntents refresh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Refreshed reused Wear notification PendingIntent extras" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "notification PendingIntents must refresh" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Wear PendingIntent refresh documentation must remain synchronized." >&2
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

python3 - "$SAMPLE_VERIFICATION" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
required_sections = {
    "Status And Evidence Boundary": [
        "was not executed during the Linux maintenance session",
        "Static Linux checks and hosted Xcode project listing do not prove",
        "pass/fail/blocked result for every sample",
        "owned by the tester or explicitly authorized for testing",
    ],
    "Toolchain And Global Prerequisites": [
        "Android Studio, Gradle, Android SDK, Google Play Services, Xcode, Swift, iOS, watchOS",
        "manifest API keys as empty placeholders",
        "Twitter key/secret constants are also empty in checked-in Java source",
        "keep the source change uncommitted",
        "fixed public tweet IDs",
        "do not copy, screenshot, publish, or retain it as evidence",
        "mark dependent steps blocked",
    ],
    "Android DisplayTweets": [
        "build/install the debug app",
        "authorized uncommitted fixture/local credential injection",
        "fixed-ID tweets render as compact tweet views",
        "Loaded tweet for display",
        "Tweet load failed",
        "no tweet object, ID/text, username, token, credential, or raw Twitter exception",
        "app-data backup remains disabled",
    ],
    "Android Wear Mobile": [
        "missing login button or tweet container fails safely",
        "authorized uncommitted fixture/local credential injection",
        "login control hides only after success",
        "null, missing, empty, and whitespace-only tweet text",
        "UTF-8 encoded",
        "`/new_tweet` path",
        "over 1024 UTF-8 bytes are rejected before transport",
    ],
    "Wear Listener And Notification": [
        "`com.google.android.gms.wearable.BIND_LISTENER` action",
        "notification detail activity remains internal-only",
        "decodes UTF-8",
        "unexpected path",
        "payload over 1024 bytes",
        "removes its message listener",
    ],
    "iOS TableViewTweetsSwift": [
        "overlapping loads are suppressed",
        "remain set after guest-login success while tweet loading continues",
        "reset on guest-login failure or tweet-load completion",
        "only typed `TWTRTweet` objects",
        "generic diagnostics",
        "known unsafe legacy boundary",
        "without HTTPS/host/userinfo validation",
        "Do not use untrusted fixture URLs or claim navigation is hardened.",
    ],
    "iOS WatchSample": [
        "placeholder Crashlytics demonstration",
        "Do not invoke the `ForceCrash` action",
        "`Crashlytics.sharedInstance().crash()` intentionally",
        "destructive",
    ],
    "Failure, Privacy, And Cleanup": [
        "Keep every failure generic",
        "Do not weaken empty Android manifest placeholders",
        "UTF-8 validation",
        "1024-byte message limit",
        "Rotate any credential",
    ],
    "Evidence Record": [
        "commit SHA",
        "pass/fail/blocked result",
        "Record skipped steps and exact blockers explicitly.",
        "scrubbed of keys/tokens",
        "four separate evidence classes",
    ],
}

sections = {}
current = None
for line in source.splitlines():
    if line.startswith("## "):
        current = line[3:]
        sections[current] = []
    elif current is not None:
        sections[current].append(line)

for heading, phrases in required_sections.items():
    body = "\n".join(sections.get(heading, []))
    if not body:
        raise SystemExit("Sample verification section missing: " + heading)
    normalized_body = " ".join(body.split())
    for phrase in phrases:
        if " ".join(phrase.split()) not in normalized_body:
            raise SystemExit(
                "Sample verification assertion missing from "
                + heading
                + ": "
                + phrase
            )
PY

if ! grep -Fq "status: completed" "$SAMPLE_VERIFICATION_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$SAMPLE_VERIFICATION_PLAN" ||
  ! grep -Fq "verification matrix remains unexecuted" "$SAMPLE_VERIFICATION_PLAN" ||
  ! grep -Fq "bounded exact-head configured-event/CodeQL snapshot" "$SAMPLE_VERIFICATION_PLAN"; then
  printf '%s\n' "Cross-platform sample verification plan must record completed local verification." >&2
  exit 1
fi

if ! grep -Fq "docs/manual-sample-verification.md" "$ROOT_DIR/README.md" ||
  ! grep -Fq "docs/manual-sample-verification.md" "$ROOT_DIR/AGENTS.md" ||
  ! grep -Fq "docs/manual-sample-verification.md" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "without claiming that the matrix has been executed" "$ROOT_DIR/VISION.md" ||
  grep -Fq "Add clearer build and verification notes for each sample app" "$ROOT_DIR/VISION.md" ||
  grep -Fq "Add small checks or manual steps for login/display behavior" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "truthful per-sample Android, Wear, iOS, and watchOS verification matrix" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project guidance must preserve truthful per-sample verification boundaries." >&2
  exit 1
fi

printf '%s\n' "FabricWithTwitter baseline checks passed."
