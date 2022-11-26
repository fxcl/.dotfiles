#!/bin/sh
# shellcheck disable=SC1091
set -euf
SCRIPT_PATH="$(dirname "$0")"
# shellcheck source=util.sh
. "$SCRIPT_PATH"/util.sh

info 'Nix Flake - Upgrading...'
#nix flake update
nix --extra-experimental-features "nix-command flakes" flake update

success 'Nix Flake - Complete!'

case "$(uname -s)" in
Darwin)
    info 'Homebrew - Upgrading...'
    brew upgrade --ignore-pinned && brew update
    success 'Homebrew - Complete!'
    ;;
*) ;;
esac
