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

# Command and path caching for faster command lookup
setopt HASH_CMDS HASH_DIRS

# Input/output and completion optimizations
setopt NO_FLOW_CONTROL # Disable Ctrl-S/Ctrl-Q flow control
setopt NO_BEEP         # Disable terminal bell
setopt GLOB_COMPLETE   # Enable glob completion

# Job control optimizations for background processes
setopt NO_CHECK_JOBS  # Don't warn about background jobs on exit
setopt NO_HUP         # Don't send HUP signal to background jobs on exit
setopt NO_BG_NICE     # Don't lower priority of background jobs
setopt NOTIFY         # Report status of background jobs immediately
setopt LONG_LIST_JOBS # List jobs in long format

# Directory navigation enhancements
setopt PUSHD_IGNORE_DUPS # Don't push duplicate directories onto the stack
setopt PUSHD_SILENT      # Don't print directory stack after pushd/popd
setopt AUTOPARAMSLASH    # Automatically append a slash to directory names
setopt AUTO_CD           # Change directory without 'cd' command
setopt AUTO_PUSHD        # Push current directory onto stack when changing
setopt PUSHD_TO_HOME     # 'pushd' with no arguments goes to home directory

# File operation safety and redirection
setopt NO_CLOBBER # Prevent overwriting existing files with redirection (e.g., >)
setopt NO_MULTIOS # Disable multiple output redirections

################################################################################
# HISTORY OPTIMIZATION
################################################################################

# High-performance history settings for efficient command recall
setopt HIST_IGNORE_ALL_DUPS   # Ignore duplicate commands when adding to history
setopt HIST_NO_STORE          # Do not store history commands in the history file
setopt HIST_NO_FUNCTIONS      # Do not store function definitions in history
setopt HIST_FIND_NO_DUPS      # When searching history, do not show duplicate entries
setopt INC_APPEND_HISTORY     # Append commands to history file immediately
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first when history file size limit is reached
setopt HIST_REDUCE_BLANKS     # Remove extra blank spaces from history commands
setopt EXTENDED_HISTORY       # Save timestamps to history entries

# Define common commands to ignore in history for cleaner logs
typeset -gr HISTORY_IGNORE=(
  clear c pwd exit ls ll la bg fg less
)

################################################################################
# INTERACTIVE SHELL OPTIMIZATION
################################################################################

# Interactive shell behavior and command line editing
setopt AUTO_RESUME          # Resume suspended jobs automatically
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shell
setopt CORRECT              # Auto-correct spelling errors in commands

################################################################################
# URL HANDLING - OPTIMIZED LAZY LOADING
################################################################################

# Efficient URL handler loading
_load_url_handlers() {
  # Load URL handling functions only if they are not already loaded
  if [[ ! -v functions[url-quote-magic] ]]; then
    autoload -Uz bracketed-paste-url-magic url-quote-magic
    zle -N bracketed-paste bracketed-paste-url-magic
    zle -N self-insert url-quote-magic
  fi
  # Unset the function after it has been executed to free up memory
  unfunction _load_url_handlers
}

# Utilize zsh-defer for asynchronous loading if available, otherwise load immediately
if (( $+commands[zsh-defer] )); then
  zsh-defer _load_url_handlers
else
  _load_url_handlers
fi
