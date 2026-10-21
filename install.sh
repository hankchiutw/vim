#!/bin/sh
# Install dependencies and link current Neovim and shared dotfiles.
set -eu
. "$(dirname "$0")/install_common.sh"
herdr_config=${HERDR_CONFIG_PATH:-"$config_home/herdr/config.toml"}
worktrunk_config=${WORKTRUNK_CONFIG_PATH:-"$config_home/worktrunk/config.toml"}

for name in .gitconfig .tigrc .tmux.conf; do
  check_link "$repo/$name" "$HOME/$name"
done
check_link "$repo/config.fish" "$config_home/fish/config.fish"
check_link "$repo/kitty.conf" "$config_home/kitty/kitty.conf"
check_link "$repo/herdr_config/config.toml" "$herdr_config"
check_link "$repo/worktrunk_config/config.toml" "$worktrunk_config"

as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

install_package() {
  case "$package_manager" in
    brew) brew install "$1" ;;
    apt-get) as_root apt-get install -y --no-install-recommends "$1" ;;
    dnf) as_root dnf install -y "$1" ;;
    pacman) as_root pacman -S --needed --noconfirm "$1" ;;
  esac
}

case "$(uname -s)" in
  Darwin)
    package_manager=brew
    if ! command -v brew >/dev/null 2>&1; then
      printf 'Install Homebrew first: https://brew.sh\n' >&2
      exit 1
    fi
    brew install neovim git curl cmake make ripgrep tmux fish fzf eza gawk tig git-delta tree-sitter-cli
    brew install --cask kitty
    ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      package_manager=apt-get
      as_root apt-get update
      as_root apt-get install -y neovim git curl build-essential cmake ripgrep tmux fish fzf eza gawk tig git-delta xclip kitty
    elif command -v dnf >/dev/null 2>&1; then
      package_manager=dnf
      as_root dnf install -y neovim git curl gcc gcc-c++ make cmake ripgrep tmux fish fzf eza gawk tig git-delta xclip kitty
    elif command -v pacman >/dev/null 2>&1; then
      package_manager=pacman
      as_root pacman -S --needed --noconfirm neovim git curl base-devel cmake ripgrep tmux fish fzf eza gawk tig git-delta xclip kitty
    else
      printf 'Unsupported Linux package manager; install dependencies manually, then run install_nvim.sh.\n' >&2
      exit 1
    fi
    ;;
  *)
    printf 'Supported systems: Linux and macOS.\n' >&2
    exit 1
    ;;
esac

export PATH="$HOME/.local/bin:$PATH"
if ! command -v uv >/dev/null 2>&1 && { ! install_package uv || ! command -v uv >/dev/null 2>&1; }; then
  (
    uv_installer=$(mktemp "${TMPDIR:-/tmp}/uv-install.XXXXXX")
    trap 'rm -f "$uv_installer"' 0
    curl -fsSL https://astral.sh/uv/install.sh -o "$uv_installer" || exit $?
    UV_INSTALL_DIR="$HOME/.local/bin" UV_NO_MODIFY_PATH=1 sh "$uv_installer"
  ) || exit $?
fi

if ! command -v fnm >/dev/null 2>&1 && { ! install_package fnm || ! command -v fnm >/dev/null 2>&1; }; then
  install_package unzip
  (
    fnm_stage=$(mktemp -d "${TMPDIR:-/tmp}/fnm-install.XXXXXX") || exit $?
    trap 'rm -rf "$fnm_stage"' 0
    curl -fsSL https://fnm.vercel.app/install -o "$fnm_stage/install.sh" || exit $?
    TMPDIR="$fnm_stage" bash "$fnm_stage/install.sh" --install-dir "$HOME/.local/bin" --skip-shell --force-install
  ) || exit $?
fi

nvm_dir=${NVM_DIR:-"$HOME/.nvm"}
if [ -d "$nvm_dir" ]; then
  uv run --no-project python "$repo/migrate_nvm.py"
fi
fnm_env=$(fnm env --shell bash)
eval "$fnm_env"
if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
  printf 'Node.js and npm are required. fnm is installed.\n' >&2
  printf 'Add $HOME/.local/bin to PATH; initialize fnm for your shell, run fnm install --lts, and rerun install.sh. See https://github.com/Schniz/fnm#shell-setup\n' >&2
  exit 1
fi

if ! nvim --clean --headless '+lua if vim.fn.has("nvim-0.11") == 0 then vim.cmd("cquit 1") end' +qa; then
  printf 'Neovim 0.11+ required. Upgrade via https://github.com/neovim/neovim/blob/master/INSTALL.md and rerun.\n' >&2
  exit 1
fi

npm install --global --prefix "$HOME/.local" 'typescript@^7' @biomejs/biome @fsouza/prettierd
export UV_TOOL_BIN_DIR="$HOME/.local/bin"
for tool in black isort ruff; do
  uv tool install "$tool"
done

if ! command -v herdr >/dev/null 2>&1 && { ! install_package herdr || ! command -v herdr >/dev/null 2>&1; }; then
  (
    herdr_installer=$(mktemp "${TMPDIR:-/tmp}/herdr-install.XXXXXX")
    trap 'rm -f "$herdr_installer"' 0
    curl -fsSL https://herdr.dev/install.sh -o "$herdr_installer" || exit $?
    HERDR_INSTALL_DIR="$HOME/.local/bin" sh "$herdr_installer"
  ) || exit $?
fi

if ! command -v wt >/dev/null 2>&1 && { ! install_package worktrunk || ! command -v wt >/dev/null 2>&1; }; then
  case "$package_manager" in
    apt-get) install_package xz-utils ;;
    *) install_package xz ;;
  esac
  (
    worktrunk_installer=$(mktemp "${TMPDIR:-/tmp}/worktrunk-install.XXXXXX")
    trap 'rm -f "$worktrunk_installer"' 0
    curl -fsSL https://github.com/max-sixty/worktrunk/releases/latest/download/worktrunk-installer.sh -o "$worktrunk_installer" || exit $?
    WORKTRUNK_INSTALL_DIR="$HOME/.local/bin" WORKTRUNK_NO_MODIFY_PATH=1 sh "$worktrunk_installer"
  ) || exit $?
fi
if ! command -v jq >/dev/null 2>&1; then
  install_package jq
fi
if ! command -v go >/dev/null 2>&1; then
  case "$package_manager" in
    apt-get) install_package golang-go ;;
    dnf) install_package golang ;;
    *) install_package go ;;
  esac
fi
if ! command -v docker >/dev/null 2>&1; then
  case "$package_manager" in
    brew) brew install --cask docker-desktop ;;
    apt-get) install_package docker.io ;;
    dnf) install_package moby-engine; install_package docker-cli ;;
    pacman) install_package docker ;;
  esac
fi
if ! command -v lazygit >/dev/null 2>&1 && { ! install_package lazygit || ! command -v lazygit >/dev/null 2>&1; }; then
  GOBIN="$HOME/.local/bin" go install github.com/jesseduffield/lazygit@latest
fi
if ! command -v yazi >/dev/null 2>&1 && { ! install_package yazi || ! command -v yazi >/dev/null 2>&1; }; then
  case "$(uname -m)" in
    x86_64|amd64) yazi_arch=x86_64 ;;
    aarch64|arm64) yazi_arch=aarch64 ;;
    *) printf 'Yazi release fallback supports x86_64 and arm64 only.\n' >&2; exit 1 ;;
  esac
  case "$package_manager" in
    brew) yazi_target="$yazi_arch-apple-darwin" ;;
    *) yazi_target="$yazi_arch-unknown-linux-musl" ;;
  esac
  install_package unzip
  (
    yazi_stage=$(mktemp -d "${TMPDIR:-/tmp}/yazi-install.XXXXXX") || exit $?
    trap 'rm -rf "$yazi_stage"' 0
    curl -fsSL "https://github.com/sxyazi/yazi/releases/latest/download/yazi-$yazi_target.zip" -o "$yazi_stage/yazi.zip" || exit $?
    unzip -q "$yazi_stage/yazi.zip" -d "$yazi_stage" || exit $?
    mkdir -p "$HOME/.local/bin" || exit $?
    install -m 755 "$yazi_stage/yazi-$yazi_target/yazi" "$yazi_stage/yazi-$yazi_target/ya" "$HOME/.local/bin/"
  ) || exit $?
fi
herdr plugin install --yes kryptamine/herdr-auto-title
herdr plugin install --yes devashish2203/herdr-worktrunk

sh "$repo/install_nvim.sh"
for name in .gitconfig .tigrc .tmux.conf; do
  link_file "$repo/$name" "$HOME/$name"
done
link_file "$repo/config.fish" "$config_home/fish/config.fish"
link_file "$repo/kitty.conf" "$config_home/kitty/kitty.conf"
link_file "$repo/herdr_config/config.toml" "$herdr_config"
link_file "$repo/worktrunk_config/config.toml" "$worktrunk_config"

nvim --headless '+Lazy! sync' +qa
printf 'Setup complete. Add $HOME/.local/bin to PATH, then run :checkhealth in Neovim.\n'
printf 'Start Auto Title in an existing Herdr server with: herdr plugin action invoke herdr.auto-title.restart\n'
printf 'Reload linked Herdr config with: herdr server reload-config\n'
