#!/usr/bin/env python3

import hashlib
import sys
import zipfile
from pathlib import Path


EXPECTED_WRAPPER_SHA256 = "1536b22ab3c5e3217504351beca0de09a8a8092c83385989e9700d1b1c56ee4f"
EXPECTED_DISTRIBUTION_URL = "https\\://services.gradle.org/distributions/gradle-2.1-all.zip"
EXPECTED_DISTRIBUTION_SHA256 = "b351ab27da6e06a74ba290213638b6597f2175f5071e6f96a0a205806720cb81"
EXPECTED_SOURCE = "https://github.com/gradle/gradle/tree/v2.1/gradle/wrapper"


def verify(project: Path) -> None:
    wrapper = project / "gradle" / "wrapper" / "gradle-wrapper.jar"
    properties = project / "gradle" / "wrapper" / "gradle-wrapper.properties"
    digest = hashlib.sha256(wrapper.read_bytes()).hexdigest()
    if digest != EXPECTED_WRAPPER_SHA256:
        raise SystemExit(f"Unverified Gradle wrapper JAR: {project}")

    with zipfile.ZipFile(wrapper) as archive:
        receipt = archive.read("build-receipt.properties").decode("utf-8")
    if "versionBase=2.1" not in receipt or "commitId=66d7c0087c2859d2e6379c811766c131884cc6f2" not in receipt:
        raise SystemExit(f"Gradle wrapper build receipt is not the reviewed v2.1 source artifact: {project}")

    source = properties.read_text(encoding="utf-8")
    if f"distributionUrl={EXPECTED_DISTRIBUTION_URL}" not in source:
        raise SystemExit(f"Gradle wrapper distribution URL drifted: {project}")


def main() -> None:
    root = Path(__file__).resolve().parent.parent
    projects = [Path(value) for value in sys.argv[1:]] or [
        root / "Android" / "DisplayTweets",
        root / "Android" / "WearExample",
    ]
    for project in projects:
        verify(project)
    print(
        "Gradle wrapper JARs match the reviewed v2.1 source artifact; "
        f"verify downloaded gradle-2.1-all.zip against {EXPECTED_DISTRIBUTION_SHA256} before execution. "
        f"Source: {EXPECTED_SOURCE}"
    )


if __name__ == "__main__":
    main()
