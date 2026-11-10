import os
from pathlib import Path
import subprocess
import tempfile
import unittest


class BranchDeleteAliasTest(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.env = dict(os.environ, GIT_CONFIG_NOSYSTEM="1")
        self.env["GIT_CONFIG_GLOBAL"] = str(Path(__file__).resolve().parents[1] / ".gitconfig")
        self.git("init", "-q")
        self.git("-c", "user.name=Test", "-c", "user.email=test@example.com",
                 "commit", "--allow-empty", "-qm", "initial")

    def git(self, *args, check=True):
        return subprocess.run(["git", *args], cwd=self.directory.name, env=self.env,
                              text=True, capture_output=True, check=check)

    def branches(self):
        return self.git("branch", "--format=%(refname:short)").stdout.splitlines()

    def test_wildcards_and_multiple_patterns(self):
        for branch in ("feature/one", "feature/two", "bug/one", "keep"):
            self.git("branch", branch)
        self.git("brd", "feature/*", "bug/*")
        self.assertEqual(self.branches(), ["keep", "main"])

    def test_missing_or_unmatched_pattern_preserves_branches(self):
        self.git("branch", "keep")
        for patterns in ((), ("missing/*",)):
            self.assertNotEqual(self.git("brd", *patterns, check=False).returncode, 0)
            self.assertEqual(self.branches(), ["keep", "main"])

    def test_current_branch_marker_does_not_expand_to_filenames(self):
        self.git("branch", "keep")
        Path(self.directory.name, "keep").touch()
        result = self.git("brd", "main", check=False)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.branches(), ["keep", "main"])


if __name__ == "__main__":
    unittest.main()
