#!/usr/bin/env sh
# shellcheck disable=SC1091
set -euf
SCRIPT_PATH="$(dirname "$0")"
# shellcheck source=util.sh
. "$SCRIPT_PATH"/util.sh

# Set if absent.
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME"/.config}
DOTFILES_LOCATION="$HOME/.dotfiles"
HOST_FILE_LOCATION="$DOTFILES_LOCATION"/.nix-host

check_zsh() {
  case $SHELL in
    */zsh) success 'Zsh - Already set!' ;;
    *)
      warn "Zsh is not the current shell!"
      location="$(which zsh)"
      if [ -f "$location" ]; then
        case "$(uname -s)" in
            Darwin)
              info "Zsh - You should have already at least '/bin/zsh' registered in '/etc/shell'. Ideally $location as well"
              info "Zsh - Run the following to set the default shell:"
              echo
              echo "chsh -s /bin/zsh"
              echo
              ;;
            *)
              info "Zsh - Run the following and restart:":
              if [ -d /etc/nixos ]; then
                echo "For some reason, the default shell is not set correctly. Was it applied?"
                echo
              else
                echo "echo '$location' | sudo tee -a /etc/shells > /dev/null"
                echo "chsh -s $location"
              fi
              ;;
        esac
      else
        warn "Zsh - No zsh installation found, is it installed?"
      fi
  esac
}

(command -v nix >/dev/null && success 'Nix - Installed!') || fail 'Nix - Not installed!'
(command -v nix flake show templates >/dev/null && success 'Nix flake - Installed!') || fail 'Nix flake - Not installed!'
case "$(uname -s)" in
  Darwin)
    (command -v brew >/dev/null && success 'Homebrew - Installed!') || fail 'Homebrew - Not installed!'
    ;;
  *) ;;
esac

(test -d "$DOTFILES_LOCATION/host/$(cat $HOST_FILE_LOCATION)" && success "Nix Host - Set to '$(cat "$HOST_FILE_LOCATION")'!") || fail "Nix Host - Invalid host! It is $(cat $HOST_FILE_LOCATION)"

check_zsh
