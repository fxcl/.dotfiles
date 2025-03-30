# Static environment variables for appearance and behavior
export COLORTERM="truecolor"
# Cache the LS_COLORS value to avoid executing external command on every shell startup
if [[ ! -f "${XDG_CACHE_HOME:-$HOME/.cache}/ls_colors_cache" ]]; then
  mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}"
  vivid generate one-light > "${XDG_CACHE_HOME:-$HOME/.cache}/ls_colors_cache"
fi
export LS_COLORS="$(cat "${XDG_CACHE_HOME:-$HOME/.cache}/ls_colors_cache")"
export KEYTIMEOUT="1"
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{blue}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]?"
export LESS="-F -g -i -M -R -S -w -X -z-4"

# Core directory paths
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export DOTFILES="$HOME/.dotfiles"
export PROJECTS="$HOME/Sites/personal/dev"
export WORK="$HOME/Sites/work"
export PERSONAL_STORAGE="$HOME/Sync"
export NOTES_DIR="$PERSONAL_STORAGE/notes"
export ZK_NOTEBOOK_DIR=$NOTES_DIR

# XDG spec compliance - Application configs
export RLWRAP_HOME="$XDG_DATA_HOME/rlwrap"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export _ZO_DATA_DIR="$XDG_CONFIG_HOME/zoxide"
export KITTY_LISTEN_ON="unix:/tmp/kitty"
export EZA_COLORS="ur=35;nnn:gr=35;nnn:tr=35;nnn:uw=34;nnn:gw=34;nnn:tw=34;nnn:ux=36;nnn:ue=36;nnn:gx=36;nnn:tx=36;nnn:uu=36;nnn:uu=38;5;235:da=38;5;238"

# Disable telemetry
export DO_NOT_TRACK=1
export HOMEBREW_NO_ANALYTICS=1
export GATSBY_TELEMETRY_DISABLED=1
export NEXT_TELEMETRY_DISABLED=1
export ADBLOCK="true"

# Homebrew and Pure prompt configuration
export HOMEBREW_INSTALL_BADGE="⚽️"
export PURE_GIT_UP_ARROW="🠥"
export PURE_GIT_DOWN_ARROW="🠧"
export PURE_GIT_BRANCH="  "

# Python environment configuration
export PIP_CONFIG_FILE="$XDG_CONFIG_HOME/pip/pip.conf"
export PIP_LOG_FILE="$XDG_DATA_HOME/pip/log"
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME/python-eggs"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export PYLINTRC="$XDG_CONFIG_HOME/pylint/pylintrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PYLINTHOME="$XDG_DATA_HOME/pylint"

# User environment paths
export USER_BIN_HOME="$HOME/.local/bin"
export USER_ZSH_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
export USER_ZSH_SITE_FUNCTIONS="$USER_ZSH_DATA/site-functions"

# Initialize PATH with core directories - optimized to reduce path operations
# Group all path operations together to minimize array manipulations
path=(
  "${ZDOTDIR}/bin"
  "/usr/local/{bin,sbin}"
)

# Add all conditional paths in a single block to reduce multiple array operations
# Only perform directory checks once and store results in variables
[[ -d "${HOME}/.local/bin" ]] && local has_local_bin=1
[[ -n "${GOBIN}" && -d "${GOBIN}" ]] && local has_gobin=1
local is_macos_with_rustup=0
[[ "$OSTYPE" == darwin* && -d "/usr/local/Cellar/rustup/1.27.1_1/bin" ]] && is_macos_with_rustup=1
local has_cargo=0
[[ -d "${CARGO_HOME}/bin" ]] && has_cargo=1
local has_rustup=0
[[ -d "${RUSTUP_HOME}/bin" ]] && has_rustup=1

# Now add all paths in one operation based on the checks above
(( has_local_bin )) && path=("${HOME}/.local/bin" $path)
(( has_gobin )) && path=("${GOBIN}" $path)
(( is_macos_with_rustup )) && path+=("/usr/local/Cellar/rustup/1.27.1_1/bin")

# Add Cargo and Rustup paths if available
if (( has_cargo )); then
  path+=("${CARGO_HOME}/bin")
  (( has_rustup )) && path+=("${RUSTUP_HOME}/bin")
  # Cache rustc sysroot to avoid executing rustc on every shell startup
  if [[ -x "$(command -v rustc)" && ! -f "${XDG_CACHE_HOME:-$HOME/.cache}/rust_src_path" ]]; then
    mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}"
    rustc --print sysroot > "${XDG_CACHE_HOME:-$HOME/.cache}/rust_sysroot"
  fi

  if [[ -f "${XDG_CACHE_HOME:-$HOME/.cache}/rust_sysroot" ]]; then
    export RUST_SRC_PATH="$(cat "${XDG_CACHE_HOME:-$HOME/.cache}/rust_sysroot")/lib/rustlib/src/rust/src"
  fi
fi

# Add original path at the end
path+=($path)

# Remove path separator from WORDCHARS
WORDCHARS=${WORDCHARS//\[/}

# Configure pager and less settings - optimized to reduce command executions
# Only set PAGER if not already set
(( ! ${+PAGER} )) && export PAGER="${commands[less]:-more}"

# Cache lesspipe detection to avoid command lookup on every startup
if [[ ! -f "${XDG_CACHE_HOME:-$HOME/.cache}/lesspipe_path" ]]; then
  if (( $#commands[(i)lesspipe(|.sh)] )); then
    mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}"
    echo "$commands[(i)lesspipe(|.sh)]" > "${XDG_CACHE_HOME:-$HOME/.cache}/lesspipe_path"
  fi
fi

# Use cached lesspipe path if available
if [[ -f "${XDG_CACHE_HOME:-$HOME/.cache}/lesspipe_path" ]]; then
  export LESSOPEN="| /usr/bin/env $(cat "${XDG_CACHE_HOME:-$HOME/.cache}/lesspipe_path") %s 2>&-"
fi

# Set up temporary directory - simplified with inline conditional
[[ ! -d "$TMPDIR" ]] && {
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
}
TMPPREFIX="${TMPDIR%/}/zsh"

# Ensure path arrays don't contain duplicates
typeset -gU cdpath fpath mailpath manpath path

# Proxy configuration - optimized with readonly variables to prevent modification
readonly _DEFAULT_PROXY="http://127.0.0.1:2333"
readonly _NO_PROXY_LIST="127.0.0.1,localhost,auiag.corp,iag.com.au,devlabs,192.168.2.0/24,localaddress,.localdomain.com,192.168.99.100,192.168.10.100,iagcloud.net,192.168.49.2,DB8B4788812536AC063DABFD95299A5C.gr7.ap-southeast-2.eks.amazonaws.com"

# Proxy management functions - optimized with brace expansion for variable operations
proxy_on() {
  # Use parameter expansion for default value and brace expansion for multiple exports
  local proxy=${1:-$_DEFAULT_PROXY}
  export {http,https,ftp,rsync}_proxy=$proxy
  export {no,NO}_proxy=$_NO_PROXY_LIST
}

proxy_off() {
  # Use brace expansion for multiple unsets in one operation
  unset {http,https,ftp,rsync}_proxy {no,NO}_proxy
}
