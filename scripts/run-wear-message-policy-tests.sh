#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
JAVAC=${JAVAC:-javac}
JAVA=${JAVA:-java}
SOURCE="$ROOT_DIR/Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/WearMessagePolicy.java"
TEST="$ROOT_DIR/Tests/WearMessagePolicyTests.java"
OUTPUT_DIR=$(mktemp -d "${TMPDIR:-/tmp}/wear-message-policy-tests.XXXXXX")
trap 'rm -rf "$OUTPUT_DIR"' EXIT HUP INT TERM

"$JAVAC" -source 7 -target 7 -d "$OUTPUT_DIR" "$SOURCE" "$TEST"
"$JAVA" -cp "$OUTPUT_DIR" samples.twitterkit.fabric.twitter.com.wearexample.WearMessagePolicyTests
