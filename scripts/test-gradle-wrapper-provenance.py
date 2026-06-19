#!/usr/bin/env python3

import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
CHECKER = ROOT / "scripts" / "check-gradle-wrapper-provenance.py"
PROJECT = ROOT / "Android" / "DisplayTweets"


class GradleWrapperProvenanceTests(unittest.TestCase):
    def run_checker(self, project: Path) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, str(CHECKER), str(project)],
            cwd=ROOT,
            check=False,
            capture_output=True,
            text=True,
        )

    def copy_project(self) -> tuple[tempfile.TemporaryDirectory[str], Path]:
        directory = tempfile.TemporaryDirectory()
        project = Path(directory.name) / "project"
        shutil.copytree(PROJECT / "gradle", project / "gradle")
        return directory, project

    def test_reviewed_wrappers_are_accepted(self) -> None:
        result = subprocess.run(
            [sys.executable, str(CHECKER)], cwd=ROOT, check=False, capture_output=True, text=True
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_modified_wrapper_is_rejected(self) -> None:
        directory, project = self.copy_project()
        self.addCleanup(directory.cleanup)
        wrapper = project / "gradle" / "wrapper" / "gradle-wrapper.jar"
        wrapper.write_bytes(wrapper.read_bytes() + b"mutation")
        self.assertNotEqual(self.run_checker(project).returncode, 0)

    def test_distribution_drift_is_rejected(self) -> None:
        directory, project = self.copy_project()
        self.addCleanup(directory.cleanup)
        properties = project / "gradle" / "wrapper" / "gradle-wrapper.properties"
        properties.write_text(
            properties.read_text().replace("gradle-2.1-all.zip", "gradle-2.2-all.zip")
        )
        self.assertNotEqual(self.run_checker(project).returncode, 0)


if __name__ == "__main__":
    unittest.main()
