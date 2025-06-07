################################################################################
# ZSH OPTIONS CONFIGURATION - OPTIMIZED FOR PERFORMANCE AND USABILITY
################################################################################

# Early return for non-interactive sessions
[[ ! -o interactive ]] && return 0

################################################################################
# CRITICAL PERFORMANCE MODULES - PRELOAD
################################################################################

# Load essential modules with minimal features
zmodload -F zsh/stat b:zstat
zmodload -F zsh/datetime p:EPOCHSECONDS
zmodload -F zsh/system b:syserror

################################################################################
# CORE PERFORMANCE OPTIONS
################################################################################

# Command and path caching
setopt HASH_CMDS HASH_DIRS

# Input/output optimization
setopt NO_FLOW_CONTROL NO_BEEP GLOB_COMPLETE

# Job control optimization
setopt NO_CHECK_JOBS NO_HUP NO_BG_NICE NOTIFY LONG_LIST_JOBS

# Directory navigation optimization
setopt PUSHD_IGNORE_DUPS PUSHD_SILENT AUTOPARAMSLASH
setopt AUTO_CD AUTO_PUSHD PUSHD_TO_HOME

# File operation safety
setopt NO_CLOBBER NO_MULTIOS

################################################################################
# HISTORY OPTIMIZATION
################################################################################

# High-performance history settings
setopt HIST_IGNORE_ALL_DUPS    # Remove duplicates
setopt HIST_NO_STORE           # Don't store history commands
setopt HIST_NO_FUNCTIONS       # Don't store functions
setopt HIST_FIND_NO_DUPS      # Skip duplicates in search
setopt INC_APPEND_HISTORY      # Immediate append
setopt HIST_EXPIRE_DUPS_FIRST  # Remove duplicates first
setopt HIST_REDUCE_BLANKS      # Remove extra blanks
setopt EXTENDED_HISTORY        # Save timestamps

# Ignore common commands in history
typeset -gr HISTORY_IGNORE='(clear|c|pwd|exit|ls|ll|la|[bf]g|less)'

################################################################################
# INTERACTIVE SHELL OPTIMIZATION
################################################################################

# Command line behavior
setopt AUTO_RESUME INTERACTIVE_COMMENTS CORRECT

################################################################################
# URL HANDLING - OPTIMIZED LAZY LOADING
################################################################################

# Efficient URL handler loading
_load_url_handlers() {
  # Load only if not already loaded
  if [[ ! -v functions[url-quote-magic] ]]; then
    autoload -Uz bracketed-paste-url-magic url-quote-magic
    zle -N bracketed-paste bracketed-paste-url-magic
    zle -N self-insert url-quote-magic
  fi
  unfunction _load_url_handlers
}

# Use zsh-defer if available, otherwise load immediately
if (( $+commands[zsh-defer] )); then
  zsh-defer _load_url_handlers
else
  _load_url_handlers
fi
