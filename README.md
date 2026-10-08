# Neovim as an IDE

Neovim Lua setup. lazy.nvim manages plugins.
Requires Neovim 0.11+, Git, C compiler, Make, Node.js/npm, ripgrep for Telescope.

![screenshot](screenshot.png)

## Install

Linux: apt, dnf, pacman. macOS: [Homebrew](https://brew.sh) required.
Linux uses sudo unless root. No third-party PPAs or package-manager installers.
Old Neovim stops setup; follow [upgrade instructions](https://github.com/neovim/neovim/blob/master/INSTALL.md).

Setup installs [uv](https://docs.astral.sh/uv/getting-started/installation/) automatically: system package manager first; official curl fallback into `~/.local/bin`.
Existing uv preserved. Curl fallback leaves shell profiles unchanged. Setup adds install directory to PATH.

```sh
./install.sh
```

### Node.js and nvm

[nvm](https://github.com/nvm-sh/nvm#installing-and-updating): system package manager first; curl fallback downloads official v0.40.8 installer.
`NVM_DIR` overrides default `~/.nvm`. Existing installs preserved.
Packaged loaders link into user directory. Node versions survive package upgrades.
Curl fallback may add Bash/Zsh profile lines.
[Homebrew nvm unsupported upstream](https://formulae.brew.sh/formula/nvm); reproduce issues with upstream installation before reporting.

Node.js/npm stay manual. Missing runtime stops setup after nvm installation,
before JS/Python tools, config links, plugin sync. Load nvm, install Node, rerun:

```sh
. "${NVM_DIR:-$HOME/.nvm}/nvm.sh"
nvm install --lts
./install.sh
```

Use Bash/Zsh or [Fish integration](https://github.com/nvm-sh/nvm#fish).

### Tools

Existing npm installs TypeScript 7 (`tsc --lsp`), Biome, prettierd into `~/.local`.
Setup links Lua config and syncs plugins.
uv installs Black, isort, Ruff in isolated environments; executables use `~/.local/bin`.
Reruns keep versions. Update with `uv tool upgrade black`, `uv tool upgrade isort`, `uv tool upgrade ruff`.
uv downloads missing Python runtimes. Setup requests no Python packages explicitly and uninstalls none.
Package manager still installs Python when another package requires it.

Add `~/.local/bin` to PATH:

```sh
# Bash/Zsh
export PATH="$HOME/.local/bin:$PATH"
# Fish
fish_add_path "$HOME/.local/bin"
```

## Herdr

[Herdr](https://herdr.dev/docs/install/): system package manager first; official curl fallback installs into `~/.local/bin`.
Unavailable packages or failed installs trigger fallback. Existing PATH binaries preserved; reruns skip updates.
Run `herdr` inside Kitty or another terminal. Setup starts no sessions.
Direct installs: `herdr update`. Package installs: update through package manager.

[Shipped config](herdr_config/config.toml) links to `$XDG_CONFIG_HOME/herdr/config.toml`, default `~/.config/herdr/config.toml`.
`HERDR_CONFIG_PATH` overrides destination. Prefix: `alt+m`. Kitty graphics enabled.
Existing custom config blocks setup; back up or move first, then rerun.
Reload with `herdr server reload-config`. UI edits may change repo-backed config through symlink.

Plugins stay manual. Current plugin: [Auto Title](https://github.com/kryptamine/herdr-auto-title), automatic tab/pane names.
Install Go for build step. Run on each machine hosting Herdr panes:

```sh
herdr plugin install kryptamine/herdr-auto-title
herdr plugin action invoke herdr.auto-title.restart
```

Plugin registration/settings, logs, sockets, session data stay local.

## Kitty and dotfiles

Setup installs Fish, fzf, eza, gawk, Tig, Delta; Linux also gets xclip.
tmux uses login shell. Clipboard: pbcopy on macOS, xclip on Linux. xclip requires X display.

Kitty: Linux package manager, macOS Homebrew cask.
`kitty.conf` links to `$XDG_CONFIG_HOME/kitty/kitty.conf`, default `~/.config/kitty/kitty.conf`.
Existing custom config stays protected; back up or move first, then rerun.
Open Kitty after setup. Install JetBrainsMono Nerd Font manually or choose installed font in Kitty settings.
No fonts or legacy Alacritty config installed automatically.

Setup links `.gitconfig`, `.tigrc`, `.tmux.conf`, Fish config.
Review first: `.gitconfig` contains personal identity and aliases.
Custom files/directories block setup. Back up or move first, then rerun. Correct links stay unchanged.
Absolute links support any working directory; keep source checkout available.

## Neovim config only

Install dependencies first:

```sh
./install_nvim.sh
```

`XDG_CONFIG_HOME` respected; default `~/.config`.
First startup: lazy.nvim downloads plugins; Mason installs configured language servers, including Pyright.
Check `:checkhealth`, `:Mason`. Install optional StyLua through Mason. Black, isort, Ruff use uv.
Mason appends executable directory to PATH; shell/project tools take priority. Existing Mason installs preserved.
AI plugins require separate authentication.

## Migration

Python projects: uv replaces pyenv initialization and automatic environment creation.
Run `uv python install <version>`, `uv python pin <version>` for chosen Python version.
Add dependencies: `uv add <package>`. Create/update `.venv`: `uv sync`.
Run project commands: `uv run <command>`.
Commit `pyproject.toml`, `uv.lock`, `.python-version`; ignore `.venv/`. See [uv project guide](https://docs.astral.sh/uv/guides/projects/).
Fish activates existing `.venv` in directories containing `pyproject.toml`; deactivates elsewhere.
Prompt hooks never create/sync environments. Existing pyenv installs and project environments preserved.

Deprecated: `ble.sh`, `init.vim`, vim-plug. Legacy `init.vim` stays for reference; setup uses `init.lua`, `lua/`.
Remove ble.sh source/attach lines from existing shell startup files manually. Repo `bashrc` already omits them.
Setup removes Neovim `init.vim` symlink only when pointing to this checkout's legacy file.
Custom `init.vim` stays protected and blocks setup; Neovim cannot use both entry points.
Existing `~/.vimrc`, Vim plugin data preserved. No TSLint, ESLint bundles, vim-plug, vimpager, showlinenum setup.

colordiff/Ctags deprecated. No packages installed; no `.colordiffrc`, `default.ctags` links created.
Repo configs stay for reference. Existing packages/home configs stay unchanged and do not block setup.
`git dic` retired; use `git di` with Delta.

## Verify installer

```sh
uv run --no-project python -B -m unittest discover -s tests -v
```

Tests use temporary homes and mocked package managers. No real packages/plugins installed.
