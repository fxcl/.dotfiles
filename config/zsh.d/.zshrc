# vim:ft=zsh:
# setopt warn_create_global

# Performance measurement
if [[ -n "$ZSH_PROFILE" ]]; then
  zmodload zsh/zprof
  zmodload zsh/datetime
  setopt promptsubst
  PS4='+$EPOCHREALTIME %N:%i> '
  exec 3>&2 2> "${TMPDIR}/zshstart.$$"
  setopt xtrace
fi

# Initialize ZimFW (delayed loading)
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
if [[ -s ${ZIM_HOME}/zimfw.zsh ]]; then
  if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
    # Update static initialization script if it's outdated, before sourcing it
    source ${ZIM_HOME}/zimfw.zsh init -q
  fi
  source ${ZIM_HOME}/init.zsh
else
  echo "No Zim Fixing this crap..."
  # Download zimfw script
  local -r ztarget=${ZIM_HOME}/zimfw.zsh
  if (
    command mkdir -p ${ZIM_HOME} || return 1
    local -r zurl=https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
    if (( ${+commands[curl]} )); then
      command curl -fsSL -o ${ztarget} ${zurl} || return 1
    elif (( ${+commands[wget]} )); then
      command wget -nv -O ${ztarget} ${zurl} || return 1
    else
      print -u2 -P '%F{red}x Either %Bcurl%b or %Bwget%b are required to download the Zim script.%f'
      return 1
    fi
  ); then
    print -PR "%F{green})%f Downloaded the Zim script to %B${ztarget}%b"
  else
    command rm -rf ${ZIM_HOME}
    print -u2 -PR "%F{red}x Could not download the Zim script to %B${ztarget}%b%f"
    return 1
  fi
fi
# Zim module debug (disable by default)
# typeset -g ZPLG_MOD_DEBUG=1

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# History configuration (optimized for performance)
HISTSIZE=50000
SAVEHIST=100000
# 使用更高效的历史记录选项组合
setopt EXTENDED_HISTORY        # 记录时间戳和持续时间
setopt HIST_EXPIRE_DUPS_FIRST  # 优先删除重复记录
setopt HIST_IGNORE_ALL_DUPS    # 完全去重
setopt HIST_FIND_NO_DUPS       # 搜索时不显示重复
setopt HIST_REDUCE_BLANKS      # 删除多余空白
setopt HIST_SAVE_NO_DUPS       # 保存时去重
setopt SHARE_HISTORY           # 实时共享历史
setopt HIST_IGNORE_SPACE       # 忽略空格开头的命令

fpath=(
  ${ZDOTDIR}/functions
  $fpath
)
autoload -Uz ${ZDOTDIR}/functions/**/*(N:t)

PURE_SYMBOLS=("λ" "ϟ" "▲" "∴" "→" "»" "৸")
# Arrays in zsh starts from 1
export PURE_PROMPT_SYMBOL="${PURE_SYMBOLS[$RANDOM % ${#PURE_SYMBOLS[@]} + 1]}"

# For speed:
# https://github.com/zsh-users/zsh-autosuggestions#disabling-automatic-widget-re-binding

# Optimize zsh-autosuggestions for performance
export ZSH_AUTOSUGGEST_USE_ASYNC="true"
export ZSH_AUTOSUGGEST_STRATEGY=("match_prev_cmd")
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=30
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c50,)"

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Note that this will only ensure unique history if we supply a prefix
# before hitting "up" (ie. we perform a "search"). HIST_FIND_NO_DUPS
# won't prevent dupes from appearing when just hitting "up" without a
# prefix (ie. that's "zle up-line-or-history" and not classified as a
# "search"). So, we have HIST_IGNORE_DUPS to make life bearable for that
# case.
#
# https://superuser.com/a/1494647/322531
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

############### Misc
if [[ "$OSTYPE" = "darwin"* ]]; then
  # For context https://github.com/github/hub/pull/1962
  # I run in the background to not affect startup time.
  # https://github.com/ahmedelgabri/dotfiles/commit/c8156c2f0cf74917392a0e700668005b8f1bbbdb#r33940655
  (
    if [ -e /usr/local/share/zsh/site-functions/_git ]; then
      command mv -f /usr/local/share/zsh/site-functions/{,disabled.}_git
    fi
  )
fi

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

############### Telemetry
export DO_NOT_TRACK=1 # Future proof? https://consoledonottrack.com/
export HOMEBREW_NO_ANALYTICS=1
export GATSBY_TELEMETRY_DISABLED=1
export NEXT_TELEMETRY_DISABLED=1
export ADBLOCK="true"

############### Homebrew
export HOMEBREW_INSTALL_BADGE="⚽️"

# Use cyan colour scaling for the dates column, as the default blue is difficult to read.
if command -v eza &>/dev/null; then
  export EZA_COLORS="ur=35;nnn:gr=35;nnn:tr=35;nnn:uw=34;nnn:gw=34;nnn:tw=34;nnn:ux=36;nnn:due=36;nnn:gx=36;nnn:tx=36;nnn:uu=36;nnn:uu=38;5;235:da=38;5;238"
fi

############### Temporary Files
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

# Download proto manager if missing.

if test ! $(which proto); then
  echo "Installing proto..."
  curl -fsSL https://moonrepo.dev/install/proto.sh | bash
  #proto setup
  #proto install node lts
  #proto install yarn
  #proto install pnpm
  #proto install bun
  #proto install rust

  echo 'Done'
fi

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
  eval "$(proto activate zsh -c global)"
  #eval "$(proto activate zsh --no-bin --no-shim)"
  # alias puse="proto pin --resolve --global"
  alias plist="proto list --aliases"
  alias psearch="proto list-remote --aliases"
  alias pupgrade="proto upgrade"

  # Cache proto command path and versions
  typeset -g _PROTO_CMD=$(command -v proto)
  typeset -gA _PROTO_VERSION_CACHE=()

  # Handle version argument with caching
  function _proto_handle_version() {
    local cache_key="$1:$2"
    if [[ -n "${_PROTO_VERSION_CACHE[$cache_key]}" ]]; then
      echo "${_PROTO_VERSION_CACHE[$cache_key]}"
      return
    fi

    if [[ -z $2 ]]; then
      echo -e "\033[0;33mWarning: No version provided for $1. Using 'latest'.\033[0m\n" >&2
      _PROTO_VERSION_CACHE[$cache_key]="latest"
    else
      _PROTO_VERSION_CACHE[$cache_key]="$2"
    fi

    echo "${_PROTO_VERSION_CACHE[$cache_key]}"
  }

  # Clear version cache
  function pclear-cache() {
    _PROTO_VERSION_CACHE=()
    echo "Proto version cache cleared"
  }

  function pinstall() {
    [[ $# -eq 0 ]] && { echo "Usage: pinstall <tool> [version]" >&2; return 1; }
    $_PROTO_CMD install --pin global $1 $(_proto_handle_version $1 $2)
  }

  function prm() {
    [[ $# -eq 0 ]] && { echo "Usage: prm <tool> [version]" >&2; return 1; }
    $_PROTO_CMD uninstall $1 $(_proto_handle_version $1 $2)
  }

  function puse() {
    [[ $# -eq 0 ]] && { echo "Usage: puse <tool> [version]" >&2; return 1; }
    $_PROTO_CMD pin --resolve --global $1 $(_proto_handle_version $1 $2)
  }
  # Handle directory argument with default $PROTO_HOME
  function _proto_handle_directory() {
    local arg=$1
    if [[ -f .prototools ]]; then
      echo "."
    elif [[ -z $arg ]]; then
      echo -e "\033[0;33mWarning: No directory provided. Checking global tools...\033[0m\n"
      echo "$PROTO_HOME"
    elif [[ -d $arg ]]; then
      echo "$arg"
    else
      echo -e "\033[0;31mError: Invalid directory '$arg'\033[0m" >&2
      return 1
    fi
  }

  function poutdated() {
    local dir=$(_proto_handle_directory $1) || return $?
    (cd $dir && proto outdated)
  }

  function ptools() {
    local dir=$(_proto_handle_directory $1) || return $?
    (cd $dir && proto status)
  }

  function phelp() {
    echo "Proto Tool Manager - Custom Commands"
    echo
    echo "Usage: p<command> [arguments]"
    echo
    echo "Core Commands:"
    echo "  puse <tool> [version]       Pin tool version (default: latest)"
    echo "  pinstall <tool> [version]   Install tool version (default: latest)"
    echo "  prm <tool> [version]        Uninstall tool version (default: latest)"
    echo
    echo "Info Commands:"
    echo "  plist [tool]                List installed versions"
    echo "  psearch <tool>              Search available versions"
    echo "  pupgrade                    Upgrade Proto itself"
    echo
    echo "Project Commands:"
    echo "  poutdated [dir]             Check for outdated tools (default: global)"
    echo "  ptools [dir]                List installed tools (default: global)"
    echo
    echo "Examples:"
    echo "  pinstall node 20.0.0        # Install specific version"
    echo "  puse node                   # Use latest version"
    echo "  poutdated ~/projects/my-app # Check project tools"
  }
fi

#proto node global
if [ -d "${PROTO_HOME}/tools/node/globals/bin" ]; then
  export PATH="${PATH}:${PROTO_HOME}/tools/node/globals/bin"
fi

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

alias colimastart="colima start --cpu 2 --memory 8 --arch x86_64 --vm-type vz --mount-type=virtiofs --network-address"

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

# config clang
if command -v clang++ >/dev/null 2>&1; then
  export CXXFLAGS="-stdlib=libc++"
  export LDFLAGS="-stdlib=libc++"
  # export CXX=clang++
fi

##############################################################
# LOCAL.
##############################################################

# Disabled host-specific config for better VSCode compatibility
if [ -f $HOST_CONFIGS/zshrc ]; then
  source $HOST_CONFIGS/zshrc
fi

if [ -e /etc/motd ]; then
  if ! cmp -s ${HOME}/.hushlogin /etc/motd; then
    tee ${HOME}/.hushlogin </etc/motd
  fi
fi
