#!/usr/bin/env python3

import plistlib
import sys
from pathlib import Path


EXPECTED_FIELDS = {
    ("Fabric", "APIKey"): "$(FABRIC_API_KEY)",
    ("Fabric", "Kits", 0, "KitInfo", "consumerKey"): "$(TWITTER_CONSUMER_KEY)",
    ("Fabric", "Kits", 0, "KitInfo", "consumerSecret"): "$(TWITTER_CONSUMER_SECRET)",
}


def read_path(root: object, path: tuple[object, ...]) -> object:
    current = root
    for component in path:
        if isinstance(component, int):
            if not isinstance(current, list) or component >= len(current):
                raise KeyError
            current = current[component]
        else:
            if not isinstance(current, dict) or component not in current:
                raise KeyError
            current = current[component]
    return current


def main() -> int:
    root = Path(__file__).resolve().parent.parent
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else root / "iOS" / "TableViewTweetsSwift" / "TableViewTweetsSwift" / "Info.plist"

    try:
        with path.open("rb") as handle:
            plist = plistlib.load(handle)
    except (OSError, plistlib.InvalidFileException) as error:
        print(f"Unable to parse credential plist: {error}", file=sys.stderr)
        return 1

    for field_path, expected in EXPECTED_FIELDS.items():
        try:
            actual = read_path(plist, field_path)
        except KeyError:
            print(f"Missing credential placeholder: {'.'.join(map(str, field_path))}", file=sys.stderr)
            return 1
        if actual != expected:
            print(f"Credential field must use its exact inert placeholder: {'.'.join(map(str, field_path))}", file=sys.stderr)
            return 1

    print("Credential plist uses exact inert build-setting placeholders.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
