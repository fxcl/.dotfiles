#!/bin/sh
# shellcheck disable=SC1091
set -euf
SCRIPT_PATH="$(dirname "$0")"
# shellcheck source=util.sh
. "$SCRIPT_PATH"/util.sh

# Set if absent.
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME"/.config}
#HOST_FILE_LOCATION="$HOME/.dotfiles/.nix-host"

(command -v nix > /dev/null && success 'Nix - Installed!') || fail 'Nix - Not installed!'
(command -v nix flake show templates > /dev/null && success 'Nix flake - Installed!') || fail 'Nix flake - Not installed!'
case "$(uname -s)" in
    Darwin)     (command -v brew > /dev/null && success 'Homebrew - Installed!') || fail 'Homebrew - Not installed!'
                ;;
   *)           ;;
esac

#(test -f "$HOST_FILE_LOCATION" && success "Nix Host - Set to '$(cat "$HOST_FILE_LOCATION")'!") || fail 'Nix Host - Not Set!'
