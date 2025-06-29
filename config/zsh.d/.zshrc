# vim:ft=zsh:
################################################################################
# ZSH RUNTIME CONFIGURATION - OPTIMIZED FOR PERFORMANCE & READABILITY
################################################################################

# Load essential Zsh modules for performance and functionality.
# zsh/system: Provides system-level operation support for features like zdelay.
# zmodload zsh/zprof # Uncomment for startup performance analysis.
zmodload zsh/system

################################################################################
# ENVIRONMENT & DIRECTORY SETUP
################################################################################

# Define and ensure XDG Base Directories exist.
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Ensure required Zsh directories exist within the XDG structure.
mkdir -p "$XDG_CACHE_HOME/zsh/zi"

################################################################################
# CORE UTILITY FUNCTIONS
################################################################################

# Checks if a command exists. Uses `command -v` for POSIX compliance and speed.
# Caching is handled by the shell's command hash table.
has() {
  command -v "$1" >/dev/null 2>&1
}

# A precise delay function using zsh/system's flock.
# This is a non-blocking sleep alternative for staggering background jobs.
# @param $1: Delay in seconds (can be a float, e.g., 0.5).
zdelay() {
  local delay=$1
  local delay_ms
  # Use zsh's built-in float support.
  delay_ms=$((delay * 1000))
  # Use the integer part for flock's timeout.
  zsystem flock -t ${delay_ms%.*} /dev/null
}

# Helper to load an external tool via ZI with a staggered delay.
# This prevents multiple tools from initializing simultaneously and slowing down the prompt.
# @param $1: Tool name (for `has` check).
# @param $2: ZI plugin ID (for `id-as`).
# @param $3: Delay in seconds.
# @param $4: Initialization script to run via `atload`.
_load_tool_deferred() {
    local tool_name="$1"
    local plugin_id="$2"
    local delay="$3"
    local init_script="$4"

    if has "$tool_name"; then
        zi ice lucid id-as"$plugin_id" atload"
            zdelay $delay
            $init_script
        "
        zi light zdharma-continuum/null
    fi
}

################################################################################
# HISTORY CONFIGURATION
################################################################################

# Use a large history file for better command recall.
HISTSIZE=1000000
SAVEHIST="$HISTSIZE"
HISTFILE="${XDG_DATA_HOME}/.zsh_history"

# History options for a better experience.
setopt HIST_IGNORE_DUPS          # Don't record dupes in history.
setopt HIST_IGNORE_ALL_DUPS      # If a new command is a duplicate, remove the older one.
setopt HIST_FIND_NO_DUPS         # Don't show dupes when searching.
setopt HIST_SAVE_NO_DUPS         # Don't save dupes to the history file.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_VERIFY               # Don't execute history expansion commands immediately.

################################################################################
# FUNCTION & COMPLETION PATH CONFIGURATION
################################################################################

# Prioritize user-defined functions for faster lookups.
fpath=(
  "${ZDOTDIR}/functions" # User-defined functions
  $fpath                 # System functions
)

# Add Homebrew's site-functions to fpath if available.
if has brew; then
  local brew_prefix="/opt/homebrew"
  # Fallback for Intel Macs or custom installations.
  [[ ! -d "$brew_prefix" ]] && brew_prefix="$(brew --prefix 2>/dev/null || echo /usr/local)"
  [[ -d "$brew_prefix/share/zsh/site-functions" ]] && fpath=("$brew_prefix/share/zsh/site-functions" $fpath)
  unset brew_prefix
fi

# Autoload all function files from the user's function directory.
# The `(N:t)` glob qualifier makes this safe and efficient:
# N: Null glob - don't error if no files are found.
# :t: Tail - return only the basename of the file.
autoload -Uz ${ZDOTDIR}/functions/**/*(N:t)

################################################################################
# ZI PLUGIN MANAGER - SETUP & CONFIGURATION
################################################################################

# Centralized ZI configuration using a global associative array.
typeset -gA ZI=(
  [HOME_DIR]="$XDG_CACHE_HOME/zsh/zi"
  [BIN_DIR]="$XDG_CACHE_HOME/zsh/zi/bin"
  [PLUGINS_DIR]="$XDG_CACHE_HOME/zsh/zi/plugins"
  [ZCOMPDUMP_PATH]="$XDG_CACHE_HOME/zsh/.zcompdump"
  [COMPINIT_OPTS]="-C -d ${ZI[ZCOMPDUMP_PATH]}"
)
ZPFX="$ZI[HOME_DIR]/polaris"

# Install ZI if it's not already present.
if [[ ! -f "${ZI[BIN_DIR]}/zi.zsh" ]] && has git; then
  command git clone --depth 1 https://github.com/z-shell/zi.git "${ZI[BIN_DIR]}"
fi

# Load ZI and its completions.
if [[ -f "${ZI[BIN_DIR]}/zi.zsh" ]]; then
  source "${ZI[BIN_DIR]}/zi.zsh"
  autoload -Uz _zi
  # Register `zi` for completion.
  [[ -v _comps ]] && _comps[zi]=_zi
fi

################################################################################
# PROMPT & INTERACTIVE FEATURES
################################################################################

# Initialize the prompt system before configuring it.
autoload -Uz promptinit && promptinit

# --- Pure Prompt Theme ---
# Select a random prompt symbol for a bit of variety.
local PURE_SYMBOLS=("λ" "ϟ" "▲" "∴" "→" "»" "৸")
export PURE_PROMPT_SYMBOL="${PURE_SYMBOLS[$RANDOM % ${#PURE_SYMBOLS[@]} + 1]}"

# Load Pure theme using ZI's light mode for speed.
# This compiles the theme files for faster loading on subsequent startups.
zi light-mode for \
  compile'(pure|async).zsh' \
  pick'async.zsh' \
  src'pure.zsh' \
  atload'prompt pure' \
  sindresorhus/pure

# --- Pure Theme Styling ---
zstyle :prompt:pure:path color 240
zstyle :prompt:pure:git:branch color blue
zstyle :prompt:pure:git:dirty color red
zstyle :prompt:pure:git:action color 005
zstyle :prompt:pure:prompt:success color 003

# --- Interactive Plugins (Autosuggestions & History Search) ---
# Load essential interactive plugins with a slight delay to keep the prompt responsive.

# History Substring Search
zi ice lucid id-as'history-search' atload'
    zdelay 0.1
    bindkey "${terminfo[kcuu1]}" history-substring-search-up
    bindkey "${terminfo[kcud1]}" history-substring-search-down
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
'
zi light zsh-users/zsh-history-substring-search

# Autosuggestions
zi ice lucid id-as'auto-suggest' atload'
    zdelay 0.3
    _zsh_autosuggest_start
'
zi light zsh-users/zsh-autosuggestions

################################################################################
# COMPLETION SYSTEM
################################################################################

# Load the main completion system configuration.
# This includes compinit and other completion settings.
source "${ZDOTDIR}/config/completion.zsh"

################################################################################
# EXTERNAL TOOLS INTEGRATION (DEFERRED LOADING)
################################################################################

# Load external tools with staggered delays to improve startup time.
# The `_load_tool_deferred` helper function is used for clarity and consistency.

# Priority 1: Immediate loading (essential for shell interaction)
if has zoxide && [[ ! -v _ZOXIDE_INITIALIZED ]]; then
  zi wait lucid id-as"zoxide" as"null" atload'
    export _ZOXIDE_INITIALIZED=1
    eval "$(zoxide init zsh --hook pwd 2>/dev/null)"
  ' for zdharma-continuum/null
fi

# Priority 2-4: Delayed loading for less critical tools
_load_tool_deferred 'direnv' 'direnv-loader' 0.5 'eval "$(direnv hook zsh)"'
_load_tool_deferred 'fzf' 'fzf-loader' 1.0 'source <(fzf --zsh)'
_load_tool_deferred 'starship' 'starship-loader' 2.0 'eval "$(starship init zsh --print-full-init)"'

# The original implementation wrote init scripts to files inside the ZI plugins
# directory. This version uses `eval` or `source <()` which is cleaner and avoids
# writing temporary files.

################################################################################
# LOCAL & SYSTEM-SPECIFIC CONFIGURATION
################################################################################

# Load optional local configurations if they exist.
[[ -f "$ZDOTDIR/bin/proto" ]] && source "$ZDOTDIR/bin/proto"
[[ -f "$HOST_CONFIGS/zshrc" ]] && source "$HOST_CONFIGS/zshrc"

# Suppress the "Last login" message by creating .hushlogin.
# Copies the message of the day (motd) into it once.
[[ -e /etc/motd ]] && [[ ! -f "${HOME}/.hushlogin" ]] && tee "${HOME}/.hushlogin" < /etc/motd >/dev/null

################################################################################
# PERFORMANCE ANALYSIS (DISABLED BY DEFAULT)
################################################################################

# To analyze startup time, uncomment the `zmodload zsh/zprof` at the top
# of the file and uncomment the `zprof` command below.
# zprof
