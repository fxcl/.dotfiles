################################################################################
# ZSH OPTIONS CONFIGURATION - OPTIMIZED FOR PERFORMANCE AND USABILITY
################################################################################

# Early return for non-interactive sessions to improve startup time
[[ ! -o interactive ]] && return 0

################################################################################
# CRITICAL PERFORMANCE OPTIONS - LOAD FIRST
################################################################################

# Command and path caching - major performance improvement
setopt HASH_CMDS          # Cache command locations to avoid PATH searches
setopt HASH_DIRS          # Cache directory locations to avoid PATH searches

# Input/output optimization
setopt NO_FLOW_CONTROL    # Disable flow control (Ctrl+S/Ctrl+Q) for better terminal experience
setopt NO_BEEP            # Disable beeping to reduce system calls
setopt GLOB_COMPLETE      # Complete globs instead of expanding them

################################################################################
# LAZY LOADING MECHANISMS - DEFER INITIALIZATION
################################################################################

# URL handling functions - only loaded when needed
_load_url_handlers() {
  # Load URL-related ZLE functions in a single operation
  autoload -Uz bracketed-paste-url-magic url-quote-magic
  
  # Register ZLE widgets
  zle -N bracketed-paste bracketed-paste-url-magic
  zle -N self-insert url-quote-magic
}

# Use zsh-defer if available, otherwise load immediately
zsh-defer _load_url_handlers 2>/dev/null || _load_url_handlers

################################################################################
# JOB CONTROL OPTIMIZATION
################################################################################

# Job management settings - grouped for related functionality
setopt NO_CHECK_JOBS      # Don't check for running jobs on shell exit
setopt NO_HUP             # Don't kill background jobs on shell exit
setopt NO_BG_NICE         # Don't lower priority of background jobs
setopt NOTIFY             # Report job status immediately, not at next prompt
setopt LONG_LIST_JOBS     # Use detailed format for job listings

################################################################################
# INTERACTIVE SHELL EXPERIENCE
################################################################################

# Command line behavior enhancements
setopt AUTO_RESUME        # Resume suspended job with its name as a command
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shells
setopt CORRECT            # Suggest corrections for mistyped commands

################################################################################
# HISTORY MANAGEMENT - OPTIMIZED FOR PERFORMANCE AND USABILITY
################################################################################

# Ignore common commands in history to save space and improve search
# Simple pattern matching is faster than complex regex
HISTORY_IGNORE='(clear|c|pwd|exit|ls|ll|la|[bf]g|less)'

# High-impact history performance settings
setopt HIST_IGNORE_ALL_DUPS   # Remove all duplicates from history
setopt HIST_NO_STORE          # Don't store history or fc commands
setopt HIST_NO_FUNCTIONS      # Don't store function definitions
setopt HIST_FIND_NO_DUPS      # Don't display duplicates during searches

# Balanced performance/functionality history settings
setopt INC_APPEND_HISTORY     # Append to history file immediately
setopt HIST_EXPIRE_DUPS_FIRST # Remove duplicates first when trimming history
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks from history

# Core history functionality
setopt EXTENDED_HISTORY       # Save timestamp and duration information

################################################################################
# DIRECTORY NAVIGATION OPTIMIZATION
################################################################################

# High-performance directory handling
setopt PUSHD_IGNORE_DUPS      # Avoid duplicate directories in stack
setopt PUSHD_SILENT           # Don't print directory stack after pushd/popd
setopt AUTOPARAMSLASH         # Append slash to directory names during completion

# Directory navigation convenience features
setopt AUTO_CD                # Change to directory without typing cd
setopt AUTO_PUSHD             # Make cd push directories to stack
setopt PUSHD_TO_HOME          # pushd with no args goes to home directory

################################################################################
# FILE OPERATION SAFETY AND OPTIMIZATION
################################################################################

# Disable rarely used features to improve performance
setopt NO_MULTIOS             # Disable multiple redirections - rarely needed

# File operation safety measures
setopt NO_CLOBBER             # Prevent accidental file overwriting

################################################################################
# PRELOAD CRITICAL MODULES - REDUCE FIRST-USE DELAY
################################################################################

# Load stat module with minimal features for file operations
{ zmodload -F zsh/stat +b:zstat } 2>/dev/null
