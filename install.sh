#!/bin/sh
# Install dependencies and link current Neovim and shared dotfiles.
set -eu
. "$(dirname "$0")/install_common.sh"
herdr_config=${HERDR_CONFIG_PATH:-"$config_home/herdr/config.toml"}

if ! command -v uv >/dev/null 2>&1; then
  printf 'uv is required. Install it: https://docs.astral.sh/uv/getting-started/installation/\n' >&2
  printf 'Add uv to PATH, then rerun install.sh.\n' >&2
  exit 1
fi

for name in .gitconfig .tigrc .tmux.conf; do
  check_link "$repo/$name" "$HOME/$name"
done
check_link "$repo/config.fish" "$config_home/fish/config.fish"
check_link "$repo/kitty.conf" "$config_home/kitty/kitty.conf"
check_link "$repo/herdr_config/config.toml" "$herdr_config"

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
    brew install neovim git curl cmake make python ripgrep tmux fish fzf eza gawk tig git-delta
    brew install --cask kitty
    ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      package_manager=apt-get
      as_root apt-get update
      as_root apt-get install -y neovim git curl build-essential cmake python3 python3-venv ripgrep tmux fish fzf eza gawk tig git-delta xclip kitty
    elif command -v dnf >/dev/null 2>&1; then
      package_manager=dnf
      as_root dnf install -y neovim git curl gcc gcc-c++ make cmake python3 ripgrep tmux fish fzf eza gawk tig git-delta xclip kitty
    elif command -v pacman >/dev/null 2>&1; then
      package_manager=pacman
      as_root pacman -S --needed --noconfirm neovim git curl base-devel cmake python ripgrep tmux fish fzf eza gawk tig git-delta xclip kitty
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

export NVM_DIR=${NVM_DIR:-"$HOME/.nvm"}
if [ ! -s "$NVM_DIR/nvm.sh" ] && install_package nvm; then
  nvm_script=$(
    case "$package_manager" in
      brew) printf '%s/nvm.sh\n' "$(brew --prefix nvm)" ;;
      apt-get) dpkg-query -L nvm ;;
      dnf) rpm -ql nvm ;;
      pacman) pacman -Qlq nvm ;;
    esac | sed -n '/\/nvm.sh$/p' | head -n 1
  )
  if [ -s "$nvm_script" ]; then
    nvm_package_dir=$(dirname "$nvm_script")
    for name in nvm.sh nvm-exec bash_completion; do
      if [ -e "$nvm_package_dir/$name" ]; then
        link_file "$nvm_package_dir/$name" "$NVM_DIR/$name"
      fi
    done
    if [ -e "$nvm_package_dir/etc/bash_completion.d/nvm" ]; then
      link_file "$nvm_package_dir/etc/bash_completion.d/nvm" "$NVM_DIR/bash_completion"
    fi
  fi
fi
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  nvm_installer=$(mktemp "${TMPDIR:-/tmp}/nvm-install.XXXXXX")
  trap 'rm -f "$nvm_installer"' 0
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh -o "$nvm_installer"
  mkdir -p "$NVM_DIR"
  NODE_VERSION= NVM_INSTALL_VERSION=v0.40.8 bash "$nvm_installer"
fi

if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
  printf 'Node.js and npm are required. nvm is installed at %s. See https://github.com/nvm-sh/nvm#installing-and-updating\n' "$NVM_DIR" >&2
  printf 'Load nvm in Bash/Zsh, run nvm install --lts, and rerun install.sh.\n' >&2
  exit 1
fi

if ! nvim --clean --headless '+lua if vim.fn.has("nvim-0.11") == 0 then vim.cmd("cquit 1") end' +qa; then
  printf 'Neovim 0.11+ required. Upgrade via https://github.com/neovim/neovim/blob/master/INSTALL.md and rerun.\n' >&2
  exit 1
fi

npm install --global --prefix "$HOME/.local" 'typescript@^7' @biomejs/biome @fsouza/prettierd
export PATH="$HOME/.local/bin:$PATH"
export UV_TOOL_BIN_DIR="$HOME/.local/bin"
for tool in black isort ruff; do
  uv tool install "$tool"
done

if ! command -v herdr >/dev/null 2>&1 && { ! install_package herdr || ! command -v herdr >/dev/null 2>&1; }; then
  (
    herdr_installer=$(mktemp "${TMPDIR:-/tmp}/herdr-install.XXXXXX")
    trap 'rm -f "$herdr_installer"' 0
    curl -fsSL https://herdr.dev/install.sh -o "$herdr_installer"
    HERDR_INSTALL_DIR="$HOME/.local/bin" sh "$herdr_installer"
  )
fi

sh "$repo/install_nvim.sh"
for name in .gitconfig .tigrc .tmux.conf; do
  link_file "$repo/$name" "$HOME/$name"
done
link_file "$repo/config.fish" "$config_home/fish/config.fish"
link_file "$repo/kitty.conf" "$config_home/kitty/kitty.conf"
link_file "$repo/herdr_config/config.toml" "$herdr_config"

nvim --headless '+Lazy! sync' +qa
printf 'Setup complete. Add $HOME/.local/bin to PATH, then run :checkhealth in Neovim.\n'
printf 'Herdr plugin (install manually): herdr plugin install kryptamine/herdr-auto-title --ref 57fe0f183bbc084abb1a5143d3f097955f3b6cd9\n'
printf 'Reload linked Herdr config with: herdr server reload-config\n'
