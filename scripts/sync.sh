#!/bin/sh
# shellcheck disable=SC1091
set -euf
SCRIPT_PATH="$(dirname "$0")"
# shellcheck source=util.sh
. "$SCRIPT_PATH"/util.sh

HOST_FILE_LOCATION="$HOME/.dotfiles/.nix-host"
[ ! -f "$HOST_FILE_LOCATION" ] && fail "$HOST_FILE_LOCATION not found"
HOST_TARGET=$(cat "$HOST_FILE_LOCATION")

sync_flake() {
  info "Syncing Host '$HOST_TARGET'"
  nix build ".#$HOST_TARGET"

  case "$(uname -s)" in
      Darwin)     ./result/sw/bin/darwin-rebuild switch --flake ".#$HOST_TARGET"
                  ;;
      *)          ./result/activate
                  ;;
  esac
}

sync_flake
