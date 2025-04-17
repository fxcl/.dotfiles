##############################################################
# Performance Optimization Configuration - Load Order is Critical for Performance
###############################################################

# Performance Critical Options - Must be Loaded First
setopt HASH_CMDS        # Cache command locations to reduce PATH searches (significant performance boost)
setopt HASH_DIRS        # Cache directory locations to reduce PATH searches (significant performance boost)
setopt GLOB_COMPLETE    # Expand wildcards during completion rather than on command line (improves performance)
setopt NO_FLOW_CONTROL  # Disable flow control characters (C-s and C-q), reduces processing overhead
setopt NO_BEEP          # Disable error beeps, avoids unnecessary system calls

# Lazy Load URL Handling Functions - Initialize Only When Needed
_load_url_handlers() {
  autoload -Uz bracketed-paste-url-magic && zle -N bracketed-paste bracketed-paste-url-magic
  autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic
}
zsh-defer _load_url_handlers 2>/dev/null || _load_url_handlers

# Standard Shell Options - Grouped by Purpose
# Job Control Related Options (Grouped for Readability and Maintainability)
setopt NO_CHECK_JOBS    # Don't report status of background and suspended jobs when exiting shell
setopt NO_HUP           # Don't send HUP signal to running jobs when shell exits
setopt NO_BG_NICE       # Prevent running all background jobs at a lower priority
setopt NOTIFY           # Report background job status immediately, not before printing prompt
setopt LONG_LIST_JOBS   # List jobs in long format by default

# Interactive Usage Experience Options
setopt AUTO_RESUME      # Treat single word simple commands without redirection as candidates for resumption
setopt INTERACTIVE_COMMENTS # Allow comments starting with `#` in interactive shells
setopt CORRECT          # Suggest command corrections (enable only when needed, may impact performance)

##############################################################
#  History Optimization Options
###############################################################

# History Ignore Pattern - Use Simple Patterns to Reduce Regex Complexity
# Avoid complex regex, use simple pattern matching for better performance
HISTORY_IGNORE='(clear|c|pwd|exit|ls|ll|la|[bf]g|less)'

# History Settings - Grouped by Performance Impact
# High Performance Impact Options
setopt HIST_IGNORE_ALL_DUPS   # Skip all duplicates (significant performance boost)
setopt HIST_NO_STORE          # Don't store history commands themselves (improves performance)
setopt HIST_NO_FUNCTIONS      # Don't store function definitions (improves performance)
setopt HIST_FIND_NO_DUPS      # Don't show duplicates in search (improves performance)

# Medium Performance Impact Options
setopt INC_APPEND_HISTORY     # Write immediately (better crash recovery, slight performance impact)
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first (saves space)
setopt HIST_REDUCE_BLANKS     # Save space by removing extra blanks

# Essential Functionality Options
setopt EXTENDED_HISTORY       # Timestamped history (slight performance impact but necessary)

##############################################################
# Directory Navigation and File Operation Optimization
###############################################################

# Directory Navigation Options - Sorted by Performance Impact
# High Performance Options
setopt PUSHD_IGNORE_DUPS # Don't push multiple copies of same directory onto stack (reduces memory usage)
setopt PUSHD_SILENT      # Don't print directory stack after pushd or popd (reduces I/O)
setopt AUTOPARAMSLASH    # Tab completing directory appends a slash (improves user experience)

# Medium Performance Impact Options
setopt AUTO_CD           # If command can't be executed and is a directory name, perform cd to that directory
setopt AUTO_PUSHD        # Make cd push old directory onto directory stack
setopt PUSHD_TO_HOME     # Have pushd with no arguments act like 'pushd ${HOME}'

# File Operation Safety Options
# Optimized Global Settings - Disable Unnecessary Features
setopt NO_MULTIOS        # Disabled - rarely needed and has performance overhead
setopt NO_CLOBBER        # Prevent accidental overwrites (safety)

# Preload Common Modules to Reduce First-Use Delay
{ zmodload -F zsh/stat +b:zstat } 2>/dev/null
