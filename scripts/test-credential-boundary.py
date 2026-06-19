#!/usr/bin/env python3

import copy
import plistlib
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
CHECKER = ROOT / "scripts" / "check-credential-boundary.py"
PLIST = ROOT / "iOS" / "TableViewTweetsSwift" / "TableViewTweetsSwift" / "Info.plist"
EXAMPLE_CONFIG = ROOT / "Config" / "LocalSecrets.xcconfig.example"
GITLEAKS_CONFIG = ROOT / ".gitleaks.toml"
GITLEAKS_INSTALLER = ROOT / "scripts" / "install-gitleaks.sh"
INCIDENT_RESPONSE = ROOT / "docs" / "credential-incident-response.md"


def run_checker(path: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(CHECKER), str(path)],
        cwd=ROOT,
        check=False,
        capture_output=True,
        text=True,
    )


class CredentialBoundaryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        with PLIST.open("rb") as handle:
            cls.plist = plistlib.load(handle)

    def write_fixture(self, data: dict) -> Path:
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        path = Path(directory.name) / "Info.plist"
        with path.open("wb") as handle:
            plistlib.dump(data, handle)
        return path

    def assert_rejected(self, data: dict) -> None:
        result = run_checker(self.write_fixture(data))
        self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_repository_plist_uses_exact_inert_placeholders(self) -> None:
        result = run_checker(PLIST)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_literal_fabric_api_key_is_rejected(self) -> None:
        data = copy.deepcopy(self.plist)
        data["Fabric"]["APIKey"] = "fixture-fabric-api-key"
        self.assert_rejected(data)

    def test_literal_twitter_consumer_key_is_rejected(self) -> None:
        data = copy.deepcopy(self.plist)
        data["Fabric"]["Kits"][0]["KitInfo"]["consumerKey"] = "fixture-consumer-key"
        self.assert_rejected(data)

    def test_literal_twitter_consumer_secret_is_rejected(self) -> None:
        data = copy.deepcopy(self.plist)
        data["Fabric"]["Kits"][0]["KitInfo"]["consumerSecret"] = "fixture-consumer-secret"
        self.assert_rejected(data)

    def test_missing_sensitive_field_is_rejected(self) -> None:
        data = copy.deepcopy(self.plist)
        del data["Fabric"]["Kits"][0]["KitInfo"]["consumerSecret"]
        self.assert_rejected(data)

    def test_empty_sensitive_field_is_rejected(self) -> None:
        data = copy.deepcopy(self.plist)
        data["Fabric"]["APIKey"] = ""
        self.assert_rejected(data)

    def test_alternate_placeholder_is_rejected(self) -> None:
        data = copy.deepcopy(self.plist)
        data["Fabric"]["APIKey"] = "${FABRIC_API_KEY}"
        self.assert_rejected(data)

    def test_local_config_example_contains_only_empty_assignments(self) -> None:
        self.assertEqual(
            EXAMPLE_CONFIG.read_text().splitlines(),
            [
                "FABRIC_API_KEY =",
                "TWITTER_CONSUMER_KEY =",
                "TWITTER_CONSUMER_SECRET =",
            ],
        )

    def test_local_config_is_ignored(self) -> None:
        result = subprocess.run(
            ["git", "check-ignore", "Config/LocalSecrets.xcconfig"],
            cwd=ROOT,
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_incident_response_requires_provider_revocation(self) -> None:
        source = INCIDENT_RESPONSE.read_text()
        normalized = " ".join(source.split())
        self.assertIn("fa70307f25c152c9958262b36a159393de5aff3d", source)
        self.assertIn("6dd16a067a57ca8a74c33b1870bca40e1406ff26", source)
        self.assertIn("Treat all four historical values as publicly disclosed", normalized)
        self.assertIn("Revoke the exposed Fabric API key/build secret and Twitter consumer key/secret", normalized)
        self.assertIn("cannot revoke copied credentials", normalized)

    def run_gitleaks(self, path: Path) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [
                "gitleaks",
                "dir",
                "--no-banner",
                "--no-color",
                "--redact=100",
                "--report-format",
                "json",
                "--report-path",
                "-",
                "--config",
                str(GITLEAKS_CONFIG),
                str(path),
            ],
            cwd=ROOT,
            check=False,
            capture_output=True,
            text=True,
        )

    @unittest.skipUnless(shutil.which("gitleaks"), "gitleaks is not installed")
    def test_gitleaks_accepts_inert_plist_placeholders(self) -> None:
        result = self.run_gitleaks(PLIST)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    @unittest.skipUnless(shutil.which("gitleaks"), "gitleaks is not installed")
    def test_gitleaks_rejects_synthetic_plist_credentials(self) -> None:
        data = copy.deepcopy(self.plist)
        data["Fabric"]["APIKey"] = "synthetic" + "A" * 32
        data["Fabric"]["Kits"][0]["KitInfo"]["consumerKey"] = "synthetic" + "B" * 24
        data["Fabric"]["Kits"][0]["KitInfo"]["consumerSecret"] = "synthetic" + "C" * 48
        result = self.run_gitleaks(self.write_fixture(data))
        self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("fabric-twitter-plist-credential", result.stdout + result.stderr)

    def test_baseline_runs_credential_boundary_tests(self) -> None:
        baseline = (ROOT / "scripts" / "check-baseline.sh").read_text()
        self.assertIn('python3 "$ROOT_DIR/scripts/test-credential-boundary.py"', baseline)

    def test_security_target_requires_gitleaks(self) -> None:
        makefile = (ROOT / "Makefile").read_text()
        self.assertIn("ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))", makefile)
        self.assertIn('"$(ROOT)/scripts/check-baseline.sh"', makefile)
        self.assertIn("security: check", makefile)
        self.assertIn("command -v gitleaks", makefile)
        self.assertIn('cd "$(ROOT)" && gitleaks dir', makefile)
        self.assertIn('--config "$(ROOT)/.gitleaks.toml" .', makefile)

    def test_ci_installer_is_version_and_checksum_pinned(self) -> None:
        installer = GITLEAKS_INSTALLER.read_text()
        self.assertIn('VERSION="8.30.1"', installer)
        self.assertIn("b40ab0ae55c505963e365f271a8d3846efbc170aa17f2607f13df610a9aeb6a5", installer)
        self.assertIn("dfe101a4db2255fc85120ac7f3d25e4342c3c20cf749f2c20a18081af1952709", installer)
        self.assertIn("shasum -a 256 -c", installer)

    def test_ci_runs_required_gitleaks_gate(self) -> None:
        workflow = (ROOT / ".github" / "workflows" / "check.yml").read_text()
        self.assertIn('scripts/install-gitleaks.sh "$RUNNER_TEMP/gitleaks-bin"', workflow)
        self.assertIn('PATH="$RUNNER_TEMP/gitleaks-bin:$PATH" make security', workflow)


if __name__ == "__main__":
    unittest.main()
