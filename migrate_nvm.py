#!/usr/bin/env python3
"""Reinstall nvm-sh runtimes and registry globals in fnm; preserve source data."""
import json
import os
from pathlib import Path
import re
import subprocess
import sys


def run(args, env=None):
    return subprocess.run(args, env=env, check=True, capture_output=True, text=True).stdout.strip()


def packages(raw, prefix):
    inventory = json.loads(raw)
    if not isinstance(inventory, dict) or not isinstance(inventory.get("dependencies", {}), dict):
        raise ValueError(f"Invalid npm inventory: {prefix}")
    result = {}
    for name, info in inventory.get("dependencies", {}).items():
        if name == "npm":
            continue
        if not isinstance(info, dict):
            raise ValueError(f"Invalid package inventory: {name}")
        if not re.fullmatch(r"(?:@[A-Za-z0-9][\w.-]*/)?[A-Za-z0-9][\w.-]*", name):
            raise ValueError(f"Invalid package name: {name}")
        version = info.get("version", "")
        if not re.fullmatch(r"\d+\.\d+\.\d+(?:[-+][\w.+-]+)?", version):
            raise ValueError(f"Missing or invalid package version: {name}")
        if info.get("link") or (prefix / "lib/node_modules" / name).is_symlink() or str(info.get("resolved", "")).startswith(("file:", "git:", "git+")):
            raise ValueError(f"Linked/local package needs manual migration: {prefix}: {name}")
        result[name] = version
    return result


def migrate():
    source = Path(os.environ.get("NVM_DIR") or str(Path.home() / ".nvm"))
    versions = sorted(set(source.glob("versions/node/v*")) | set(source.glob("v*")))
    versions = [path for path in versions if (path / "bin/node").is_file()]
    if not versions:
        return
    old_default = ""
    if (source / "nvm.sh").is_file():
        env = dict(os.environ, NVM_DIR=str(source))
        probe = subprocess.run(["bash", "-c", '. "$NVM_DIR/nvm.sh" --no-use && nvm version default'], env=env, capture_output=True, text=True)
        old_default = probe.stdout.strip()
        if probe.returncode and old_default != "N/A":
            probe.check_returncode()
    current_default = subprocess.run(["fnm", "default"], capture_output=True, text=True)
    keep_default = current_default.returncode == 0 and bool(current_default.stdout.strip())
    for prefix in versions:
        version = prefix.name
        env = dict(os.environ, PATH=f"{prefix / 'bin'}:{os.environ['PATH']}")
        if run([str(prefix / "bin/node"), "--version"], env) != version:
            raise ValueError(f"nvm runtime version differs from directory: {prefix}")
        wanted = packages(run([str(prefix / "bin/npm"), "ls", "--global", "--prefix", str(prefix), "--depth=0", "--json"], env), prefix)
        print(f"Migrating nvm {version}: {len(wanted)} global packages", flush=True)
        run(["fnm", "install", version])
        command = ["fnm", "exec", "--using", version]
        if run(command + ["node", "--version"]) != version:
            raise ValueError(f"fnm runtime verification failed: {version}")
        target = Path(run(command + ["node", "-p", "process.execPath"])).parent.parent
        npm = command + ["npm", "--prefix", str(target)]
        present = packages(run(npm + ["ls", "--global", "--depth=0", "--json"]), target)
        for name, package_version in wanted.items():
            if name in present and present[name] != package_version:
                raise ValueError(f"fnm package conflict: {version}: {name}@{present[name]} vs nvm {package_version}")
            if present.get(name) != package_version:
                run(npm + ["install", "--global", f"{name}@{package_version}"])
        migrated = packages(run(npm + ["ls", "--global", "--depth=0", "--json"]), target)
        if any(migrated.get(name) != value for name, value in wanted.items()):
            raise ValueError(f"Global package verification failed: {version}")
    if not keep_default:
        available = {path.name for path in versions}
        if old_default not in available:
            old_default = max(available, key=lambda value: tuple(int(part) for part in value[1:].split(".")))
        run(["fnm", "default", old_default])
    print(f"nvm migration verified; original installation retained at {source}")


if __name__ == "__main__":
    try:
        migrate()
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        sys.exit(f"nvm migration failed: {error}\n{getattr(error, 'stderr', '')}")
