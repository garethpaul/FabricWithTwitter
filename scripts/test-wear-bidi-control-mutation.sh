#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
JAVAC=${JAVAC:-javac}
JAVA=${JAVA:-java}
TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/wear-bidi-control-mutation.XXXXXX")
trap 'rm -rf "$TEMP_DIR"' EXIT HUP INT TERM
SOURCE_DIR="$TEMP_DIR/samples/twitterkit/fabric/twitter/com/wearexample"
mkdir -p "$SOURCE_DIR"

cp "$ROOT_DIR/Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/WearMessagePolicy.java" \
  "$ROOT_DIR/Tests/WearMessagePolicyTests.java" \
  "$SOURCE_DIR/"
perl -0pi -e 's/[[:space:]]*\|\| containsBidiControlCharacter\(normalized\)//' \
  "$SOURCE_DIR/WearMessagePolicy.java"

COMPILER_LOG="$TEMP_DIR/javac.log"
OUTPUT_DIR="$TEMP_DIR/classes"
mkdir -p "$OUTPUT_DIR"
if ! "$JAVAC" -source 7 -target 7 -d "$OUTPUT_DIR" \
  "$SOURCE_DIR/WearMessagePolicy.java" "$SOURCE_DIR/WearMessagePolicyTests.java" \
  2>"$COMPILER_LOG"; then
  if grep -Eq '(Source|Target) option 7 is no longer supported' "$COMPILER_LOG"; then
    "$JAVAC" -source 8 -target 8 -d "$OUTPUT_DIR" \
      "$SOURCE_DIR/WearMessagePolicy.java" "$SOURCE_DIR/WearMessagePolicyTests.java"
  else
    cat "$COMPILER_LOG" >&2
    exit 1
  fi
fi

if "$JAVA" -cp "$OUTPUT_DIR" \
  samples.twitterkit.fabric.twitter.com.wearexample.WearMessagePolicyTests \
  >"$TEMP_DIR/test.log" 2>&1; then
  printf '%s\n' "Bidi-control mutation survived" >&2
  exit 1
fi
if ! grep -Fq "expected rejection" "$TEMP_DIR/test.log"; then
  cat "$TEMP_DIR/test.log" >&2
  printf '%s\n' "Bidi-control mutation failed outside the expected assertion" >&2
  exit 1
fi

printf '%s\n' "Wear bidi-control mutation was rejected"
