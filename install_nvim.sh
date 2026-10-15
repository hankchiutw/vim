#!/bin/sh
# Link the current Lua configuration; dependencies are installed by install.sh.
set -eu
. "$(dirname "$0")/install_common.sh"

nvim_config="$config_home/nvim"
legacy="$nvim_config/init.vim"
if [ -e "$legacy" ] || [ -L "$legacy" ]; then
  if [ ! -L "$legacy" ] || [ ! "$legacy" -ef "$repo/init.vim" ]; then
    printf 'Conflict: %s is deprecated. Back it up or move it, then rerun.\n' "$legacy" >&2
    exit 1
  fi
fi
for name in init.lua lua plugin; do
  check_link "$repo/$name" "$nvim_config/$name"
done
if [ -L "$legacy" ]; then
  rm "$legacy"
fi
for name in init.lua lua plugin; do
  link_file "$repo/$name" "$nvim_config/$name"
done
printf 'Neovim configuration linked at %s\n' "$nvim_config"
