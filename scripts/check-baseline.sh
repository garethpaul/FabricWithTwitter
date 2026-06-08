#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PLAN="$ROOT_DIR/docs/plans/2026-06-08-fabric-with-twitter-security-baseline.md"

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
  "Android/WearExample/mobile/src/main/AndroidManifest.xml" \
  "Android/WearExample/wear/src/main/AndroidManifest.xml" \
  "iOS/TableViewTweetsSwift/TableViewTweetsSwift.xcodeproj/project.pbxproj" \
  "iOS/WatchSample/WatchSample.xcodeproj/project.pbxproj" \
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

printf '%s\n' "FabricWithTwitter baseline checks passed."
