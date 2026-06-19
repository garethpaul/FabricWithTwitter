#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
JAVAC=${JAVAC:-javac}
JAVA=${JAVA:-java}
SOURCE="$ROOT_DIR/Android/WearExample/wear/src/main/java/samples/twitterkit/fabric/twitter/com/wearexample/WearMessagePolicy.java"
TEST="$ROOT_DIR/Tests/WearMessagePolicyTests.java"
OUTPUT_DIR=$(mktemp -d "${TMPDIR:-/tmp}/wear-message-policy-tests.XXXXXX")
trap 'rm -rf "$OUTPUT_DIR"' EXIT HUP INT TERM
COMPILER_LOG="$OUTPUT_DIR/javac.log"

if ! "$JAVAC" -source 7 -target 7 -d "$OUTPUT_DIR" "$SOURCE" "$TEST" 2>"$COMPILER_LOG"; then
    if grep -Eq '(Source|Target) option 7 is no longer supported' "$COMPILER_LOG"; then
        rm -rf "$OUTPUT_DIR/classes"
        mkdir -p "$OUTPUT_DIR/classes"
        "$JAVAC" -source 8 -target 8 -d "$OUTPUT_DIR/classes" "$SOURCE" "$TEST"
        OUTPUT_DIR="$OUTPUT_DIR/classes"
    else
        cat "$COMPILER_LOG" >&2
        exit 1
    fi
else
    cat "$COMPILER_LOG" >&2
fi
"$JAVA" -cp "$OUTPUT_DIR" samples.twitterkit.fabric.twitter.com.wearexample.WearMessagePolicyTests
