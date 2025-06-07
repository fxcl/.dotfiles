# vim:ft=zsh:
################################################################################
# ZSH RUNTIME CONFIGURATION - OPTIMIZED FOR PERFORMANCE
################################################################################

# Load Zsh Performance Analysis Modules
# zsh/zprof: For analyzing Zsh startup time and performance
# zsh/mathfunc: Provides mathematical function support
# zsh/system: Provides system-level operation support
# zmodload zsh/zprof
zmodload zsh/mathfunc
zmodload zsh/system

# Ensure XDG directories exist
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Ensure required directories exist
[[ ! -d "$XDG_CACHE_HOME/zsh" ]] && mkdir -p "$XDG_CACHE_HOME/zsh"
[[ ! -d "$XDG_CACHE_HOME/zsh/zi" ]] && mkdir -p "$XDG_CACHE_HOME/zsh/zi"

################################################################################
# CORE UTILITY FUNCTIONS - LOADED FIRST FOR DEPENDENCY RESOLUTION
################################################################################

# Check if a command exists - optimized version with caching
has() {
  command -v "$1" >/dev/null 2>&1
}

# Delay function that uses zsh/system for better precision
zdelay() {
  local delay=$1
  ((delay = delay * 1000)) # Convert to milliseconds
  zsystem flock -t $delay /dev/null
}

################################################################################
# HISTORY CONFIGURATION - ESSENTIAL FOR INTERACTIVE USE
################################################################################

# Large history size improves command recall without significant memory impact
HISTSIZE=1000000                         # Number of commands to keep in memory
SAVEHIST="$HISTSIZE"                     # Number of commands to save to disk
HISTFILE="${XDG_DATA_HOME}/.zsh_history" # History file location

################################################################################
# FUNCTION PATH CONFIGURATION - PRIORITIZE PERFORMANCE
################################################################################

# Add custom functions directory first for faster lookups
fpath=(
  ${ZDOTDIR}/functions # User-defined functions
  $fpath               # System functions
)

# Add Homebrew completions if available (use cached prefix)
if has brew; then
  local brew_prefix="/opt/homebrew"
  [[ ! -d "$brew_prefix" ]] && brew_prefix="/usr/local"
  [[ -d "$brew_prefix/share/zsh/site-functions" ]] && fpath=("$brew_prefix/share/zsh/site-functions" $fpath)
  unset brew_prefix
fi

# Load all functions from ZDOTDIR/functions - use glob qualifier for better performance
autoload -Uz ${ZDOTDIR}/functions/**/*(N:t)

################################################################################
# ZI PLUGIN MANAGER CONFIGURATION - OPTIMIZED LOADING
################################################################################

# Centralized ZI configuration
typeset -gA ZI=(
  [HOME_DIR]="$XDG_CACHE_HOME/zsh/zi"
  [BIN_DIR]="$XDG_CACHE_HOME/zsh/zi/bin"
  [PLUGINS_DIR]="$XDG_CACHE_HOME/zsh/zi/plugins"
  [ZCOMPDUMP_PATH]="$XDG_CACHE_HOME/zsh/.zcompdump"
  [COMPINIT_OPTS]="-C -d ${ZI[ZCOMPDUMP_PATH]}"
)
ZPFX="$ZI[HOME_DIR]/polaris"

# Load or install ZI
if [[ -f "${ZI[BIN_DIR]}/zi.zsh" ]]; then
  source "${ZI[BIN_DIR]}/zi.zsh"
  autoload -Uz _zi
  [[ -v _comps ]] && _comps[zi]=_zi
else
  if has git; then
    git clone --depth 1 https://github.com/z-shell/zi.git "${ZI[BIN_DIR]}" &&
      source "${ZI[BIN_DIR]}/zi.zsh" &&
      autoload -Uz _zi &&
      [[ -v _comps ]] && _comps[zi]=_zi
  fi
fi

# Initialize prompt system
autoload -Uz promptinit && promptinit

################################################################################
# PROMPT CONFIGURATION - PURE THEME OPTIMIZATION
################################################################################

# Random prompt symbol selection
PURE_SYMBOLS=("λ" "ϟ" "▲" "∴" "→" "»" "৸")
export PURE_PROMPT_SYMBOL="${PURE_SYMBOLS[$RANDOM % ${#PURE_SYMBOLS[@]} + 1]}"

# Load Pure theme immediately
zi light-mode for \
  compile'(pure|async).zsh' \
  pick'async.zsh' \
  src'pure.zsh' \
  atload'prompt pure' \
  sindresorhus/pure

# Theme styling
zstyle :prompt:pure:path color 240
zstyle :prompt:pure:git:branch color blue
zstyle :prompt:pure:git:dirty color red
zstyle :prompt:pure:git:action color 005
zstyle :prompt:pure:prompt:success color 003

# History substring search - minimal delay
zi ice lucid id-as'history-search' atload'
  zdelay 0.1
  bindkey "${terminfo[kcuu1]}" history-substring-search-up
  bindkey "${terminfo[kcud1]}" history-substring-search-down
  bindkey "^[[A" history-substring-search-up
  bindkey "^[[B" history-substring-search-down
'
zi light zsh-users/zsh-history-substring-search

# Autosuggestions - balanced delay
zi ice lucid id-as'auto-suggest' atload'
  zdelay 0.3
  _zsh_autosuggest_start
'
zi light zsh-users/zsh-autosuggestions

################################################################################
# COMPLETION SYSTEM CONFIGURATION - PERFORMANCE OPTIMIZED
################################################################################

# Load completion configuration
source "${ZDOTDIR}/config/completion.zsh"

################################################################################
# PLUGIN LOADING - OPTIMIZED STAGGERED LOADING
################################################################################

# Autosuggestions and history-substring-search with turbo mode
zi wait lucid for \
  atload"!_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions \
  atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down" \
  zsh-users/zsh-history-substring-search

################################################################################
# EXTERNAL TOOLS INTEGRATION - PRIORITIZED LOADING
################################################################################

# Priority 1: Immediate loading (essential tools)
if has zoxide && [[ ! -v _ZOXIDE_INITIALIZED ]]; then
  zi wait lucid id-as"zoxide" as"null" atload'
    export _ZOXIDE_INITIALIZED=1
    eval "$(zoxide init zsh --hook pwd 2>/dev/null)"
  ' for zdharma-continuum/null
fi

# Priority 2: Short delay (environment tools)
if has direnv; then
  zi ice lucid id-as'direnv' atload'
    zdelay 0.5
    direnv hook zsh >| "${ZI[PLUGINS_DIR]}/direnv/init.zsh"
    source "${ZI[PLUGINS_DIR]}/direnv/init.zsh"
  '
  zi light zdharma-continuum/null
fi

# Priority 3: Medium delay (interactive tools)
if has fzf; then
  zi ice lucid id-as'fzf' atload'
    zdelay 1
    fzf --zsh >| "${ZI[PLUGINS_DIR]}/fzf/init.zsh"
    source "${ZI[PLUGINS_DIR]}/fzf/init.zsh"
  '
  zi light zdharma-continuum/null
fi

# Priority 4: Long delay (other tools)
if has starship; then
  zi ice lucid id-as'starship' atload'
    zdelay 2
    starship init zsh --print-full-init >| "${ZI[PLUGINS_DIR]}/starship/init.zsh"
    source "${ZI[PLUGINS_DIR]}/starship/init.zsh"
  '
  zi light zdharma-continuum/null
fi

################################################################################
# LOCAL CONFIGURATION - SYSTEM SPECIFIC SETTINGS
################################################################################

# Load optional local configurations
[[ -f "$ZDOTDIR/bin/proto" ]] && source "$ZDOTDIR/bin/proto"
[[ -f $HOST_CONFIGS/zshrc ]] && source $HOST_CONFIGS/zshrc

# Create hushlogin file if needed
[[ -e /etc/motd ]] && [[ ! -f ${HOME}/.hushlogin ]] && tee ${HOME}/.hushlogin </etc/motd >/dev/null

# End performance analysis and print report
# The zprof command will display detailed performance analysis results, including:
# - Number of calls for each function
# - Total execution time for each function
# - Self execution time (excluding subcall time)
# - Function list sorted by execution time
# zprof
