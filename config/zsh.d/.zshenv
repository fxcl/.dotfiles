################################################################################
# ZSH ENVIRONMENT CONFIGURATION - OPTIMIZED FOR PERFORMANCE
################################################################################

# Fast directory existence check
_is_dir() { [[ -d "$1" ]] }

################################################################################
# ESSENTIAL ENVIRONMENT VARIABLES - LOADED FIRST
################################################################################

# Core paths - essential for other configurations
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export DOTFILES="${HOME}/.dotfiles"
export USER_BIN_HOME="${HOME}/.local/bin"
export USER_ZSH_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
export USER_ZSH_SITE_FUNCTIONS="${USER_ZSH_DATA}/site-functions"

# Terminal settings - required for proper operation
export COLORTERM="truecolor"
export KEYTIMEOUT="1"
export PAGER="$(command -v less || echo more)"
export LESS="-F -g -i -M -R -S -w -X -z-4"

################################################################################
# PATH CONFIGURATION - OPTIMIZED FOR LOOKUP SPEED
#
# Paths are prepended to the `path` array. `typeset -gU path` at the end
# ensures uniqueness. The order of prepending determines precedence (last is first).
################################################################################

# Initialize PATH with base system path and Zsh-specific bin
path=(
  "${ZDOTDIR}/bin"
  "/usr/local/bin"
  "/usr/local/sbin"
  $path
)

# OS-specific paths (macOS)
if [[ "$OSTYPE" == darwin* ]]; then
  # Note: The glob '*' will expand to any matching cellar paths.
  # Globs are expanded here. If no match, the literal path is checked and fails `_is_dir`.
  local os_specific_paths=(/opt/homebrew/bin /usr/local/Cellar/rustup/*/bin)
  for dir in "${os_specific_paths[@]}"; do
    _is_dir "${dir}" && path=("${dir}" $path)
  done
fi

# User-specific and language toolchain paths
_is_dir "${USER_BIN_HOME}" && path=("${USER_BIN_HOME}" $path)
_is_dir "${GOBIN}" && path=("${GOBIN}" $path)

# Rust toolchain paths - grouped check for performance
if _is_dir "${CARGO_HOME}/bin"; then
  path=("${CARGO_HOME}/bin" $path)
  _is_dir "${RUSTUP_HOME}/bin" && path=("${RUSTUP_HOME}/bin" $path)
  # Dynamically set RUST_SRC_PATH if rust is available
  if command -v rustc >/dev/null 2>&1; then
    export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
  fi
fi

################################################################################
# XDG COMPLIANCE AND PRIVACY
################################################################################

# Development tools
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export RLWRAP_HOME="${XDG_DATA_HOME}/rlwrap"
export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"
export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
export ELINKS_CONFDIR="${XDG_CONFIG_HOME}/elinks"
export KITTY_LISTEN_ON="unix:/tmp/kitty"

# Python environment
export PIP_CONFIG_FILE="${XDG_CONFIG_HOME}/pip/pip.conf"
export PIP_LOG_FILE="${XDG_DATA_HOME}/pip/log"
export PYTHON_EGG_CACHE="${XDG_CACHE_HOME}/python-eggs"
export JUPYTER_CONFIG_DIR="${XDG_CONFIG_HOME}/jupyter"
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"
export PYLINTRC="${XDG_CONFIG_HOME}/pylint/pylintrc"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc"
export PYLINTHOME="${XDG_DATA_HOME}/pylint"

# Privacy settings
export DO_NOT_TRACK=1
export HOMEBREW_NO_ANALYTICS=1
export GATSBY_TELEMETRY_DISABLED=1
export NEXT_TELEMETRY_DISABLED=1
export ADBLOCK=true

################################################################################
# PROJECT DIRECTORIES AND APPEARANCE
################################################################################

# Project paths
export PROJECTS="${HOME}/Sites/personal/dev"
export WORK="${HOME}/Sites/work"
export PERSONAL_STORAGE="${HOME}/Sync"
export NOTES_DIR="${PERSONAL_STORAGE}/notes"
export ZK_NOTEBOOK_DIR="${NOTES_DIR}"

# Appearance settings
export EZA_COLORS="ur=35;nnn:gr=35;nnn:tr=35;nnn:uw=34;nnn:gw=34;nnn:tw=34;nnn:ux=36;nnn:ue=36;nnn:gx=36;nnn:tx=36;nnn:uu=36;nnn:uu=38;5;235:da=38;5;238"
export HOMEBREW_INSTALL_BADGE="⚽️"
export PURE_GIT_UP_ARROW="🠥"
export PURE_GIT_DOWN_ARROW="🠧"
export PURE_GIT_BRANCH="  "
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{blue}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]?"

################################################################################
# SHELL BEHAVIOR AND TEMPORARY FILES
################################################################################

# Word character handling
WORDCHARS=${WORDCHARS//\[/}

# Less configuration
# Set up lesspipe if available for richer `less` output.
for cmd in lesspipe lesspipe.sh; do
  if command -v "$cmd" >/dev/null 2>&1; then
    export LESSOPEN="| /usr/bin/env $cmd %s 2>&-"
    break
  fi
done

# Temporary directory setup
if [[ ! -d "${TMPDIR}" ]]; then
  export TMPDIR="/tmp/${LOGNAME}"
  mkdir -p -m 700 "${TMPDIR}"
fi
TMPPREFIX="${TMPDIR%/}/zsh"

# Ensure unique paths
typeset -gU cdpath fpath mailpath manpath path

################################################################################
# NETWORK CONFIGURATION - OPTIMIZED PROXY MANAGEMENT
################################################################################

# Proxy configuration
typeset -gr _PROXY_URL="http://127.0.0.1:2333"
local -a _no_proxy_hosts=(
  # Loopback
  "127.0.0.1" "localhost"
  # Local network & domains
  "auiag.corp" "iag.com.au" "devlabs" "localaddress" ".localdomain.com"
  # IP ranges and specific IPs
  "192.168.2.0/24" "192.168.99.100" "192.168.10.100" "192.168.49.2"
  # Cloud services
  "iagcloud.net" "DB8B4788812536AC063DABFD95299A5C.gr7.ap-southeast-2.eks.amazonaws.com"
)
typeset -gr _NO_PROXY="${(j:,:)_no_proxy_hosts}"
unset _no_proxy_hosts

# Proxy management functions
proxy_on() {
  local proxy_url="${1:-$_PROXY_URL}"
  export {http,https,ftp,rsync}_proxy="$proxy_url"
  # Set both no_proxy and NO_PROXY for compatibility with various tools.
  export no_proxy="$_NO_PROXY"
  export NO_PROXY="$_NO_PROXY"
  print "Proxy enabled: ${proxy_url}"
}

proxy_off() {
  unset {http,https,ftp,rsync}_proxy no_proxy NO_PROXY
  print "Proxy disabled."
}
