################################################################################
# ZSH ENVIRONMENT CONFIGURATION - OPTIMIZED FOR PERFORMANCE
################################################################################

################################################################################
# TERMINAL APPEARANCE AND BEHAVIOR
################################################################################

# Terminal color and input settings
export COLORTERM="truecolor"                # Enable true color support
export KEYTIMEOUT="1"                      # Reduce delay for vi mode key sequences

# Spelling correction prompt format
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{blue}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]?"

# Less pager options for better readability
# -F: quit if one screen, -g: highlight search, -i: ignore case
# -M: verbose prompt, -R: raw control chars, -S: chop long lines
# -w: highlight first unread line, -X: don't clear screen, -z-4: scroll size
export LESS="-F -g -i -M -R -S -w -X -z-4"

################################################################################
# DIRECTORY STRUCTURE - CORE PATHS
################################################################################

# Essential directory paths - grouped for clarity
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"       # ZSH configuration directory
export DOTFILES="$HOME/.dotfiles"           # Dotfiles repository location

# Project directories
export PROJECTS="$HOME/Sites/personal/dev"   # Personal development projects
export WORK="$HOME/Sites/work"               # Work-related projects

# Personal data storage
export PERSONAL_STORAGE="$HOME/Sync"         # Synced personal files
export NOTES_DIR="$PERSONAL_STORAGE/notes"   # Notes directory
export ZK_NOTEBOOK_DIR="$NOTES_DIR"          # ZK notebook location

################################################################################
# XDG COMPLIANCE - REDUCE HOME DIRECTORY CLUTTER
################################################################################

# Group related application configs for better organization

# Development tools
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export _ZO_DATA_DIR="$XDG_CONFIG_HOME/zoxide"
export RLWRAP_HOME="$XDG_DATA_HOME/rlwrap"

# AWS configuration
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"

# Terminal applications
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export KITTY_LISTEN_ON="unix:/tmp/kitty"

# File listing colors for eza
export EZA_COLORS="ur=35;nnn:gr=35;nnn:tr=35;nnn:uw=34;nnn:gw=34;nnn:tw=34;nnn:ux=36;nnn:ue=36;nnn:gx=36;nnn:tx=36;nnn:uu=36;nnn:uu=38;5;235:da=38;5;238"

################################################################################
# PRIVACY SETTINGS - DISABLE TELEMETRY
################################################################################

# Disable various telemetry and analytics
export DO_NOT_TRACK=1                      # General do-not-track flag
export HOMEBREW_NO_ANALYTICS=1             # Disable Homebrew analytics
export GATSBY_TELEMETRY_DISABLED=1         # Disable Gatsby telemetry
export NEXT_TELEMETRY_DISABLED=1           # Disable Next.js telemetry
export ADBLOCK="true"                      # Enable ad blocking where supported

################################################################################
# TOOL-SPECIFIC CONFIGURATION
################################################################################

# Homebrew and prompt appearance
export HOMEBREW_INSTALL_BADGE="⚽️"         # Custom Homebrew install icon

# Pure prompt git symbols
export PURE_GIT_UP_ARROW="🠥"               # Commits ahead of remote
export PURE_GIT_DOWN_ARROW="🠧"             # Commits behind remote
export PURE_GIT_BRANCH="  "                # Branch symbol

################################################################################
# PYTHON ENVIRONMENT - XDG COMPLIANCE
################################################################################

# Python tools configuration paths
export PIP_CONFIG_FILE="$XDG_CONFIG_HOME/pip/pip.conf"
export PIP_LOG_FILE="$XDG_DATA_HOME/pip/log"
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME/python-eggs"

# Python development environment
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export PYLINTRC="$XDG_CONFIG_HOME/pylint/pylintrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PYLINTHOME="$XDG_DATA_HOME/pylint"

################################################################################
# PATH CONFIGURATION - OPTIMIZED FOR PERFORMANCE
################################################################################

# User-specific paths
export USER_BIN_HOME="$HOME/.local/bin"
export USER_ZSH_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
export USER_ZSH_SITE_FUNCTIONS="$USER_ZSH_DATA/site-functions"

# Initialize PATH with core directories - most frequently used first for faster lookup
path=(
  "${ZDOTDIR}/bin"                # ZSH scripts directory
  "/usr/local/{bin,sbin}"         # Homebrew binaries
  $path                           # Existing PATH entries
)

# Conditionally add paths - only if they exist (reduces startup time)
[[ -d "${HOME}/.local/bin" ]] && path=("${HOME}/.local/bin" $path)
[[ -n "${GOBIN}" && -d "${GOBIN}" ]] && path=("${GOBIN}" $path)

# Platform-specific paths - macOS Rust tools
if [[ "$OSTYPE" == darwin* && -d "/usr/local/Cellar/rustup/1.27.1_1/bin" ]]; then
  path+=("/usr/local/Cellar/rustup/1.27.1_1/bin")
fi

# Rust toolchain paths - grouped for clarity
if [[ -d "${CARGO_HOME}/bin" ]]; then
  path+=("${CARGO_HOME}/bin")
  [[ -d "${RUSTUP_HOME}/bin" ]] && path+=("${RUSTUP_HOME}/bin")
  # Only evaluate rustc command when Cargo is available
  export RUST_SRC_PATH="$(rustc --print sysroot 2>/dev/null)/lib/rustlib/src/rust/src"
fi

################################################################################
# SHELL BEHAVIOR CONFIGURATION
################################################################################

# Word character handling for better word navigation
WORDCHARS=${WORDCHARS//\[/}              # Remove path separator from WORDCHARS

# Pager configuration - only set if not already defined
(( ! ${+PAGER} )) && export PAGER="${commands[less]:-more}"

# Set up Less preprocessor for better file viewing
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# Temporary directory setup - create if needed
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi
TMPPREFIX="${TMPDIR%/}/zsh"

# Ensure path arrays don't contain duplicates - improves lookup performance
typeset -gU cdpath fpath mailpath manpath path

################################################################################
# NETWORK CONFIGURATION
################################################################################

# Proxy settings - defined but not enabled by default
default_proxy="http://127.0.0.1:2333"
no_proxy_list="127.0.0.1,localhost,auiag.corp,iag.com.au,devlabs,192.168.2.0/24,localaddress,.localdomain.com,192.168.99.100,192.168.10.100,iagcloud.net,192.168.49.2,DB8B4788812536AC063DABFD95299A5C.gr7.ap-southeast-2.eks.amazonaws.com"

# Proxy management functions - enable/disable proxy as needed
proxy_on() {
  local proxy=${1:-$default_proxy}
  export {http,https,ftp,rsync}_proxy=$proxy
  export {no,NO}_proxy=$no_proxy_list
}

proxy_off() {
  unset {http,https,ftp,rsync}_proxy {no,NO}_proxy
}
