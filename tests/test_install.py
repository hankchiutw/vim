import os
from pathlib import Path
import subprocess
import shutil
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
            legacy.symlink_to(os.path.relpath(REPO / "init.vim", config))
            for name in ("lua", "plugin"):
                (config / name).symlink_to(os.path.relpath(REPO / name, config))
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


class SetupTest(unittest.TestCase):
    def run_setup(self, home, system="Linux", manager="apt-get", failure=""):
        home = Path(home)
        tools = home / "bin"
        tools.mkdir(exist_ok=True)
        for name in ("sh", "dirname", "ln", "mkdir", "rm"):
            link = tools / name
            if not link.exists():
                link.symlink_to(shutil.which(name))
        log = home / "commands"
        for command in ("uname", "id", "sudo", manager, "npm", "nvim",
                        "git", "curl", "make", "pip", "brew", "fisher", "vim"):
            stub = tools / command
            stub.write_text(
                '#!/bin/sh\n'
                'printf "%s %s\\n" "${0##*/}" "$*" >> "$AUDIT_LOG"\n'
                'case "${0##*/}" in\n'
                'uname) echo "$AUDIT_OS";;\n'
                'id) echo 1000;;\n'
                'sudo) exec "$@";;\n'
                'git|curl|make|pip|fisher|vim) exit 99;;\n'
                '*) [ "${0##*/}" != "$AUDIT_FAILURE" ];;\n'
                'esac\n'
            )
            stub.chmod(0o755)
        env = dict(os.environ, HOME=str(home), XDG_CONFIG_HOME=f"{home}/.config",
                   PATH=str(tools), AUDIT_LOG=str(log),
                   AUDIT_OS=system, AUDIT_FAILURE=failure)
        result = subprocess.run(["sh", str(REPO / "install.sh")], cwd=home,
                                env=env, capture_output=True, text=True, timeout=10)
        return result, log.read_text() if log.exists() else ""

    def test_linux_and_macos_use_only_their_package_manager(self):
        for system, manager in (("Linux", "apt-get"), ("Linux", "dnf"),
                                ("Linux", "pacman"), ("Darwin", "brew")):
            with self.subTest(system=system), tempfile.TemporaryDirectory() as home:
                for _ in range(2):
                    result, log = self.run_setup(home, system, manager)
                    self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn(f"{manager} " + ("-S" if manager == "pacman" else "install"), log)
                self.assertNotIn("brew" if system == "Linux" else "apt-get", log)
                self.assertIn("npm install --global --prefix", log)
                self.assertNotIn("typescript-language-server", log)
                self.assertEqual((Path(home) / ".ctags.d/default.ctags").resolve(),
                                 REPO / "default.ctags")

    def test_failed_packages_stop_before_linking_and_npm(self):
        with tempfile.TemporaryDirectory() as home:
            result, log = self.run_setup(home, failure="apt-get")
            self.assertNotEqual(result.returncode, 0)
            self.assertNotIn("npm install", log)
            self.assertFalse((Path(home) / ".config/nvim/init.lua").exists())

    def test_old_neovim_stops_with_upgrade_instructions(self):
        with tempfile.TemporaryDirectory() as home:
            result, log = self.run_setup(home, failure="nvim")
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("Neovim 0.11", result.stderr)
            self.assertNotIn("npm install", log)

    def test_custom_dotfile_blocks_package_installation(self):
        with tempfile.TemporaryDirectory() as home:
            config = Path(home) / ".gitconfig"
            config.write_text("my identity")
            result, log = self.run_setup(home)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(log, "")
            self.assertEqual(config.read_text(), "my identity")


if __name__ == "__main__":
    unittest.main()
