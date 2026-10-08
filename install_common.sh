#!/bin/sh

repo=$(CDPATH= cd -P "$(dirname "$0")" && pwd)
config_home=${XDG_CONFIG_HOME:-"$HOME/.config"}

check_link() {
  if [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ]; then
    return
  fi
  if [ -e "$2" ] || [ -L "$2" ]; then
    printf 'Conflict: %s exists. Back it up or move it, then rerun.\n' "$2" >&2
    exit 1
  fi
}

link_file() {
  check_link "$1" "$2"
  if [ ! -L "$2" ]; then
    mkdir -p "$(dirname "$2")"
    ln -s "$1" "$2"
  fi
}
