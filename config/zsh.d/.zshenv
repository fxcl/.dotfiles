export LS_COLORS=$(vivid generate one-light)
export COLORTERM="truecolor"
# Better spell checking & auto correction prompt
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{blue}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]?"
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS="-F -g -i -M -R -S -w -X -z-4"
export KEYTIMEOUT="1"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export DOTFILES="$HOME/.dotfiles"
export PROJECTS="$HOME/Sites/personal/dev"
export WORK="$HOME/Sites/work"
export PERSONAL_STORAGE="$HOME/Sync"
export NOTES_DIR="$PERSONAL_STORAGE/notes"

export CLICOLOR=1
export GPG_TTY="${GPG_TTY:-$(tty)}"
export HOMEBREW_NO_AUTO_UPDATE=1
export RUST_BACKTRACE=1

# I use a single zk notes dir, so set it and forget
export ZK_NOTEBOOK_DIR=$NOTES_DIR
# export HOST_CONFIGS="$XDG_DATA_HOME/$(hostname)"

############### APPS/POGRAMS XDG SPEC CLEANUP
export RLWRAP_HOME="$XDG_DATA_HOME/rlwrap"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export _ZO_DATA_DIR="$XDG_CONFIG_HOME/zoxide"

#ollama amd gpu
export HSA_OVERRIDE_GFX_VERSION="10.3.0"

# Use cyan colour scaling for the dates column, as the default blue is difficult to read.
if command -v eza &>/dev/null; then
  export EZA_COLORS="ur=35;nnn:gr=35;nnn:tr=35;nnn:uw=34;nnn:gw=34;nnn:tw=34;nnn:ux=36;nnn:due=36;nnn:gx=36;nnn:tx=36;nnn:uu=36;nnn:uu=38;5;235:da=38;5;238"
fi

# Canonical hex dump; some systems have this symlinked
command -v hd >/dev/null || alias hd="hexdump -C"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum >/dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum >/dev/null || alias sha1sum="shasum"

############### Telemetry
export DO_NOT_TRACK=1 # Future proof? https://consoledonottrack.com/
export HOMEBREW_NO_ANALYTICS=1
export GATSBY_TELEMETRY_DISABLED=1
export NEXT_TELEMETRY_DISABLED=1
export ADBLOCK="true"

############### Homebrew
export HOMEBREW_INSTALL_BADGE="⚽️"

############### Pure
export PURE_GIT_UP_ARROW="🠥"
export PURE_GIT_DOWN_ARROW="🠧"
export PURE_GIT_BRANCH="  "

export PIP_CONFIG_FILE="$XDG_CONFIG_HOME/pip/pip.conf"
export PIP_LOG_FILE="$XDG_DATA_HOME/pip/log"
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME/python-eggs"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export PYLINTRC="$XDG_CONFIG_HOME/pylint/pylintrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PYLINTHOME="$XDG_DATA_HOME/pylint"

# Default env
export USER_BIN_HOME="$HOME/.local/bin"
export USER_ZSH_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
export USER_ZSH_SITE_FUNCTIONS="$USER_ZSH_DATA/site-functions"

# Proto
# https://moonrepo.dev/proto
# https://github.com/moonrepo
#
# Alternative to Mise, Volta, asdf
# Uses Shims, like Volta and asdf
if [ -d "$HOME/.proto" ]; then
  export PROTO_HOME="$HOME/.proto"
  export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH"
  export PROTO_AUTO_INSTALL=true
  #  eval "$(proto activate zsh -c global)"
  eval "$(proto activate zsh --no-bin --no-shim)"
  # alias puse="proto pin --resolve --global"
  alias plist="proto list --aliases"
  alias psearch="proto list-remote --aliases"
  alias pupgrade="proto upgrade"

  function pinstall() {
    if [[ $# -eq 1 ]]; then
      echo -e "\033[0;33mWarning: No version provided. Using 'latest' as version tag.\033[0m"
      echo
      proto install --pin global $1 latest
    else
      proto install --pin global $1 $2
    fi
  }
  function prm() {
    if [[ $# -eq 1 ]]; then
      echo -e "\033[0;33mWarning: No version provided. Using 'latest' as version tag.\033[0m"
      echo
      proto uninstall $1 latest
    else
      proto uninstall $1 $2
    fi
  }
  function puse() {
    if [[ $# -eq 1 ]]; then
      echo -e "\033[0;33mWarning: No version provided. Using 'latest' as version tag.\033[0m"
      echo
      proto pin --resolve --global $1 latest
    else
      proto pin --resolve --global $1 $2
    fi
  }
  function poutdated() {
    if [[ -f .prototools ]]; then
      proto outdated
    elif [[ $# -eq 0 ]]; then
      echo -e "\033[0;33mWarning: No argument provided. Checking global tools...\033[0m"
      echo
      (cd $PROTO_HOME && proto outdated)
    elif [[ -d $1 ]]; then
      (cd $1 && proto outdated)
    else
      echo -e "\033[0;31mInvalid argument: $1\033[0m"
    fi
  }
  function ptools() {
    if [[ -f .prototools ]]; then
      proto status
    elif [[ $# -eq 0 ]]; then
      echo -e "\033[0;33mWarning: No argument provided. Checking global tools...\033[0m"
      echo
      (cd $PROTO_HOME && proto status)
    elif [[ -d $1 ]]; then
      (cd $1 && proto status)
    else
      echo -e "\033[0;31mInvalid argument: $1\033[0m"
    fi
  }

  function phelp() {
    echo "Custom commands for Proto."
    echo
    echo "Usage: <P-COMMAND> [OPTIONS]"
    echo
    echo "Commands:"
    echo "    puse <TOOL> <[VERSION]>      - Use <TOOL> at <[VERSION]> ."
    echo "                                   If <[VERSION]>  is not provided, it will be set to 'latest'."
    echo "    pinstall <TOOL> <[VERSION]>  - Install <TOOL> at <[VERSION]> ."
    echo "                                   If <[VERSION]>  is not provided, it will be set to 'latest'."
    echo "    prm <TOOL> <[VERSION]>       - Uninstall <TOOL> at <[VERSION]> ."
    echo "                                   If <[VERSION]>  is not provided, it will be set to 'latest'."
    echo "    plist <TOOL>                 - List all installed versions of <TOOL>."
    echo "    psearch <TOOL>               - Search for available versions of <TOOL>."
    echo "    pupgrade                     - Upgrade proto itself."
    echo "    poutdated <[DIRECTORY]>      - Show outdated tools in <directory>."
    echo "                                   If <[DIRECTORY]> is not provided, it will be set to '$PROTO_HOME'."
    echo "    ptools <[DIRECTORY]>         - List all installed tools in <directory>."
    echo "                                   If <[DIRECTORY]> is not provided, it will be set to '$PROTO_HOME'."
  }
fi

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Using Proto
[ -s "$HOME/.proto/bin/bun/_bun" ] && source "$HOME/.proto/bin/bun/_bun"
# alias bun='sde -chip-check-disable -- bun'

#proto node global
if [ -d "${PROTO_HOME}/tools/node/globals/bin" ]; then
  export PATH="${PATH}:${PROTO_HOME}/tools/node/globals/bin"
fi

#rustup
# add rustup binaries to $PATH on macos
if [[ $OSTYPE == "darwin"* && -d /usr/local/Cellar/rustup/1.27.1_1/bin/ ]]; then
  export PATH=${PATH}:/usr/local/Cellar/rustup/1.27.1_1/bin
fi

export LIBRARY_PATH="/usr/local/opt/libiconv/lib:$LIBRARY_PATH"
export CPATH="/usr/local/opt/libiconv/include:$CPATH"

#cargo
if [ -d "${CARGO_HOME}/bin" ]; then
  export PATH="${PATH}:${CARGO_HOME}/bin"
  if [ -d "${RUSTUP_HOME}/bin" ]; then
    export PATH="${PATH}:${RUSTUP_HOME}/bin"
  fi
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]/}

############### PAGER
# Set less or more as the default pager.
if [[ -z ${PAGER+x} ]]; then
  if [[ -n ${commands[less]} ]]; then
    export PAGER=less
  else
    export PAGER=more
  fi
fi

if [[ -d "$HOME/.proto/tools/python/3.11.9/install/lib/python3.11/site-packages" ]]; then
  export PYTHONPATH="$HOME/.proto/tools/python/3.11.9/install/lib/python3.11/site-packages"
  export PATH="$HOME/.proto/tools/python/3.11.9/install/bin:$PATH"
fi

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
for command in lesspipe lesspipe.sh; do
  if [[ -n ${commands[$command]} ]]; then
    export LESSOPEN="| /usr/bin/env ${commands[$command]} %s 2>/dev/null"
    break
  fi
done

############### Temporary Files
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath manpath path

# Define global variables
default_proxy="http://127.0.0.1:2333"
no_proxy_list="127.0.0.1,localhost,auiag.corp,iag.com.au,devlabs,192.168.2.0/24,localaddress,.localdomain.com,192.168.99.100,192.168.10.100,iagcloud.net,192.168.49.2,DB8B4788812536AC063DABFD95299A5C.gr7.ap-southeast-2.eks.amazonaws.com"
# Function to set proxy environment variables
set_proxy_vars() {
  export http_proxy=$1
  export https_proxy=$1
  export ftp_proxy=$1
  export rsync_proxy=$1
  echo "Proxy environment variables set to $1"
}
# Enable proxy
proxy_on() {
  export no_proxy=$no_proxy_list
  export NO_PROXY=$no_proxy
  # Use the default proxy if no argument is provided
  local proxy_address=${1:-$default_proxy}
  set_proxy_vars "$proxy_address"
}
# Disable proxy
proxy_off() {
  unset http_proxy
  unset https_proxy
  unset ftp_proxy
  unset rsync_proxy
  unset no_proxy
  unset NO_PROXY
  echo "Proxy environment variables cleared."
}

# Start Colima & docker
# IS_COLIMA_NOT_RUNNING=$(colima status 2>&1 | grep "not running" || true)
# if [ "$IS_COLIMA_NOT_RUNNING" ]; then
#   echo "Start Colima VM"
#   # colima start --runtime docker --cpu 4 --memory 8
#   # colima start --arch x86_64 --cpu 2 --memory 8 --vm-type qemu
#   colima start --cpu 2 --memory 8 --arch x86_64 --vm-type vz --mount-type=virtiofs --network-address
# else
#   echo "Skip starting of Colima VM, because already running"
# fi
alias colimastart="colima start --cpu 2 --memory 8 --arch x86_64 --vm-type vz --mount-type=virtiofs --network-address"

# IS_COLIMA_AMD64_EMULATOR_RUNNING=`docker run --privileged --rm tonistiigi/binfmt | grep linux/amd64 || true`
# if [ "$IS_COLIMA_AMD64_EMULATOR_RUNNING" ]
# then
#   echo "Skip starting of amd64 emulator, because already running"
# else
#   echo "Start amd64 emulator in docker"
#   docker run --privileged --rm tonistiigi/binfmt --install amd64
# fi

# https://www.m3tech.blog/entry/dotfiles-bonsai
dockerrm() {
  docker container stop $(docker container ls -aq)
  docker ps -aq | xargs docker rm -f
  docker container prune -f
  docker images -aq | xargs docker rmi -f
  docker image prune -a -f
  docker volume prune -f
  docker network prune -f
  docker system prune -a -f
}

alias dockerrm="dockerrm"
alias colima:repair="colima stop -f && rm -rf /Users/$USER/.colima/_lima/_networks && colima start"
alias mgrey='mint run igorkulman/ChangeMenuBarColor Gradient "#000000" "#a39a9e" "/Users/kelvin/Pictures/pap.er/2429230316888522752.heic"'

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
  tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# Go to main branch and get latest code
mm() {
  local main_branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$main_branch" != "main" && "$main_branch" != "master" ]]; then
    main_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  fi
  git stash && git checkout $main_branch && git pull --rebase origin $main_branch
}

# venv() {
#   echo "loading venv"
#   if [ ! -d '.venv' ]; then
#     python -m venv .venv
#     . .venv/bin/activate
#     red "venv created and loaded"

#   else
#     . .venv/bin/activate
#     echo "venv loaded"
#   fi
# }

# Open the listed files or directories in Visual Studio Code
open_in_vscode() {
  if [ $# -eq 0 ]; then
    echo "Usage: open_in_vscode <directory_or_file> [<directory_or_file> ...]"
    return 1
  fi

  for item in "$@"; do
    if [ -e "$item" ]; then
      code "$item"
    else
      echo "Warning: '$item' does not exist. Skipping."
    fi
  done
}

# enter an interactive chat conversation using mods
chat() {
  # pick a model alias from your config
  model=$(yq -r .apis[].models[].aliases[0] ~/.config/mods/mods.yml |
    gum choose --height 8 --header "Pick model to chat with:" --no-show-help)
  if [[ -z $model ]]; then
    gum format "  :pensive:  cancelled, no model picked." -t emoji
    return 1
  fi
  # first invocation starts a new conversation
  mods --model "$model" --prompt-args || return $?
  # after that enter a loop until user quits
  while mods --model "$model" --prompt-args --continue-last; do :; done
  return $?
}

##############################################################
# ZimFW https://github.com/zimfw/zimfw
##############################################################
#ZIM_HOME=~/.cache/zim
ZIM_HOME="$ZDOTDIR"
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if command -v curl &>/dev/null; then
    curl -fsSL --create-dirs -o "${ZIM_HOME}/zimfw.zsh" \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p "${ZIM_HOME}" && wget -nv -O "${ZIM_HOME}/zimfw.zsh" \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key in '^[[A' '^P' ${terminfo[kcuu1]}; do
  bindkey ${key} history-substring-search-up
done
for key in '^[[B' '^N' ${terminfo[kcud1]}; do
  bindkey ${key} history-substring-search-down
done
for key in 'k'; do
  bindkey -M vicmd ${key} history-substring-search-up
done
for key in 'j'; do
  bindkey -M vicmd ${key} history-substring-search-down
done
unset key

##############################################################
# PATH.
# (N-/): do not register if the directory does not exists
# (Nn[-1]-/)
#
#  N   : NULL_GLOB option (ignore path if the path does not match the glob)
#  n   : Sort the output
#  [-1]: Select the last item in the array
#  -   : follow the symbol links
#  /   : ignore files
#  t   : tail of the path
##############################################################

path=(
  ${ZDOTDIR}/bin
  ${HOME}/.local/bin
  #${HOME}/.local/bin(N-/)
  #${CARGO_HOME}/bin(N-/)
  #${GOBIN}(N-/)
  ${GOBIN}
  $path
  #/opt/homebrew/bin(N-/) # For M1/2 machines
  /usr/local/{bin,sbin}
)
