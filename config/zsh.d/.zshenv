# Static environment variables for appearance and behavior
export COLORTERM="truecolor"
# export LS_COLORS=$(vivid generate one-light)
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

# Initialize PATH with core directories
path=(
  "${ZDOTDIR}/bin"
  "/usr/local/{bin,sbin}"
  $path
)

# Add conditional paths only if they exist
[[ -d "${HOME}/.local/bin" ]] && path=("${HOME}/.local/bin" $path)
[[ -n "${GOBIN}" && -d "${GOBIN}" ]] && path=("${GOBIN}" $path)


# Add Rust-related paths on macOS
if [[ "$OSTYPE" == darwin* && -d "/usr/local/Cellar/rustup/1.27.1_1/bin" ]]; then
  path+=("/usr/local/Cellar/rustup/1.27.1_1/bin")
fi

# Add Cargo and Rustup paths if available
if [[ -d "${CARGO_HOME}/bin" ]]; then
  path+=("${CARGO_HOME}/bin")
  [[ -d "${RUSTUP_HOME}/bin" ]] && path+=("${RUSTUP_HOME}/bin")
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi

# Remove path separator from WORDCHARS
WORDCHARS=${WORDCHARS//\[/}

# Configure pager settings
if (( ! ${+PAGER} )); then
  export PAGER="${commands[less]:-more}"
fi

# Set up Less preprocessor
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# Set up temporary directory
[[ ! -d "$TMPDIR" ]] && {
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
}
TMPPREFIX="${TMPDIR%/}/zsh"


# Ensure path arrays don't contain duplicates
typeset -gU cdpath fpath mailpath manpath path

# Proxy configuration
default_proxy="http://127.0.0.1:2333"
no_proxy_list="127.0.0.1,localhost,auiag.corp,iag.com.au,devlabs,192.168.2.0/24,localaddress,.localdomain.com,192.168.99.100,192.168.10.100,iagcloud.net,192.168.49.2,DB8B4788812536AC063DABFD95299A5C.gr7.ap-southeast-2.eks.amazonaws.com"

# Proxy management functions
proxy_on() {
  local proxy=${1:-$default_proxy}
  export {http,https,ftp,rsync}_proxy=$proxy
  export {no,NO}_proxy=$no_proxy_list
}

proxy_off() {
  unset {http,https,ftp,rsync}_proxy {no,NO}_proxy
}
