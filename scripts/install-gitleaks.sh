#!/usr/bin/env sh
set -eu

VERSION="8.30.1"
DESTINATION=${1:?usage: install-gitleaks.sh DESTINATION_DIRECTORY}

case "$(uname -s):$(uname -m)" in
  Darwin:arm64)
    ARCHIVE="gitleaks_${VERSION}_darwin_arm64.tar.gz"
    CHECKSUM="b40ab0ae55c505963e365f271a8d3846efbc170aa17f2607f13df610a9aeb6a5"
    ;;
  Darwin:x86_64)
    ARCHIVE="gitleaks_${VERSION}_darwin_x64.tar.gz"
    CHECKSUM="dfe101a4db2255fc85120ac7f3d25e4342c3c20cf749f2c20a18081af1952709"
    ;;
  *)
    printf '%s\n' "Unsupported Gitleaks installer platform: $(uname -s) $(uname -m)" >&2
    exit 1
    ;;
esac

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT HUP INT TERM

curl --proto '=https' --tlsv1.2 --fail --location --silent --show-error \
  "https://github.com/gitleaks/gitleaks/releases/download/v${VERSION}/${ARCHIVE}" \
  --output "$TEMP_DIR/$ARCHIVE"

printf '%s  %s\n' "$CHECKSUM" "$TEMP_DIR/$ARCHIVE" | shasum -a 256 -c - >/dev/null
tar -xzf "$TEMP_DIR/$ARCHIVE" -C "$TEMP_DIR" gitleaks
mkdir -p "$DESTINATION"
install -m 0755 "$TEMP_DIR/gitleaks" "$DESTINATION/gitleaks"
