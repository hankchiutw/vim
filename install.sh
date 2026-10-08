#!/bin/sh
# Install dependencies and link current Neovim and shared dotfiles.
set -eu
. "$(dirname "$0")/install_common.sh"

for name in .gitconfig .tigrc .tmux.conf .colordiffrc; do
  check_link "$repo/$name" "$HOME/$name"
done
check_link "$repo/config.fish" "$config_home/fish/config.fish"
check_link "$repo/default.ctags" "$HOME/.ctags.d/default.ctags"

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
    brew install neovim git cmake make node python ripgrep tmux universal-ctags fish fzf eza gawk colordiff tig git-delta
    ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      as_root apt-get update
      as_root apt-get install -y neovim git build-essential cmake nodejs npm python3 python3-venv ripgrep tmux universal-ctags fish fzf eza gawk colordiff tig git-delta xclip
    elif command -v dnf >/dev/null 2>&1; then
      as_root dnf install -y neovim git gcc gcc-c++ make cmake nodejs npm python3 ripgrep tmux ctags fish fzf eza gawk colordiff tig git-delta xclip
    elif command -v pacman >/dev/null 2>&1; then
      as_root pacman -S --needed --noconfirm neovim git base-devel cmake nodejs npm python ripgrep tmux ctags fish fzf eza gawk colordiff tig git-delta xclip
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
for name in .gitconfig .tigrc .tmux.conf .colordiffrc; do
  link_file "$repo/$name" "$HOME/$name"
done
link_file "$repo/config.fish" "$config_home/fish/config.fish"
link_file "$repo/default.ctags" "$HOME/.ctags.d/default.ctags"

nvim --headless '+Lazy! sync' +qa
printf 'Setup complete. Add $HOME/.local/bin to PATH, then run :checkhealth in Neovim.\n'
