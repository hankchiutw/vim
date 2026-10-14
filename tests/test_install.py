import os
from pathlib import Path
import subprocess
import shutil
import tempfile
import unittest
import venv


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
    def test_install_scripts_parse_in_system_shells(self):
        for shell in ("sh", "bash"):
            for name in ("install.sh", "install_nvim.sh", "install_common.sh"):
                with self.subTest(shell=shell, script=name):
                    result = subprocess.run([shell, "-n", str(REPO / name)],
                                            capture_output=True, text=True)
                    self.assertEqual(result.returncode, 0, result.stderr)

    def run_setup(self, home, system="Linux", manager="apt-get", failure="", missing="", packages=False, arch="x86_64"):
        home = Path(home)
        tools = home / "bin"
        tools.mkdir(exist_ok=True)
        for name in ("sh", "bash", "dirname", "ln", "mkdir", "rm", "mktemp", "chmod", "sed", "head", "cp", "install"):
            link = tools / name
            if not link.exists():
                link.symlink_to(shutil.which(name))
        log = home / "commands"
        for command in ("uname", "id", "sudo", manager, "node", "npm", "nvim", "uv",
                        "git", "curl", "make", "pip", "brew", "fisher", "vim", "fish", "python3", "go", "jq", "unzip"):
            if command == missing:
                continue
            stub = tools / command
            stub.write_text(
                '#!/bin/sh\n'
                'printf "%s %s\\n" "${0##*/}" "$*" >> "$AUDIT_LOG"\n'
                'case "${0##*/}" in\n'
                'uname) if [ "$1" = -m ]; then echo "$AUDIT_ARCH"; else echo "$AUDIT_OS"; fi;;\n'
                'id) echo 1000;;\n'
                'sudo) exec "$@";;\n'
                'brew|apt-get|dnf|pacman) '
                '[ "${0##*/}" != "$AUDIT_FAILURE" ] || exit 1; '
                'case "$*" in '
                '*" fnm") [ "$AUDIT_PACKAGES" = yes ] || exit 1; '
                'cp "$HOME/bin/curl" "$HOME/bin/fnm";; '
                '*" herdr") [ "$AUDIT_PACKAGES" = yes ] || exit 1; '
                'cp "$HOME/bin/curl" "$HOME/bin/herdr";; '
                '*" worktrunk") [ "$AUDIT_PACKAGES" = yes ] || exit 1; '
                'cp "$HOME/bin/curl" "$HOME/bin/wt";; '
                '*" lazygit"|*" yazi") [ "$AUDIT_PACKAGES" = yes ] || exit 1; '
                'for arg do tool="$arg"; done; cp "$HOME/bin/curl" "$HOME/bin/$tool";; '
                '*" docker.io"|*" docker-cli"|*" docker"|*" docker-desktop") '
                'cp "$HOME/bin/curl" "$HOME/bin/docker";; '
                '*" go"|*" golang"|*" golang-go") cp "$HOME/bin/curl" "$HOME/bin/go";; '
                '*" uv") [ "$AUDIT_PACKAGES" = yes ] || exit 1; '
                'cp "$HOME/bin/curl" "$HOME/bin/uv"; chmod +x "$HOME/bin/uv";; '
                'esac;;\n'
                'uv) printf "uv-tools-bin %s\\n" "$UV_TOOL_BIN_DIR" >> "$AUDIT_LOG"; '
                '[ "$AUDIT_FAILURE" != uv ];;\n'
                'fnm) [ "$AUDIT_FAILURE" != fnm ];;\n'
                'go) [ "$AUDIT_FAILURE" != lazygit-install ] || exit 1; '
                '[ "$GOBIN" = "$HOME/.local/bin" ] || exit 1; '
                'mkdir -p "$GOBIN"; cp "$HOME/bin/curl" "$GOBIN/lazygit";;\n'
                'unzip) [ "$AUDIT_FAILURE" != yazi-unzip ] || exit 1; '
                'read -r target < "$2"; target="${target%.zip}"; '
                'mkdir -p "$4/$target"; '
                'cp "$HOME/bin/curl" "$4/$target/yazi"; cp "$HOME/bin/curl" "$4/$target/ya";;\n'
                'herdr) [ "$AUDIT_FAILURE" != "$2:$4" ];;\n'
                'curl) [ "$AUDIT_FAILURE" != curl ] || exit 1; '
                'if [ "$2" = https://astral.sh/uv/install.sh ]; then '
                '[ "$AUDIT_FAILURE" != uv-download ] || exit 1; '
                'printf "%s\\n" \'[ "$AUDIT_FAILURE" != uv-install ] || exit 1\' '
                '\'[ "$UV_NO_MODIFY_PATH" = 1 ] || exit 1\' '
                '\'mkdir -p "$UV_INSTALL_DIR"\' '
                '\'cp "$HOME/bin/curl" "$UV_INSTALL_DIR/uv"\' '
                '\'chmod +x "$UV_INSTALL_DIR/uv"\' > "$4"; '
                'elif [ "$2" = https://herdr.dev/install.sh ]; then '
                '[ "$AUDIT_FAILURE" != herdr-download ] || exit 1; '
                'printf "%s\\n" \'[ "$AUDIT_FAILURE" != herdr-install ] || exit 1\' '
                '\'mkdir -p "$HERDR_INSTALL_DIR"\' '
                '\'cp "$HOME/bin/curl" "$HERDR_INSTALL_DIR/herdr"\' '
                '\'chmod +x "$HERDR_INSTALL_DIR/herdr"\' > "$4"; '
                'elif [ "$2" = https://github.com/max-sixty/worktrunk/releases/latest/download/worktrunk-installer.sh ]; then '
                '[ "$AUDIT_FAILURE" != worktrunk-download ] || exit 1; '
                'printf "%s\\n" \'[ "$AUDIT_FAILURE" != worktrunk-install ] || exit 1\' '
                '\'[ "$WORKTRUNK_NO_MODIFY_PATH" = 1 ] || exit 1\' '
                '\'mkdir -p "$WORKTRUNK_INSTALL_DIR"\' '
                '\'cp "$HOME/bin/curl" "$WORKTRUNK_INSTALL_DIR/wt"\' '
                '\'chmod +x "$WORKTRUNK_INSTALL_DIR/wt"\' > "$4"; '
                'elif [ "${2#https://github.com/sxyazi/yazi/releases/latest/download/}" != "$2" ]; then '
                '[ "$AUDIT_FAILURE" != yazi-download ] || exit 1; '
                'printf "%s\\n" "${2##*/}" > "$4"; '
                'else [ "$2" = https://fnm.vercel.app/install ] || exit 99; '
                '[ "$AUDIT_FAILURE" != fnm-download ] || exit 1; '
                'printf "%s\\n" \'[ "$AUDIT_FAILURE" != fnm-install ] || exit 1\' '
                '\'[ "$2" = "$HOME/.local/bin" ] && [ "$3" = --skip-shell ] && [ "$4" = --force-install ] || exit 1\' '
                '\'mkdir -p "$HOME/.local/bin"\' '
                '\'cp "$HOME/bin/curl" "$HOME/.local/bin/fnm"\' > "$4"; fi;;\n'
                'git|make|pip|fisher|vim) exit 99;;\n'
                '*) [ "${0##*/}" != "$AUDIT_FAILURE" ];;\n'
                'esac\n'
            )
            stub.chmod(0o755)
        env = dict(os.environ, HOME=str(home), XDG_CONFIG_HOME=f"{home}/.config",
                   HERDR_CONFIG_PATH=f"{home}/.config/herdr/config.toml",
                   PATH=str(tools), AUDIT_LOG=str(log),
                   AUDIT_OS=system, AUDIT_ARCH=arch, AUDIT_FAILURE=failure, NVM_DIR=f"{home}/.nvm",
                   TMPDIR=str(home), NODE_VERSION="must-not-be-installed",
                   AUDIT_PACKAGES="yes" if packages else "no")
        result = subprocess.run(["sh", str(REPO / "install.sh")], cwd=home,
                                env=env, capture_output=True, text=True, timeout=10)
        return result, log.read_text() if log.exists() else ""

    def test_linux_and_macos_use_only_their_package_manager(self):
        for system, manager in (("Linux", "apt-get"), ("Linux", "dnf"),
                                ("Linux", "pacman"), ("Darwin", "brew")):
            with self.subTest(system=system), tempfile.TemporaryDirectory(prefix="kitty install ") as home:
                for _ in range(2):
                    result, log = self.run_setup(home, system, manager)
                    self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn(f"{manager} " + ("-S" if manager == "pacman" else "install"), log)
                self.assertNotIn("brew" if system == "Linux" else "apt-get", log)
                self.assertIn("npm install --global --prefix", log)
                self.assertEqual(log.count("https://fnm.vercel.app/install"), 1)
                self.assertEqual(log.count("https://herdr.dev/install.sh"), 1)
                self.assertEqual(log.count("worktrunk-installer.sh"), 1)
                for plugin in ("kryptamine/herdr-auto-title", "devashish2203/herdr-worktrunk"):
                    self.assertEqual(log.count(f"herdr plugin install --yes {plugin}\n"), 2)
                self.assertTrue(os.access(Path(home) / ".local/bin/herdr", os.X_OK))
                self.assertFalse((Path(home) / ".nvm").exists())
                for tool in ("black", "isort", "ruff"):
                    self.assertEqual(log.count(f"uv tool install {tool}\n"), 2)
                self.assertIn(f"uv-tools-bin {home}/.local/bin\n", log)
                for line in log.splitlines():
                    if line.startswith(f"{manager} "):
                        self.assertTrue({"node", "nodejs", "npm", "python", "python3", "python3-venv"}.isdisjoint(line.split()), line)
                self.assertNotIn("typescript-language-server", log)
                self.assertNotIn("colordiff", log)
                self.assertNotIn("ctags", log)
                self.assertFalse((Path(home) / ".colordiffrc").exists())
                self.assertFalse((Path(home) / ".ctags.d").exists())
                self.assertEqual((Path(home) / ".config/kitty/kitty.conf").resolve(),
                                 REPO / "kitty.conf")
                self.assertEqual((Path(home) / ".config/herdr/config.toml").resolve(),
                                 REPO / "herdr_config/config.toml")
                self.assertIn("herdr plugin action invoke herdr.auto-title.restart", result.stdout)
                self.assertNotIn("--ref", result.stdout)
                self.assertIn("brew install --cask kitty" if system == "Darwin" else " kitty", log)

    def test_custom_kitty_config_blocks_install_and_stays_intact(self):
        with tempfile.TemporaryDirectory() as home:
            config = Path(home) / ".config/kitty/kitty.conf"
            config.parent.mkdir(parents=True)
            config.write_text("my terminal")
            result, log = self.run_setup(home)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(log, "")
            self.assertEqual(config.read_text(), "my terminal")

    def test_custom_herdr_config_blocks_install_and_stays_intact(self):
        with tempfile.TemporaryDirectory() as home:
            config = Path(home) / ".config/herdr/config.toml"
            config.parent.mkdir(parents=True)
            config.write_text("my Herdr")
            result, log = self.run_setup(home)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(log, "")
            self.assertEqual(config.read_text(), "my Herdr")

    def test_native_fnm_packages_avoid_curl(self):
        for system, manager in (("Linux", "apt-get"), ("Linux", "dnf"),
                                ("Linux", "pacman"), ("Darwin", "brew")):
            with self.subTest(manager=manager), tempfile.TemporaryDirectory() as home:
                for _ in range(2):
                    result, log = self.run_setup(home, system, manager, packages=True)
                    self.assertEqual(result.returncode, 0, result.stderr)
                self.assertNotIn("nvm/v0.40.8/install.sh", log)
                self.assertNotIn("https://herdr.dev/install.sh", log)
                self.assertNotIn("worktrunk-installer.sh", log)
                self.assertNotIn("https://fnm.vercel.app/install", log)
                self.assertTrue(os.access(Path(home) / "bin/herdr", os.X_OK))

    def test_missing_node_or_npm_bootstraps_fnm_without_installing_node(self):
        for system, manager in (("Linux", "apt-get"), ("Linux", "dnf"),
                                ("Linux", "pacman"), ("Darwin", "brew")):
            for command in ("node", "npm"):
                with self.subTest(system=system, manager=manager, missing=command), \
                        tempfile.TemporaryDirectory() as home:
                    result, log = self.run_setup(home, system, manager, missing=command)
                    self.assertNotEqual(result.returncode, 0)
                    self.assertIn("https://github.com/Schniz/fnm", result.stderr)
                    self.assertIn("fnm install --lts", result.stderr)
                    self.assertIn("curl -fsSL ", log)
                    self.assertTrue((Path(home) / ".local/bin/fnm").exists())
                    self.assertNotIn("fnm install", log)
                    self.assertNotIn("npm install", log)
                    self.assertNotIn("uv tool install", log)
                    self.assertFalse((Path(home) / ".config/nvim/init.lua").exists())

    def test_existing_nvm_is_not_downloaded_or_replaced(self):
        with tempfile.TemporaryDirectory() as home:
            nvm = Path(home) / ".nvm/nvm.sh"
            nvm.parent.mkdir()
            nvm.write_text("my nvm")
            result, log = self.run_setup(home)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertNotIn("nvm/v0.40.8/install.sh", log)
            self.assertEqual(nvm.read_text(), "my nvm")
            self.assertIn(f"uv run --no-project python {REPO}/migrate_nvm.py", log)

    def test_failed_migration_stops_before_tools_and_config_links(self):
        with tempfile.TemporaryDirectory() as home:
            (Path(home) / ".nvm").mkdir()
            result, log = self.run_setup(home, failure="uv")
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("migrate_nvm.py", log)
            self.assertNotIn("npm install", log)
            self.assertFalse((Path(home) / ".config/nvim/init.lua").exists())

    def test_failed_fnm_bootstrap_stops_and_cleans_temp_file(self):
        for failure in ("fnm-download", "fnm-install"):
            with self.subTest(failure=failure), tempfile.TemporaryDirectory() as home:
                result, log = self.run_setup(home, failure=failure)
                self.assertNotEqual(result.returncode, 0)
                self.assertNotIn("npm install", log)
                self.assertFalse(list(Path(home).glob("fnm-install.*")))

    def test_existing_fnm_and_bass_files_are_preserved(self):
        with tempfile.TemporaryDirectory() as home:
            binary = Path(home) / ".local/bin/fnm"
            binary.parent.mkdir(parents=True)
            binary.write_text("#!/bin/sh\nexit 0\n# existing fnm\n")
            binary.chmod(0o755)
            bass = Path(home) / ".config/fish/functions/bass.fish"
            bass.parent.mkdir(parents=True)
            bass.write_text("my bass")
            result, log = self.run_setup(home)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertNotIn("https://fnm.vercel.app/install", log)
            self.assertEqual(bass.read_text(), "my bass")
            self.assertIn("# existing fnm", binary.read_text())
            self.assertNotIn("uv python install", log)
            self.assertNotIn("edc/bass", log)

    def test_existing_herdr_is_preserved(self):
        with tempfile.TemporaryDirectory() as home:
            binary = Path(home) / ".local/bin/herdr"
            binary.parent.mkdir(parents=True)
            binary.write_text("#!/bin/sh\nexit 0\n# my install\n")
            binary.chmod(0o755)
            result, log = self.run_setup(home)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertNotIn("https://herdr.dev/install.sh", log)
            self.assertIn("# my install", binary.read_text())

    def test_failed_herdr_install_stops_before_linking_and_cleans_temp_file(self):
        for failure in ("herdr-download", "herdr-install"):
            with self.subTest(failure=failure), tempfile.TemporaryDirectory() as home:
                result, log = self.run_setup(home, failure=failure)
                self.assertNotEqual(result.returncode, 0)
                self.assertNotIn("+Lazy! sync", log)
                self.assertFalse((Path(home) / ".config/nvim/init.lua").exists())
                self.assertFalse(list(Path(home).glob("herdr-install.*")))

    def test_existing_worktrunk_is_preserved(self):
        with tempfile.TemporaryDirectory() as home:
            binary = Path(home) / ".local/bin/wt"
            binary.parent.mkdir(parents=True)
            binary.write_text("#!/bin/sh\nexit 0\n# my worktrunk\n")
            binary.chmod(0o755)
            result, log = self.run_setup(home)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertNotIn("worktrunk-installer.sh", log)
            self.assertNotIn("install -y --no-install-recommends worktrunk", log)
            self.assertIn("# my worktrunk", binary.read_text())

    def test_docker_lazygit_yazi_install_and_survive_rerun(self):
        for system, manager, docker in (("Linux", "apt-get", "docker.io"),
                                       ("Linux", "dnf", "docker-cli"),
                                       ("Linux", "pacman", "docker"),
                                       ("Darwin", "brew", "docker-desktop")):
            for packages in (False, True):
                for arch in ("x86_64", "arm64"):
                    with self.subTest(manager=manager, packages=packages, arch=arch), tempfile.TemporaryDirectory() as home:
                        for _ in range(2):
                            result, log = self.run_setup(home, system, manager, packages=packages, arch=arch)
                            self.assertEqual(result.returncode, 0, result.stderr)
                        self.assertEqual(sum(line.startswith(f"{manager} ") and line.endswith(f" {docker}")
                                             for line in log.splitlines()), 1)
                        if manager == "dnf":
                            self.assertIn("dnf install -y moby-engine", log)
                        if manager == "brew":
                            self.assertIn("brew install --cask docker-desktop", log)
                        self.assertEqual(log.count("go install github.com/jesseduffield/lazygit@latest"), 0 if packages else 1)
                        self.assertEqual(log.count("https://github.com/sxyazi/yazi/releases/latest/download/"), 0 if packages else 1)
                        location = Path(home) / ("bin" if packages else ".local/bin")
                        for command in ("lazygit", "yazi"):
                            self.assertTrue(os.access(location / command, os.X_OK))
                        if not packages:
                            target = ("aarch64" if arch == "arm64" else arch) + (
                                "-apple-darwin" if system == "Darwin" else "-unknown-linux-musl")
                            self.assertIn(f"yazi-{target}.zip", log)
                            self.assertTrue(os.access(location / "ya", os.X_OK))
                        self.assertFalse(list(Path(home).glob("yazi-install.*")))

    def test_failed_lazygit_yazi_bootstrap_stops_and_cleans_stage(self):
        for failure in ("lazygit-install", "yazi-download", "yazi-unzip"):
            with self.subTest(failure=failure), tempfile.TemporaryDirectory() as home:
                result, log = self.run_setup(home, failure=failure)
                self.assertNotEqual(result.returncode, 0)
                self.assertNotIn("+Lazy! sync", log)
                self.assertFalse((Path(home) / ".config/nvim/init.lua").exists())
                self.assertFalse(list(Path(home).glob("yazi-install.*")))

    def test_unsupported_yazi_fallback_arch_stops_before_download(self):
        with tempfile.TemporaryDirectory() as home:
            result, log = self.run_setup(home, arch="riscv64")
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("x86_64 and arm64", result.stderr)
            self.assertNotIn("https://github.com/sxyazi/yazi", log)

    def test_plugin_dependencies_use_native_package_names(self):
        for system, manager, go_package in (("Linux", "apt-get", "golang-go"),
                                           ("Linux", "dnf", "golang"),
                                           ("Linux", "pacman", "go"),
                                           ("Darwin", "brew", "go")):
            for command in ("go", "jq"):
                with self.subTest(manager=manager, command=command), tempfile.TemporaryDirectory() as home:
                    result, log = self.run_setup(home, system, manager, missing=command)
                    self.assertEqual(result.returncode, 0, result.stderr)
                    package = go_package if command == "go" else "jq"
                    lines = log.splitlines()
                    install = next(i for i, line in enumerate(lines)
                                   if line.startswith(f"{manager} ") and line.endswith(f" {package}"))
                    plugin = lines.index("herdr plugin install --yes kryptamine/herdr-auto-title")
                    self.assertLess(install, plugin)

    def test_failed_worktrunk_or_plugins_stop_before_linking(self):
        for failure in ("worktrunk-download", "worktrunk-install",
                        "install:kryptamine/herdr-auto-title", "install:devashish2203/herdr-worktrunk"):
            with self.subTest(failure=failure), tempfile.TemporaryDirectory() as home:
                result, log = self.run_setup(home, failure=failure)
                self.assertNotEqual(result.returncode, 0)
                self.assertNotIn("+Lazy! sync", log)
                self.assertFalse((Path(home) / ".config/nvim/init.lua").exists())
                self.assertFalse(list(Path(home).glob("worktrunk-install.*")))

    def test_deprecated_configs_do_not_block_install_or_change(self):
        with tempfile.TemporaryDirectory() as home:
            colordiff = Path(home) / ".colordiffrc"
            colordiff.write_text("my colors")
            ctags = Path(home) / ".ctags.d/default.ctags"
            ctags.parent.mkdir()
            ctags.write_text("my tags")
            result, log = self.run_setup(home)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(colordiff.read_text(), "my colors")
            self.assertEqual(ctags.read_text(), "my tags")

    def test_missing_uv_installs_automatically_and_survives_rerun(self):
        for system, manager in (("Linux", "apt-get"), ("Linux", "dnf"),
                                ("Linux", "pacman"), ("Darwin", "brew")):
            for packages in (False, True):
                with self.subTest(manager=manager, packages=packages), tempfile.TemporaryDirectory() as home:
                    for _ in range(2):
                        result, log = self.run_setup(home, system, manager, missing="uv", packages=packages)
                        self.assertEqual(result.returncode, 0, result.stderr)
                    self.assertEqual(log.count("https://astral.sh/uv/install.sh"), 0 if packages else 1)
                    self.assertEqual(log.count("uv tool install black\n"), 2)

    def test_failed_uv_bootstrap_stops_before_tools_and_cleans_temp_file(self):
        for failure in ("uv-download", "uv-install"):
            with self.subTest(failure=failure), tempfile.TemporaryDirectory() as home:
                result, log = self.run_setup(home, failure=failure, missing="uv")
                self.assertNotEqual(result.returncode, 0)
                self.assertNotIn("npm install", log)
                self.assertNotIn("+Lazy! sync", log)
                self.assertFalse((Path(home) / ".config/nvim/init.lua").exists())
                self.assertFalse(list(Path(home).glob("uv-install.*")))

    def test_failed_uv_tools_stop_before_linking_and_plugin_sync(self):
        with tempfile.TemporaryDirectory() as home:
            result, log = self.run_setup(home, failure="uv")
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("uv tool install black", log)
            self.assertNotIn("+Lazy! sync", log)
            self.assertFalse((Path(home) / ".config/nvim/init.lua").exists())

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


class FishEnvironmentTest(unittest.TestCase):
    @unittest.skipUnless(shutil.which("fish"), "Fish is required for fnm checks")
    def test_fnm_initialization_without_startup_downloads(self):
        config = (REPO / "config.fish").read_text()
        hook = config[config.index("# fnm"):config.index("# Replace ls")]
        with tempfile.TemporaryDirectory() as home:
            binary = Path(home) / "fnm"
            binary.write_text('#!/bin/sh\nprintf "%s\\n" "$*" > "$HOME/calls"\nprintf "%s\\n" "set -gx FNM_TEST initialized"\n')
            binary.chmod(0o755)
            env = dict(os.environ, HOME=home, PATH=home)
            result = subprocess.run([shutil.which("fish"), "--no-config", "-c",
                                     hook + '\ntest "$FNM_TEST" = initialized'],
                                    env=env, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual((Path(home) / "calls").read_text(), "env --shell fish\n")

    @unittest.skipUnless(shutil.which("fish"), "Fish is required for environment checks")
    def test_prompt_only_activates_existing_project_environments(self):
        config = (REPO / "config.fish").read_text()
        start = config.index("function venv_activate ")
        hook = config[start:config.index("\nend", start) + len("\nend")]
        with tempfile.TemporaryDirectory(prefix="uv project ") as home:
            project = Path(home) / "project"
            project.mkdir()
            (project / "pyproject.toml").touch()
            script = hook + '\ncd "$FISH_PROJECT"; venv_activate; test -z "$VIRTUAL_ENV"'
            env = dict(os.environ, FISH_PROJECT=str(project), VIRTUAL_ENV="")
            result = subprocess.run(["fish", "--no-config", "-c", script],
                                    env=env, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertFalse((project / ".venv").exists())
            venv.EnvBuilder(with_pip=False).create(project / ".venv")
            script = hook + '\ncd "$FISH_PROJECT"; venv_activate\n' + (
                'test "$VIRTUAL_ENV" = "$FISH_PROJECT/.venv"; or exit 1\n'
                'cd ..; venv_activate; test -z "$VIRTUAL_ENV"'
            )
            result = subprocess.run(["fish", "--no-config", "-c", script],
                                    env=env, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
