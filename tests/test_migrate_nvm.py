import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


REPO = Path(__file__).resolve().parents[1]
NODE = '''import pathlib,sys
path = pathlib.Path(sys.argv[0]).absolute()
print(str(path) if '-p' in sys.argv else path.parent.parent.name)
'''
NPM = '''import json,os,pathlib,sys
args=sys.argv[1:]
prefix=pathlib.Path(args[args.index('--prefix')+1])
state=prefix/'packages.json'
data=json.loads(state.read_text()) if state.exists() else {'npm':{'version':'10.0.0'}}
if 'ls' in args:
    print(json.dumps({'dependencies':data})); sys.exit(0)
if os.environ.get('MIGRATE_FAILURE') == 'install': sys.exit(1)
name,version=args[-1].rsplit('@',1)
with open(os.environ['MIGRATE_LOG'],'a') as log: log.write(args[-1]+'\\n')
if os.environ.get('MIGRATE_FAILURE') != 'verify':
    data[name]={'version':version}; state.write_text(json.dumps(data))
'''
FNM = '''import os,pathlib,shutil,subprocess,sys
args=sys.argv[1:]; root=pathlib.Path(os.environ['FNM_DIR']); default=root/'default'
if args[0]=='default':
    if len(args)>1: default.write_text(args[1])
    elif default.exists(): print(default.read_text())
    else: sys.exit(1)
elif args[0]=='install':
    target=root/args[1]/'bin'; target.mkdir(parents=True,exist_ok=True)
    for name in ('node','npm'): shutil.copy2(root/name,target/name)
elif args[0]=='exec':
    env=dict(os.environ,PATH=str(root/args[2]/'bin')+':'+os.environ['PATH'])
    sys.exit(subprocess.call(args[3:],env=env))
else: sys.exit(99)
'''


class MigrationTest(unittest.TestCase):
    def fixture(self, home, versions=("v20.0.0", "v22.0.0")):
        home = Path(home)
        source = home / "custom nvm"
        target = home / "fnm"
        tools = home / "bin"
        for path in (source, target, tools):
            path.mkdir()
        for path, code in ((tools / "fnm", FNM), (target / "node", NODE), (target / "npm", NPM)):
            path.write_text(f"#!{sys.executable}\n" + code)
            path.chmod(0o755)
        for version in versions:
            prefix = source / "versions/node" / version
            (prefix / "bin").mkdir(parents=True)
            for name in ("node", "npm"):
                (prefix / "bin" / name).write_bytes((target / name).read_bytes())
                (prefix / "bin" / name).chmod(0o755)
            (prefix / "packages.json").write_text(json.dumps({"npm": {"version": "10.0.0"}, "@scope/tool": {"version": "1.2.3"}}))
        (source / "nvm.sh").write_text('nvm() { printf "%s\\n" v22.0.0; }\n')
        env = dict(os.environ, HOME=str(home), NVM_DIR=str(source), FNM_DIR=str(target),
                   PATH=str(tools) + os.pathsep + os.environ["PATH"], MIGRATE_LOG=str(home / "installs"), MIGRATE_FAILURE="")
        return source, target, env

    def migrate(self, env):
        return subprocess.run([sys.executable, str(REPO / "migrate_nvm.py")],
                              env=env, capture_output=True, text=True)

    def test_exact_versions_globals_default_and_source_preserved_on_rerun(self):
        with tempfile.TemporaryDirectory(prefix="nvm migration ") as home:
            source, target, env = self.fixture(home)
            before = {str(path): path.read_bytes() for path in source.rglob("*") if path.is_file()}
            for _ in range(2):
                result = self.migrate(env)
                self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual((target / "default").read_text(), "v22.0.0")
            self.assertEqual((Path(home) / "installs").read_text().splitlines(), ["@scope/tool@1.2.3"] * 2)
            self.assertEqual(before, {str(path): path.read_bytes() for path in source.rglob("*") if path.is_file()})

    def test_existing_fnm_default_and_matching_packages_preserved(self):
        with tempfile.TemporaryDirectory() as home:
            source, target, env = self.fixture(home, ("v22.0.0",))
            (target / "default").write_text("v24.0.0")
            (target / "v22.0.0").mkdir()
            (target / "v22.0.0/packages.json").write_bytes((source / "versions/node/v22.0.0/packages.json").read_bytes())
            result = self.migrate(env)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual((target / "default").read_text(), "v24.0.0")
            self.assertFalse((Path(home) / "installs").exists())

    def test_absent_default_uses_highest_migrated_version(self):
        with tempfile.TemporaryDirectory() as home:
            source, target, env = self.fixture(home)
            (source / "nvm.sh").write_text('nvm() { echo N/A; return 3; }\n')
            result = self.migrate(env)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual((target / "default").read_text(), "v22.0.0")

    def test_failures_leave_nvm_and_default_unchanged(self):
        for failure in ("link", "conflict", "inventory", "install", "verify"):
            with self.subTest(failure=failure), tempfile.TemporaryDirectory() as home:
                source, target, env = self.fixture(home, ("v22.0.0",))
                prefix = source / "versions/node/v22.0.0"
                if failure == "link":
                    (prefix / "lib/node_modules/@scope").mkdir(parents=True)
                    (prefix / "lib/node_modules/@scope/tool").symlink_to(source)
                elif failure == "conflict":
                    (target / "v22.0.0").mkdir()
                    (target / "v22.0.0/packages.json").write_text('{"@scope/tool":{"version":"2.0.0"}}')
                elif failure == "inventory":
                    (prefix / "packages.json").write_text('invalid json')
                env["MIGRATE_FAILURE"] = failure
                before = (prefix / "packages.json").read_bytes()
                result = self.migrate(env)
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("nvm migration failed", result.stderr)
                self.assertEqual((prefix / "packages.json").read_bytes(), before)
                self.assertFalse((target / "default").exists())

    def test_no_nvm_does_not_install_node(self):
        with tempfile.TemporaryDirectory() as home:
            result = self.migrate(dict(os.environ, NVM_DIR=str(Path(home) / "absent")))
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(result.stdout, "")
