#!/bin/sh
# Install dependencies and link current Neovim and shared dotfiles.
set -eu
. "$(dirname "$0")/install_common.sh"

if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
  printf 'Node.js and npm are required. Install nvm: https://github.com/nvm-sh/nvm#installing-and-updating\n' >&2
  printf 'Then run nvm install --lts, activate Node in your shell, and rerun install.sh.\n' >&2
  exit 1
fi

for name in .gitconfig .tigrc .tmux.conf; do
  check_link "$repo/$name" "$HOME/$name"
done
check_link "$repo/config.fish" "$config_home/fish/config.fish"
check_link "$repo/kitty.conf" "$config_home/kitty/kitty.conf"

as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

case "$(uname -s)" in
  Darwin)
    if ! command -v brew >/dev/null 2>&1; then
      printf 'Install Homebrew first: https://brew.sh\n' >&2
      exit 1
    fi
    brew install neovim git cmake make python ripgrep tmux fish fzf eza gawk tig git-delta
    brew install --cask kitty
    ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      as_root apt-get update
      as_root apt-get install -y neovim git build-essential cmake python3 python3-venv ripgrep tmux fish fzf eza gawk tig git-delta xclip kitty
    elif command -v dnf >/dev/null 2>&1; then
      as_root dnf install -y neovim git gcc gcc-c++ make cmake python3 ripgrep tmux fish fzf eza gawk tig git-delta xclip kitty
    elif command -v pacman >/dev/null 2>&1; then
      as_root pacman -S --needed --noconfirm neovim git base-devel cmake python ripgrep tmux fish fzf eza gawk tig git-delta xclip kitty
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

if ! nvim --clean --headless '+lua if vim.fn.has("nvim-0.11") == 0 then vim.cmd("cquit 1") end' +qa; then
  printf 'Neovim 0.11+ required. Upgrade via https://github.com/neovim/neovim/blob/master/INSTALL.md and rerun.\n' >&2
  exit 1
fi

npm install --global --prefix "$HOME/.local" 'typescript@^7' @biomejs/biome @fsouza/prettierd
export PATH="$HOME/.local/bin:$PATH"

sh "$repo/install_nvim.sh"
for name in .gitconfig .tigrc .tmux.conf; do
  link_file "$repo/$name" "$HOME/$name"
done
link_file "$repo/config.fish" "$config_home/fish/config.fish"
link_file "$repo/kitty.conf" "$config_home/kitty/kitty.conf"

nvim --headless '+Lazy! sync' +qa
printf 'Setup complete. Add $HOME/.local/bin to PATH, then run :checkhealth in Neovim.\n'
