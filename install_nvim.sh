#!/bin/sh
#
# Install init.vim for nvim.
#
##
## Usage: install_nvim.sh
##

set -euo pipefail

usage() {
  [ "$*" ] && echo "$0: $*"
  sed -n '/^##/,/^$/s/^## \{0,1\}//p' "$0"
  exit 2
} 2>/dev/null

ln -sr ./init.vim ~/.config/nvim/
ln -sr ./plugin ~/.config/nvim/
