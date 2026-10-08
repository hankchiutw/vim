import os
from pathlib import Path
import subprocess
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]


class ConfigInstallTest(unittest.TestCase):
    def test_fresh_install_and_rerun_from_other_directory(self):
        with tempfile.TemporaryDirectory(prefix="vim install ") as home:
            env = dict(os.environ, HOME=home, XDG_CONFIG_HOME=f"{home}/config")
            for _ in range(2):
                result = subprocess.run(["sh", str(REPO / "install_nvim.sh")],
                                        cwd=home, env=env, capture_output=True, text=True)
                self.assertEqual(result.returncode, 0, result.stderr)
            config = Path(env["XDG_CONFIG_HOME"]) / "nvim"
            for name in ("init.lua", "lua", "plugin"):
                self.assertEqual((config / name).resolve(), REPO / name)
            self.assertFalse((config / "init.vim").exists())

    def test_migrate_only_repository_owned_legacy_link(self):
        with tempfile.TemporaryDirectory() as home:
            config = Path(home) / ".config/nvim"
            config.mkdir(parents=True)
            legacy = config / "init.vim"
            legacy.symlink_to(REPO / "init.vim")
            env = dict(os.environ, HOME=home, XDG_CONFIG_HOME=f"{home}/.config")
            result = subprocess.run(["sh", str(REPO / "install_nvim.sh")],
                                    env=env, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertFalse(legacy.is_symlink())
            legacy.write_text("my config")
            result = subprocess.run(["sh", str(REPO / "install_nvim.sh")],
                                    env=env, capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(legacy.read_text(), "my config")

    def test_conflict_does_not_replace_user_directory(self):
        with tempfile.TemporaryDirectory() as home:
            config = Path(home) / ".config/nvim"
            (config / "lua").mkdir(parents=True)
            marker = config / "lua/user.lua"
            marker.write_text("keep")
            env = dict(os.environ, HOME=home, XDG_CONFIG_HOME=f"{home}/.config")
            result = subprocess.run(["sh", str(REPO / "install_nvim.sh")],
                                    env=env, capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(marker.read_text(), "keep")
            self.assertFalse((config / "init.lua").exists())


if __name__ == "__main__":
    unittest.main()
