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
LOCATION_INDEPENDENT_MAKE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-location-independent-make.md"
DEPENDENCY_PIN_PLAN="$ROOT_DIR/docs/plans/2026-06-14-legacy-android-dependency-pins.md"
WEAR_LISTENER_LIFECYCLE_PLAN="$ROOT_DIR/docs/plans/2026-06-14-wear-listener-lifecycle.md"
WEAR_DESTROYED_ACTIVITY_DESIGN="$ROOT_DIR/docs/plans/2026-06-25-wear-destroyed-activity-callback-design.md"
WEAR_DESTROYED_ACTIVITY_PLAN="$ROOT_DIR/docs/plans/2026-06-25-wear-destroyed-activity-callback.md"
WEAR_DESTROYED_NODE_SEND_DESIGN="$ROOT_DIR/docs/plans/2026-06-26-wear-destroyed-node-send-race-design.md"
WEAR_DESTROYED_NODE_SEND_PLAN="$ROOT_DIR/docs/plans/2026-06-26-wear-destroyed-node-send-race.md"
DISPLAY_DESTROYED_CALLBACK_DESIGN="$ROOT_DIR/docs/plans/2026-06-26-display-destroyed-callback-design.md"
DISPLAY_DESTROYED_CALLBACK_PLAN="$ROOT_DIR/docs/plans/2026-06-26-display-destroyed-callback.md"
WEAR_BIDI_CONTROL_DESIGN="$ROOT_DIR/docs/plans/2026-06-26-wear-bidi-control-payload-design.md"
WEAR_BIDI_CONTROL_PLAN="$ROOT_DIR/docs/plans/2026-06-26-wear-bidi-control-payload.md"
WEAR_BIDI_CONTROL_MUTATION="$ROOT_DIR/scripts/test-wear-bidi-control-mutation.sh"
IOS_TWEET_PERMALINK_PLAN="$ROOT_DIR/docs/plans/2026-06-14-ios-tweet-permalink-validation.md"
IOS_TWEET_PERMALINK_HOST_PLAN="$ROOT_DIR/docs/plans/2026-06-15-ios-twitter-permalink-host-boundary.md"
IOS_TWEET_PERMALINK_CHECK="$ROOT_DIR/scripts/check-ios-tweet-permalink.py"
IOS_TWEET_PERMALINK_EXECUTION_PLAN="$ROOT_DIR/docs/plans/2026-06-16-executable-ios-tweet-permalink-policy-tests.md"
IOS_TWEET_PERMALINK_SIGNAL_PLAN="$ROOT_DIR/docs/plans/2026-06-18-ios-tweet-permalink-harness-signal-cleanup.md"
IOS_TWEET_PERMALINK_POLICY="$ROOT_DIR/iOS/TableViewTweetsSwift/TableViewTweetsSwift/TweetPermalinkPolicy.swift"
IOS_TWEET_PERMALINK_RUNNER="$ROOT_DIR/scripts/run-ios-tweet-permalink-policy-tests.sh"
IOS_TWEET_PERMALINK_TEST="$ROOT_DIR/Tests/TweetPermalinkPolicyTests/main.swift"
IOS_TABLE_PROJECT="$ROOT_DIR/iOS/TableViewTweetsSwift/TableViewTweetsSwift.xcodeproj/project.pbxproj"
IOS_TWITTER_MAIN_QUEUE_PLAN="$ROOT_DIR/docs/plans/2026-06-14-ios-twitter-main-queue.md"
SAMPLE_VERIFICATION="$ROOT_DIR/docs/manual-sample-verification.md"
MODERN_ALTERNATIVES_DESIGN="$ROOT_DIR/docs/plans/2026-06-25-modern-platform-alternatives-design.md"
MODERN_ALTERNATIVES_PLAN="$ROOT_DIR/docs/plans/2026-06-25-modern-platform-alternatives.md"
MODERN_ALTERNATIVES_GUIDE="$ROOT_DIR/docs/modern-platform-alternatives.md"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"
CODEOWNERS="$ROOT_DIR/.github/CODEOWNERS"
WEAR_BUILD="$ROOT_DIR/Android/WearExample/build.gradle"
DISPLAY_APP_BUILD="$ROOT_DIR/Android/DisplayTweets/app/build.gradle"
WEAR_MOBILE_BUILD="$ROOT_DIR/Android/WearExample/mobile/build.gradle"
WEAR_APP_BUILD="$ROOT_DIR/Android/WearExample/wear/build.gradle"
DISPLAY_ACTIVITY="$ROOT_DIR/Android/DisplayTweets/app/src/main/java/sample/twitterkit/fabric/twitter/com/twitterkit/MainActivity.java"
WEAR_MOBILE_ACTIVITY="$ROOT_DIR/Android/WearExample/mobile/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/MainActivity.java"
WEAR_LISTENER="$ROOT_DIR/Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/ListenerService.java"
WEAR_POLICY="$ROOT_DIR/Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/WearMessagePolicy.java"
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
  ".gitleaks.toml" \
  ".gitignore" \
  ".github/CODEOWNERS" \
  ".github/workflows/check.yml" \
  "CHANGES.md" \
  "docs/credential-incident-response.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "Config/LocalSecrets.xcconfig.example" \
  "scripts/install-gitleaks.sh" \
  "scripts/check-gradle-wrapper-provenance.py" \
  "scripts/test-gradle-wrapper-provenance.py" \
  "scripts/run-wear-message-policy-tests.sh" \
  "scripts/test-wear-bidi-control-mutation.sh" \
  "Tests/WearMessagePolicyTests.java" \
  "Android/DisplayTweets/app/src/main/AndroidManifest.xml" \
  "Android/DisplayTweets/app/build.gradle" \
  "Android/DisplayTweets/app/src/main/java/sample/twitterkit/fabric/twitter/com/twitterkit/MainActivity.java" \
  "Android/WearExample/build.gradle" \
  "Android/WearExample/mobile/build.gradle" \
  "Android/WearExample/mobile/src/main/AndroidManifest.xml" \
  "Android/WearExample/mobile/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/MainActivity.java" \
  "Android/WearExample/wear/src/main/AndroidManifest.xml" \
  "Android/WearExample/wear/build.gradle" \
  "Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/ListenerService.java" \
  "Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/WearMessagePolicy.java" \
  "Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/NotificationActivity.java" \
  "iOS/TableViewTweetsSwift/TableViewTweetsSwift.xcodeproj/project.pbxproj" \
  "iOS/TableViewTweetsSwift/TableViewTweetsSwift/TweetPermalinkPolicy.swift" \
  "iOS/TableViewTweetsSwift/TableViewTweetsSwift/Info.plist" \
  "iOS/TableViewTweetsSwift/TableViewTweetsSwift/ViewController.swift" \
  "iOS/WatchSample/WatchSample.xcodeproj/project.pbxproj" \
  "docs/manual-sample-verification.md" \
  "docs/modern-platform-alternatives.md" \
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
  "docs/plans/2026-06-13-location-independent-make.md" \
  "docs/plans/2026-06-14-legacy-android-dependency-pins.md" \
  "docs/plans/2026-06-14-wear-listener-lifecycle.md" \
  "docs/plans/2026-06-25-wear-destroyed-activity-callback-design.md" \
  "docs/plans/2026-06-25-wear-destroyed-activity-callback.md" \
  "docs/plans/2026-06-26-wear-destroyed-node-send-race-design.md" \
  "docs/plans/2026-06-26-wear-destroyed-node-send-race.md" \
  "docs/plans/2026-06-26-display-destroyed-callback-design.md" \
  "docs/plans/2026-06-26-display-destroyed-callback.md" \
  "docs/plans/2026-06-26-wear-bidi-control-payload-design.md" \
  "docs/plans/2026-06-26-wear-bidi-control-payload.md" \
  "docs/plans/2026-06-14-ios-tweet-permalink-validation.md" \
  "docs/plans/2026-06-15-ios-twitter-permalink-host-boundary.md" \
  "docs/plans/2026-06-16-executable-ios-tweet-permalink-policy-tests.md" \
  "docs/plans/2026-06-18-ios-tweet-permalink-harness-signal-cleanup.md" \
  "docs/plans/2026-06-25-ios-tweet-permalink-ascii-path-design.md" \
  "docs/plans/2026-06-25-ios-tweet-permalink-ascii-path.md" \
  "docs/plans/2026-06-25-modern-platform-alternatives-design.md" \
  "docs/plans/2026-06-25-modern-platform-alternatives.md" \
  "scripts/check-ios-tweet-permalink.py" \
  "scripts/run-ios-tweet-permalink-policy-tests.sh" \
  "Tests/TweetPermalinkPolicyTests/main.swift" \
  "docs/plans/2026-06-14-ios-twitter-main-queue.md" \
  "docs/plans/2026-06-09-wear-notification-text-view-guard.md" \
  "docs/plans/2026-06-09-wear-tweet-payload-guard.md" \
  "docs/plans/2026-06-09-wear-tweet-view-container-guard.md" \
  "docs/plans/2026-06-08-wear-message-utf8-decoding.md" \
  "docs/plans/2026-06-08-fabric-with-twitter-security-baseline.md"; do
  require_file "$path"
done

python3 - "$DISPLAY_ACTIVITY" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
required = (
    "private volatile boolean activityDestroyed;",
    "if (activityDestroyed) {",
    'Log.d(TAG, "Skipping tweet callback for destroyed activity");',
    "activityDestroyed = true;",
    "protected void onDestroy()",
)
for contract in required:
    if contract not in source:
        raise SystemExit("DisplayTweets destroyed-activity guard missing: " + contract)

callback = source.split("public void success(List<Tweet> tweets)", 1)[1].split(
    "public void failure(TwitterException exception)", 1
)[0]
guards = [
    index for index in range(len(callback))
    if callback.startswith("if (activityDestroyed)", index)
]
loop = callback.find("for (Tweet tweet : tweets)")
view = callback.find("new CompactTweetView")
if len(guards) < 2 or not (guards[0] < loop < guards[1] < view):
    raise SystemExit("DisplayTweets callback must guard before iteration and activity-backed view creation")

destroy = source.split("protected void onDestroy()", 1)[1].split(
    "public boolean onCreateOptionsMenu", 1
)[0]
destroyed = destroy.find("activityDestroyed = true;")
super_destroy = destroy.find("super.onDestroy()")
if min(destroyed, super_destroy) < 0 or destroyed > super_destroy:
    raise SystemExit("DisplayTweets must publish destruction before superclass teardown")
PY

for modern_alternative_contract in \
  "Firebase Crashlytics" \
  "https://firebase.google.com/docs/crashlytics/get-started" \
  "OAuth 2.0 Authorization Code Flow with PKCE" \
  "https://docs.x.com/fundamentals/authentication/oauth-2-0/authorization-code" \
  "X API v2" \
  "https://docs.x.com/x-api/posts/lookup/introduction" \
  "https://docs.x.com/x-api/users/lookup/introduction" \
  "Wear OS Data Layer" \
  "https://developer.android.com/training/wearables/data/overview" \
  "does not migrate the historical samples" \
  "Staged Migration" \
  "Validation Gates"; do
  if ! grep -Fq "$modern_alternative_contract" "$MODERN_ALTERNATIVES_GUIDE"; then
    printf '%s\n' "Modern alternatives guide must retain: $modern_alternative_contract" >&2
    exit 1
  fi
done

if ! grep -Fq "status: approved" "$MODERN_ALTERNATIVES_DESIGN" ||
  ! grep -Fq "status: completed" "$MODERN_ALTERNATIVES_PLAN" ||
  ! grep -Fq "docs/modern-platform-alternatives.md" "$ROOT_DIR/README.md" ||
  ! grep -Fq "docs/modern-platform-alternatives.md" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "docs/modern-platform-alternatives.md" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "docs/modern-platform-alternatives.md" "$ROOT_DIR/AGENTS.md" ||
  ! grep -Fq "Documented modern alternatives" "$ROOT_DIR/CHANGES.md" ||
  grep -Fq -- "- Document modern alternatives to Fabric/TwitterKit" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "Modern alternatives documentation and repository guidance must stay synchronized." >&2
  exit 1
fi

for document in "$ROOT_DIR/README.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/CHANGES.md" "$ROOT_DIR/AGENTS.md" "$SAMPLE_VERIFICATION"; do
  if ! grep -Eq "ASCII handles|Unicode handle lookalikes" "$document"; then
    printf '%s\n' "$document must document the ASCII iOS tweet permalink path boundary." >&2
    exit 1
  fi
done

python3 "$IOS_TWEET_PERMALINK_CHECK" \
  "$IOS_TWEET_PERMALINK_POLICY" \
  "$IOS_TABLE_VIEW"

python3 - "$IOS_TABLE_PROJECT" "$ROOT_DIR/Makefile" "$IOS_TWEET_PERMALINK_RUNNER" "$IOS_TWEET_PERMALINK_TEST" <<'PY'
from pathlib import Path
import re
import sys

project, makefile, runner, tests = (Path(path).read_text(encoding="utf-8") for path in sys.argv[1:])
if project.count("TweetPermalinkPolicy.swift in Sources") != 2:
    raise SystemExit("TweetPermalinkPolicy must belong to the iOS app target once")
if project.count("/* TweetPermalinkPolicy.swift */") != 3:
    raise SystemExit("TweetPermalinkPolicy project references must remain complete and unique")
if makefile.count("scripts/run-ios-tweet-permalink-policy-tests.sh") != 1:
    raise SystemExit("Make check must execute the iOS permalink policy runner once")
for path in (
    "iOS/TableViewTweetsSwift/TableViewTweetsSwift/TweetPermalinkPolicy.swift",
    "Tests/TweetPermalinkPolicyTests/main.swift",
):
    if path not in runner:
        raise SystemExit("Policy runner missing production or test input: " + path)
signal_handler = re.compile(
    r'''handle_signal\(\) \{\s*'''
    r'''status=\$1\s*'''
    r'''trap - 0 1 2 15\s*'''
    r'''cleanup\s*'''
    r'''exit "\$status"\s*'''
    r'''\}'''
)
if not signal_handler.search(runner):
    raise SystemExit("iOS permalink runner signals must clean temporary output before exiting")
for signal, status in ((1, 129), (2, 130), (15, 143)):
    binding = f"trap 'handle_signal {status}' {signal}"
    if runner.count(binding) != 1:
        raise SystemExit(f"iOS permalink runner must retain signal binding: {binding}")
for value in (
    "https://twitter.com/example/status/1",
    "https://www.x.com/example/status/1#context",
    "https://TWITTER.COM/example/status/1",
    "http://twitter.com/example/status/1",
    "https://user:password@twitter.com/example/status/1",
    "https://twitter.com:8443/example/status/1",
    "https://twitter.com.evil.example/status/1",
    "https://evil-twitter.com/example/status/1",
    "https:///example/status/1",
    "https://twitter.com/examplе/status/1",
    "https://twitter.com/example/status/١",
):
    if value not in tests:
        raise SystemExit("Executable permalink matrix missing: " + value)
PY

for signal_cleanup_plan_contract in \
  "status: completed" \
  'exit-only signal traps leave `ios-tweet-permalink-policy-tests.*` behind' \
  "## Verification Completed" \
  "937c91a17e010ab47b811c4a194d7f299843a769" \
  'Pull-request run `27746955355` completed successfully' \
  "status 42" \
  '`TERM` binding were rejected'; do
  if ! grep -Fq "$signal_cleanup_plan_contract" "$IOS_TWEET_PERMALINK_SIGNAL_PLAN"; then
    printf '%s\n' "iOS permalink harness signal-cleanup plan must retain evidence: $signal_cleanup_plan_contract" >&2
    exit 1
  fi
done

python3 - "$IOS_TWEET_PERMALINK_EXECUTION_PLAN" <<'PY'
from pathlib import Path
import re
import sys

plan = Path(sys.argv[1]).read_text(encoding="utf-8")
frontmatter = plan.split("---", 2)[1]
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "all four Make gates passed",
    "absolute Makefile path passed",
    "production policy mutation failed",
    "navigation delegation mutation failed",
    "Xcode target membership mutation failed",
    "accepted URL mutation failed",
    "hostile URL mutation failed",
    "plan evidence mutation failed",
    "Pull-request run `27645791177` passed",
    "`2474a31b4c0fd31d56f03eff37a4b34c5e204e69`",
)
if (
    re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE) != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run|not yet)\b", verification, re.IGNORECASE)
):
    raise SystemExit("Executable iOS permalink test plan must retain completed evidence")
PY

if ! grep -Fq "credential-free HTTPS permalink" "$ROOT_DIR/README.md" ||
  ! grep -Fq "credential-free HTTPS permalink" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "credential-free HTTPS permalink" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "credential-free HTTPS permalink" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "credential-free HTTPS permalink" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must preserve validated iOS tweet navigation." >&2
  exit 1
fi

for document in "$ROOT_DIR/README.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/CHANGES.md" "$ROOT_DIR/AGENTS.md" "$SAMPLE_VERIFICATION"; do
  if ! grep -Fq "canonical Twitter and X hosts with no explicit port" "$document"; then
    printf '%s\n' "$document must document the canonical iOS tweet permalink host boundary." >&2
    exit 1
  fi
done

if ! grep -Fq 'override ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))' "$ROOT_DIR/Makefile" ||
  ! grep -Fq '"$(ROOT)/scripts/check-baseline.sh"' "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile verification must protect the loaded Makefile root from overrides." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCATION_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "from /tmp" "$LOCATION_INDEPENDENT_MAKE_PLAN"; then
  printf '%s\n' "Location-independent Fabric sample plan must record completed external verification." >&2
  exit 1
fi

if ! grep -Fq "absolute Makefile path" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Make verification resolves repository paths" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "External baseline" "$ROOT_DIR/AGENTS.md" ||
  ! grep -Fq "Made Make verification independent" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project guidance must document location-independent verification." >&2
  exit 1
fi

if ! grep -Fq 'WearMessagePolicy.pendingIntentFlags(Build.VERSION.SDK_INT)' "$WEAR_LISTENER" ||
  ! grep -Fq 'FLAG_UPDATE_CURRENT | FLAG_IMMUTABLE' "$WEAR_POLICY" ||
  ! grep -Fq 'if (sdkInt >= 23)' "$WEAR_POLICY" ||
  ! grep -Fq 'viewIntent.putExtra(NotificationActivity.TWEET_KEY, tweet)' "$WEAR_LISTENER"; then
  printf '%s\n' "Wear notification PendingIntent must refresh the latest tweet and be immutable where supported." >&2
  exit 1
fi

python3 "$ROOT_DIR/scripts/test-credential-boundary.py"
python3 "$ROOT_DIR/scripts/test-gradle-wrapper-provenance.py"

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

python3 - "$DISPLAY_APP_BUILD" "$WEAR_MOBILE_BUILD" "$WEAR_APP_BUILD" "$ROOT_DIR/Android" <<'PY'
import re
import sys
from pathlib import Path

paths = [Path(value) for value in sys.argv[1:4]]
android_root = Path(sys.argv[4])
sources = {path: path.read_text(encoding="utf-8") for path in paths}
coordinate = re.compile(r"(?:classpath|compile)\s*\(?\s*[\"']([^\"']+)[\"']")
for path in sorted(android_root.rglob("build.gradle")):
    source = path.read_text(encoding="utf-8")
    for value in coordinate.findall(source):
        parts = value.split(":")
        if len(parts) < 3:
            continue
        version = parts[-1].strip().lower()
        if "+" in version or "latest" in version or version.startswith("[") or version.startswith("("):
            raise SystemExit("Dynamic Android dependency selector remains in %s" % path)

display = sources[paths[0]]
mobile = sources[paths[1]]
wear = sources[paths[2]]
if display.count("io.fabric.tools:gradle:1.14.4") != 1:
    raise SystemExit("DisplayTweets must pin the Fabric Gradle plugin to 1.14.4")
if mobile.count("io.fabric.tools:gradle:1.14.4") != 1 or wear.count("io.fabric.tools:gradle:1.14.4") != 1:
    raise SystemExit("Both Wear modules must pin the Fabric Gradle plugin to 1.14.4")
if mobile.count("com.google.android.gms:play-services-wearable:6.1.71") != 1:
    raise SystemExit("Wear mobile must pin the wearable-only Play Services artifact to 6.1.71")
if "com.google.android.gms:play-services:" in mobile:
    raise SystemExit("Wear mobile must not restore the full Play Services bundle")
if wear.count("com.google.android.gms:play-services-wearable:6.1.71") != 1:
    raise SystemExit("Wear app must retain Play Services wearable 6.1.71")
if wear.count("com.android.support:support-v4:20.0.0") != 1:
    raise SystemExit("Wear app must pin support-v4 to 20.0.0")
PY

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
  ! grep -Fq "messageClient, node.getId(), path, tweetPayload);" "$WEAR_MOBILE_ACTIVITY" ||
  ! grep -Fq "MessageApi.SendMessageResult result = pendingResult.await();" "$WEAR_MOBILE_ACTIVITY" ||
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
  ! grep -Fq "WearMessagePolicy.decodeTweetPayload(messageData)" "$WEAR_LISTENER" ||
  grep -Fq "new String(messageData, UTF_8)" "$WEAR_LISTENER" ||
  ! grep -Fq 'Log.e(TAG, "Ignoring invalid wear tweet payload")' "$WEAR_LISTENER"; then
  printf '%s\n' "Wear listener must guard message path and payload before notification display." >&2
  exit 1
fi

if [ "$(grep -Fc "private static final int MAX_TWEET_PAYLOAD_BYTES = 1024;" "$WEAR_POLICY")" -ne 1 ] ||
  ! grep -Fq "messageData.length > MAX_TWEET_PAYLOAD_BYTES" "$WEAR_POLICY" ||
  ! grep -Fq "containsUnsupportedControlCharacter(normalized)" "$WEAR_POLICY"; then
  printf '%s\n' "Wear policy must enforce byte, Unicode-whitespace, and control-character boundaries." >&2
  exit 1
fi

for bidi_contract in \
  "containsBidiControlCharacter(normalized)" \
  "codePoint == 0x061C" \
  "codePoint >= 0x200E && codePoint <= 0x200F" \
  "codePoint >= 0x202A && codePoint <= 0x202E" \
  "codePoint >= 0x2066 && codePoint <= 0x2069" \
  "Character.charCount(codePoint)"; do
  if ! grep -Fq "$bidi_contract" "$WEAR_POLICY"; then
    printf '%s\n' "Wear policy must reject the Unicode Bidi_Control set: $bidi_contract" >&2
    exit 1
  fi
done
for bidi_test_contract in \
  'expectRejected("hello\u061cworld"' \
  'expectRejected("hello\u200eworld"' \
  'expectRejected("hello\u202eworld"' \
  'expectRejected("hello\u2066world"' \
  'expectText("hello\u200dworld", "hello\u200dworld"'; do
  if ! grep -Fq "$bidi_test_contract" "$ROOT_DIR/Tests/WearMessagePolicyTests.java"; then
    printf '%s\n' "Wear bidi-control behavioral coverage is missing: $bidi_test_contract" >&2
    exit 1
  fi
done
if [ ! -x "$WEAR_BIDI_CONTROL_MUTATION" ] || \
  [ "$(grep -Fc '$(ROOT)/scripts/test-wear-bidi-control-mutation.sh' "$ROOT_DIR/Makefile")" -ne 1 ]; then
  printf '%s\n' "Wear bidi-control mutation test must be executable and run exactly once." >&2
  exit 1
fi
for bidi_document in AGENTS.md README.md SECURITY.md VISION.md CHANGES.md; do
  if ! grep -Fq "Wear tweet payloads reject Unicode bidi controls while preserving zero-width-joiner text" "$ROOT_DIR/$bidi_document"; then
    printf '%s\n' "$bidi_document must document Wear bidi-control rejection." >&2
    exit 1
  fi
done
if ! grep -Fq "**Status:** Completed" "$WEAR_BIDI_CONTROL_PLAN" || \
  ! grep -Fq "Wear bidi-control mutation was rejected" "$WEAR_BIDI_CONTROL_PLAN" || \
  ! grep -Fq "Live Wear notification rendering was not exercised locally" "$WEAR_BIDI_CONTROL_PLAN" || \
  ! grep -Fq 'Reject only the Unicode `Bidi_Control` property set' "$WEAR_BIDI_CONTROL_DESIGN"; then
  printf '%s\n' "Wear bidi-control plans must retain the design and completed verification evidence." >&2
  exit 1
fi

python3 - "$WEAR_MOBILE_ACTIVITY" "$WEAR_LISTENER" "$WEAR_POLICY" <<'PY'
import re
import sys
from pathlib import Path

sender = Path(sys.argv[1]).read_text()
listener = Path(sys.argv[2]).read_text()
policy = Path(sys.argv[3]).read_text()

constant = re.compile(r"private static final int MAX_TWEET_PAYLOAD_BYTES = (\d+);")
sender_limits = constant.findall(sender)
policy_limits = constant.findall(policy)
if sender_limits != ["1024"] or policy_limits != sender_limits:
    raise SystemExit("Wear payload limits must be single, equal 1024-byte constants.")

sender_contract = (
    "final String safeTweetText = tweetText.trim();",
    "final byte[] tweetPayload = safeTweetText.getBytes(UTF_8);",
    "tweetPayload.length > MAX_TWEET_PAYLOAD_BYTES",
    "new Thread(new Runnable()",
    "messageClient, node.getId(), path, tweetPayload);",
    "MessageApi.SendMessageResult result = pendingResult.await();",
)
listener_contract = (
    "messageData == null || messageData.length == 0",
    "WearMessagePolicy.decodeTweetPayload(messageData)",
    "tweet == null",
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

python3 - "$WEAR_LISTENER" "$WEAR_POLICY" <<'PY'
import pathlib
import sys

listener = pathlib.Path(sys.argv[1]).read_text()
policy = pathlib.Path(sys.argv[2]).read_text()
required = (
    "UTF_8.newDecoder()",
    ".onMalformedInput(CodingErrorAction.REPORT)",
    ".onUnmappableCharacter(CodingErrorAction.REPORT)",
    "decoder.decode(ByteBuffer.wrap(messageData)).toString()",
    "catch (CharacterCodingException exception)",
    "trimUnicodeWhitespace(decoded)",
    "containsUnsupportedControlCharacter(normalized)",
)
if any(item not in policy for item in required):
    raise SystemExit("Wear policy must reject malformed UTF-8 and unsafe display controls")

decode = listener.find("WearMessagePolicy.decodeTweetPayload(messageData)")
decode_failure = listener.find("if (tweet == null)", decode)
intent = listener.find("new Intent(this, NotificationActivity.class)", decode_failure)
notify = listener.find("notificationManager.notify", intent)
if -1 in (decode, decode_failure, intent, notify) or not (
    decode < decode_failure < intent < notify
):
    raise SystemExit("Strict UTF-8 decoding must precede notification construction and display")
PY

if grep -Eq 'Log\.[a-z]+\([^;]*messageEvent\.getPath\(\)' "$WEAR_LISTENER"; then
  printf '%s\n' "Wear listener must not log raw incoming message paths." >&2
  exit 1
fi

if ! grep -Fq "NotificationActivity.TWEET_KEY" "$WEAR_LISTENER"; then
  printf '%s\n' "Wear listener must use the shared notification extra key." >&2
  exit 1
fi

python3 - "$WEAR_LISTENER" <<'PY'
import pathlib
import sys

source = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
required = (
    "class ListenerService extends WearableListenerService",
    "public void onMessageReceived( final MessageEvent messageEvent )",
)
forbidden = (
    "GoogleApiClient",
    "Wearable.MessageApi",
    ".addListener(",
    ".removeListener(",
    "client.connect()",
    "client.disconnect()",
    "public void onCreate()",
    "public void onDestroy()",
)
if any(fragment not in source for fragment in required):
    raise SystemExit("Wear listener must retain framework-managed background delivery")
if source.count("public void onMessageReceived(") != 1:
    raise SystemExit("Wear listener must define exactly one message callback")
if any(fragment in source for fragment in forbidden):
    raise SystemExit("WearableListenerService must not register a parallel message listener")
PY

if ! grep -Fq "status: completed" "$WEAR_LISTENER_LIFECYCLE_PLAN" ||
  ! grep -Fq "four isolated hostile mutations were rejected" "$WEAR_LISTENER_LIFECYCLE_PLAN" ||
  ! grep -Fq "xcodebuild was unavailable" "$WEAR_LISTENER_LIFECYCLE_PLAN" ||
  ! grep -Fq "No Twitter or Fabric credentials" "$WEAR_LISTENER_LIFECYCLE_PLAN"; then
  printf '%s\n' "Wear listener lifecycle plan must record completed local verification." >&2
  exit 1
fi

if ! grep -Fq "sole background delivery path" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq 'must not register a parallel `GoogleApiClient` message listener' "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "framework-managed background delivery" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "WearableListenerService owns background message delivery" "$ROOT_DIR/AGENTS.md" ||
  ! grep -Fq "parallel GoogleApiClient listener registration" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Wear listener lifecycle guidance must remain synchronized." >&2
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

python3 - "$WEAR_MOBILE_ACTIVITY" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
required = (
    "private volatile boolean activityDestroyed;",
    "private final Object activityLifecycleLock = new Object();",
    "if (activityDestroyed) {",
    'Log.d(TAG, "Skipping login callback for destroyed activity");',
    'Log.d(TAG, "Skipping tweet callback for destroyed activity");',
    'Log.d(TAG, "Skipping wear message for destroyed activity");',
    "activityDestroyed = true;",
)
for contract in required:
    if contract not in source:
        raise SystemExit("Wear mobile destroyed-activity guard missing: " + contract)

login_callback = source.split("public void success(Result<TwitterSession> result)", 1)[1].split(
    "public void failure(TwitterException exception)", 1
)[0]
login_guards = [
    index for index in range(len(login_callback))
    if login_callback.startswith("if (activityDestroyed)", index)
]
login_load = login_callback.find("loadTweets()")
login_ui = login_callback.find("loginButton.setVisibility")
if len(login_guards) < 2 or not (login_guards[0] < login_load < login_guards[1] < login_ui):
    raise SystemExit("Wear login callback must guard both request and UI publication")

tweet_callback = source.split("public void success(Tweet tweet)", 1)[1].split(
    "public void failure(TwitterException e)", 1
)[0]
tweet_guards = [
    index for index in range(len(tweet_callback))
    if tweet_callback.startswith("if (activityDestroyed)", index)
]
tweet_send = tweet_callback.find("sendMessage(PATH")
tweet_ui = tweet_callback.find("findViewById(R.id.tweet_view)")
if len(tweet_guards) < 2 or not (tweet_guards[0] < tweet_send < tweet_guards[1] < tweet_ui):
    raise SystemExit("Wear tweet callback must guard both delivery and UI publication")

send_message = source.split("private void sendMessage", 1)[1].split(
    "new Thread(new Runnable()", 1
)[0]
if send_message.find("if (activityDestroyed)") > send_message.find("tweetText.trim()"):
    raise SystemExit("Wear message dispatch must reject destroyed activity before payload work")

worker = source.split("new Thread(new Runnable()", 1)[1].split("}).start();", 1)[0]
preconnect = worker.find("if (activityDestroyed)")
connect = worker.find("blockingConnect()")
postconnect = worker.find("if (activityDestroyed)", preconnect + 1)
disconnect = worker.find("messageClient.disconnect()", postconnect)
nodes = worker.find("getConnectedNodes", disconnect)
postnodes = worker.find("if (activityDestroyed)", postconnect + 1)
node_loop = worker.find("for (Node node", nodes)
send_lock = worker.find("synchronized (activityLifecycleLock)", node_loop)
presend = worker.find("if (activityDestroyed)", send_lock)
send = worker.find("Wearable.MessageApi.sendMessage", node_loop)
if min(preconnect, connect, postconnect, disconnect, nodes, postnodes, node_loop, send_lock, presend, send) < 0 or not (
    preconnect < connect < postconnect < disconnect < nodes < postnodes < node_loop < send_lock < presend < send
):
    raise SystemExit("Wear message worker must atomically reject destruction before reconnect, after node lookup, and before each send")

destroy = source.split("protected void onDestroy()", 1)[1].split("public boolean onCreateOptionsMenu", 1)[0]
destroy_lock = destroy.find("synchronized (activityLifecycleLock)")
destroyed = destroy.find("activityDestroyed = true;")
client_disconnect = destroy.find("client.disconnect()")
super_destroy = destroy.find("super.onDestroy()")
if min(destroy_lock, destroyed, client_disconnect, super_destroy) < 0 or not (
    destroy_lock < destroyed < client_disconnect < super_destroy
):
    raise SystemExit("Wear activity must atomically publish destruction before disconnect and superclass teardown")
PY

for lifecycle_plan in \
  "$WEAR_DESTROYED_ACTIVITY_DESIGN" \
  "$WEAR_DESTROYED_ACTIVITY_PLAN" \
  "$WEAR_DESTROYED_NODE_SEND_DESIGN" \
  "$WEAR_DESTROYED_NODE_SEND_PLAN"; do
  if ! grep -Fq "destroyed" "$lifecycle_plan"; then
    printf '%s\n' "Wear destroyed-activity lifecycle plans must retain their ownership boundary." >&2
    exit 1
  fi
done

for lifecycle_document in "$ROOT_DIR/README.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/AGENTS.md" "$SAMPLE_VERIFICATION"; do
  if ! grep -Eq "destroyed|destruction" "$lifecycle_document"; then
    printf '%s\n' "$lifecycle_document must document the Wear mobile destroyed-activity boundary." >&2
    exit 1
  fi
done

if ! grep -Fq "status: approved" "$DISPLAY_DESTROYED_CALLBACK_DESIGN" ||
  ! grep -Fq "status: completed" "$DISPLAY_DESTROYED_CALLBACK_PLAN" ||
  ! grep -Fq "per-item" "$DISPLAY_DESTROYED_CALLBACK_PLAN"; then
  printf '%s\n' "DisplayTweets destroyed-callback plans must preserve completed lifecycle evidence." >&2
  exit 1
fi

for display_lifecycle_document in "$ROOT_DIR/README.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/AGENTS.md" "$SAMPLE_VERIFICATION" "$ROOT_DIR/CHANGES.md"; do
  normalized_display_lifecycle=$(tr '\n' ' ' < "$display_lifecycle_document")
  if ! printf '%s\n' "$normalized_display_lifecycle" | grep -Eq "DisplayTweets.*(destroyed|destruction)"; then
    printf '%s\n' "$display_lifecycle_document must document the DisplayTweets destroyed-activity boundary." >&2
    exit 1
  fi
done

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

python3 - "$IOS_TABLE_VIEW" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
load = source.split("    func loadTweets()", 1)[1].split("    func refreshInvoked()", 1)[0]
contracts = (
    "logInGuestWithCompletion",
    "dispatch_async(dispatch_get_main_queue())",
    "if session == nil",
    "self.isLoadingTweets = false",
    "loadTweetsWithIDs(tweetIDs)",
    "dispatch_async(dispatch_get_main_queue())",
    "self.isLoadingTweets = false",
    "if let loadedTweetObjects = twttrs",
    "self.tweets = loadedTweets",
)
positions = []
start = 0
for contract in contracts:
    position = load.find(contract, start)
    positions.append(position)
    start = position + len(contract) if position != -1 else start
if -1 in positions:
    raise SystemExit("iOS TwitterKit callback state and table publication must remain on the main queue")
if load.count("dispatch_async(dispatch_get_main_queue())") != 2:
    raise SystemExit("iOS Twitter loading must keep exactly two callback main-queue boundaries")
PY

if ! grep -Fq "status: completed" "$IOS_TWITTER_MAIN_QUEUE_PLAN" ||
  ! grep -Fq "make check" "$IOS_TWITTER_MAIN_QUEUE_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$IOS_TWITTER_MAIN_QUEUE_PLAN"; then
  printf '%s\n' "iOS Twitter main-queue plan must record completed verification." >&2
  exit 1
fi

for document in "$ROOT_DIR/README.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/CHANGES.md" "$ROOT_DIR/AGENTS.md"; do
  if ! grep -Fq "on the main queue" "$document"; then
    printf '%s\n' "$document must document iOS Twitter main-queue publication." >&2
    exit 1
  fi
done

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

if ! grep -Fq "status: completed" "$DEPENDENCY_PIN_PLAN" ||
  ! grep -Fq "make check" "$DEPENDENCY_PIN_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$DEPENDENCY_PIN_PLAN"; then
  printf '%s\n' "Legacy Android dependency pin plan must record completed verification." >&2
  exit 1
fi

for document in "$ROOT_DIR/README.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/CHANGES.md" "$ROOT_DIR/AGENTS.md"; do
  if ! grep -Fq "legacy dependency pins" "$document"; then
    printf '%s\n' "$document must document the legacy dependency pins." >&2
    exit 1
  fi
done

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
  ! grep -Eq '^[[:space:]]*run: \|[[:space:]]*$' "$CI_WORKFLOW" ||
  ! grep -Fq 'scripts/install-gitleaks.sh "$RUNNER_TEMP/gitleaks-bin"' "$CI_WORKFLOW" ||
  ! grep -Fq 'PATH="$RUNNER_TEMP/gitleaks-bin:$PATH" make security' "$CI_WORKFLOW" ||
  grep -Eq 'continue-on-error:[[:space:]]*true|if:[[:space:]]*false' "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions must install pinned Gitleaks and run the required security gate without bypasses." >&2
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
        "credential-free HTTPS permalink",
        "HTTP, hostless, and credential-bearing permalinks",
        "do not create a request or navigate",
        "generic rejection message",
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
