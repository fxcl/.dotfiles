# vim:ft=zsh:
################################################################################
# ZSH RUNTIME CONFIGURATION - OPTIMIZED FOR PERFORMANCE
################################################################################

################################################################################
# CORE UTILITY FUNCTIONS - LOADED FIRST FOR DEPENDENCY RESOLUTION
################################################################################

# Check if a command exists - used extensively for conditional loading
has() {
  whence "$1" >/dev/null
}

# Optimized function to measure file modification time (cross-platform)
stat_mtime() {
  local file=$1

  # Try BSD stat first (macOS) - faster than GNU on macOS
  if mtime=$(stat -f %m "$file" 2>/dev/null); then
    echo $mtime
    return 0
  fi

  # Try GNU stat if BSD stat failed (Linux)
  if mtime=$(stat -c %Y "$file" 2>/dev/null); then
    echo $mtime
    return 0
  fi

  # Fallback to current time if stat fails
  date +%s
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

# Add Homebrew completions if available (avoid expensive brew --prefix call if possible)
if has brew; then
  # Cache the brew prefix to avoid repeated calls
  local brew_prefix
  brew_prefix=$(brew --prefix)
  fpath=("$brew_prefix/share/zsh/site-functions" $fpath)
  unset brew_prefix
fi

# Load all functions from ZDOTDIR/functions - use glob qualifier for better performance
autoload -Uz ${ZDOTDIR}/functions/**/*(N:t)

################################################################################
# ZI PLUGIN MANAGER CONFIGURATION - OPTIMIZED FOR LAZY LOADING
################################################################################

# Centralized ZI configuration - use associative array for better organization
typeset -gA ZI=(
  [HOME_DIR]="$XDG_CACHE_HOME/zsh/zi"            # Base directory
  [BIN_DIR]="$XDG_CACHE_HOME/zsh/zi/bin"         # Core scripts
  [PLUGINS_DIR]="$XDG_CACHE_HOME/zsh/zi/plugins" # Plugin storage
  [ZCOMPDUMP_PATH]="${ZDOTDIR}/.zcompdump"       # Completion cache
  [COMPINIT_OPTS]="-C"                           # Fast completion initialization
)
ZPFX="$ZI[HOME_DIR]/polaris" # Prefix for compiled functions

# Load or install ZI - optimized conditional logic
if [[ -f "${ZI[BIN_DIR]}/zi.zsh" ]]; then
  source "${ZI[BIN_DIR]}/zi.zsh"    # Load existing installation
  autoload -Uz _zi                  # Load completion function
  [[ -v _comps ]] && _comps[zi]=_zi # Register completion
else
  # Only attempt installation if git is available
  if has git; then
    # Single-command installation with chained operations for efficiency
    git clone --depth 1 https://github.com/z-shell/zi.git "${ZI[BIN_DIR]}" &&
      source "${ZI[BIN_DIR]}/zi.zsh" &&
      autoload -Uz _zi &&
      [[ -v _comps ]] && _comps[zi]=_zi
  fi
fi

################################################################################
# PROMPT CONFIGURATION - PURE THEME OPTIMIZATION
################################################################################

# Random prompt symbol selection - adds visual variety
PURE_SYMBOLS=("λ" "ϟ" "▲" "∴" "→" "»" "৸")
export PURE_PROMPT_SYMBOL="${PURE_SYMBOLS[$RANDOM % ${#PURE_SYMBOLS[@]} + 1]}"

# Load Pure theme with turbo mode - wait'0' provides optimal balance
# between startup speed and prompt availability
zi ice wait'0' lucid compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zi light sindresorhus/pure

# Theme styling - grouped for better organization
zstyle :prompt:pure:path color 240           # Subdued path color
zstyle :prompt:pure:git:branch color blue    # Highlight branch name
zstyle :prompt:pure:git:dirty color red      # Make dirty state obvious
zstyle :prompt:pure:git:action color 005     # Highlight git actions
zstyle :prompt:pure:prompt:success color 003 # Successful command indicator

################################################################################
# COMPLETION SYSTEM CONFIGURATION - PERFORMANCE OPTIMIZED
################################################################################

# Completion caching - reduces repeated parsing of completion files
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR}/.zcompcache"

# Performance-optimized completion settings
zstyle ':completion:*' accept-exact '*(N)'     # Accept exact matches immediately
zstyle ':completion:*' accept-exact-dirs 'yes' # Faster directory completion
zstyle ':completion:*' special-dirs true       # Handle . and .. directories

# Smart case-insensitive matching - balance between accuracy and convenience
# Simplified matcher list for better performance
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Display optimization - reduce formatting overhead
zstyle ':completion:*' list-packed yes                                          # Compact completion display
zstyle ':completion:*' file-sort modification                                   # Sort by modification time
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)' # Skip internal functions

# Load additional completions with turbo mode
zi ice wait'0' lucid blockf # Block traditional fpath method
zi light zsh-users/zsh-completions

# Intelligent compinit - only rebuild cache daily for better performance
autoload -Uz compinit
if [[ -f "${ZI[ZCOMPDUMP_PATH]}" ]] && (($(stat_mtime "${ZI[ZCOMPDUMP_PATH]}") > ($(date +%s) - 86400))); then
  # Use cached completion - much faster startup
  compinit -C -d "${ZI[ZCOMPDUMP_PATH]}"
else
  # Rebuild completion cache - only happens once daily
  compinit -d "${ZI[ZCOMPDUMP_PATH]}"
fi

################################################################################
# PLUGIN LOADING - STAGGERED FOR OPTIMAL STARTUP TIME
################################################################################

# History substring search - load after compinit but before user interaction
zi ice wait lucid
zi light zsh-users/zsh-history-substring-search

# Syntax highlighting - load with delay and minimal features
zi ice wait'2' lucid atinit'ZI[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay' \
  atload'unset "FAST_HIGHLIGHT[chroma-whatis]" "FAST_HIGHLIGHT[chroma-man]" "FAST_HIGHLIGHT[chroma-which]"'
zi light zdharma-continuum/fast-syntax-highlighting

# Autosuggestions - load with delay for faster initial startup
zi ice wait'2' lucid atload'_zsh_autosuggest_start'
zi light zsh-users/zsh-autosuggestions

################################################################################
# KEY BINDINGS - HISTORY NAVIGATION
################################################################################

# Configure history search keybindings - support both terminal and application modes
bindkey "${terminfo[kcuu1]}" history-substring-search-up   # Up arrow
bindkey "${terminfo[kcud1]}" history-substring-search-down # Down arrow
bindkey '^[[A' history-substring-search-up                 # Alternative up
bindkey '^[[B' history-substring-search-down               # Alternative down

################################################################################
# EXTERNAL TOOLS INTEGRATION - LAZY LOADED
################################################################################

# Combined initialization function for external tools
init_env() {
  # Platform-specific optimizations
  if [[ "$OSTYPE" = darwin* ]]; then
    # Fix conflicting git completion on macOS
    if [[ -e /usr/local/share/zsh/site-functions/_git ]]; then
      command mv -f /usr/local/share/zsh/site-functions/_git \
        /usr/local/share/zsh/site-functions/disabled._git 2>/dev/null
    fi

    # Set C++ compiler flags on macOS if clang++ is available
    has clang++ && export CXXFLAGS="-stdlib=libc++" LDFLAGS="-stdlib=libc++ -L$(brew --prefix openssl@3)/lib" CFLAGS="-I$(brew --prefix openssl@3)/include" RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"
  fi

  # Initialize tools with silent error handling and minimal output
  has direnv && eval "$(direnv hook zsh 2>/dev/null)"
  has zoxide && eval "$(zoxide init zsh --hook pwd 2>/dev/null)"
  has starship && eval "$(starship init zsh)"
  has fzf && source <(fzf --zsh 2>/dev/null)
}

# Run initialization
init_env

################################################################################
# LOCAL CONFIGURATION - SYSTEM SPECIFIC SETTINGS
################################################################################

# Load optional local configurations
[[ -f "$ZDOTDIR/bin/proto" ]] && source "$ZDOTDIR/bin/proto" # Development environment
[[ -f $HOST_CONFIGS/zshrc ]] && source $HOST_CONFIGS/zshrc   # Host-specific config

# Create hushlogin file if needed (suppresses login messages)
if [[ -e /etc/motd ]] && [[ ! -f ${HOME}/.hushlogin ]]; then
  tee ${HOME}/.hushlogin </etc/motd >/dev/null
fi
