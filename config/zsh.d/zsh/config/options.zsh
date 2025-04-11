##############################################################
# generic options and environment settings
###############################################################

# Performance optimization settings
# Performance critical options (must be first)
setopt HASH_CMDS     # Cache command locations to reduce PATH searches (performance)
setopt HASH_DIRS     # Cache directory locations to reduce PATH searches (performance)
setopt GLOB_COMPLETE # Expand wildcards during completion rather than on the command line (performance)

# Use smart URL pasting and escaping.
autoload -Uz bracketed-paste-url-magic && zle -N bracketed-paste bracketed-paste-url-magic
autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic

setopt AUTO_RESUME          # Treat single word simple commands without redirection as candidates for resumption of an existing job.
setopt INTERACTIVE_COMMENTS # Allow comments starting with `#` even in interactive shells.
setopt NO_FLOW_CONTROL      # disable start (C-s) and stop (C-q) characters
setopt CORRECT              # Suggest command corrections
setopt LONG_LIST_JOBS       # List jobs in the long format by default.
setopt NOTIFY               # Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt NO_BG_NICE           # Prevent running all background jobs at a lower priority.
setopt NO_CHECK_JOBS        # Prevent reporting the status of background and suspended jobs before exiting a shell with job control. NO_CHECK_JOBS is best used only in combination with NO_HUP, else such jobs will be killed automatically.
setopt NO_HUP               # Prevent sending the HUP signal to running jobs when the shell exits.
setopt NO_BEEP              # Don't beep on errors (overrides /etc/zshrc in Catalina)

##############################################################
#  History options
###############################################################

# limit of history entries
# Optimized history ignore pattern (reduced regex complexity)
HISTORY_IGNORE='(clear|c|pwd|exit|*help|[bf]g|less|cd( -| \.\.))'

# Optimized history settings (reduced overhead)
setopt EXTENDED_HISTORY       # Required for timestamped history
setopt INC_APPEND_HISTORY     # Write immediately (better for crash recovery)
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first (saves space)
setopt HIST_IGNORE_ALL_DUPS   # Skip all duplicates (performance)
setopt HIST_FIND_NO_DUPS      # Don't show duplicates in search (performance)
setopt HIST_REDUCE_BLANKS     # Save space by removing extra blanks
setopt HIST_NO_STORE          # Skip storing history commands (performance)
setopt HIST_NO_FUNCTIONS      # Skip storing functions (performance)

##############################################################
# Directory navigation options
###############################################################

setopt AUTO_CD           # If a command is issued that can’t be executed as a normal command, and the command is the name of a directory, perform the cd command to that directory.
setopt AUTO_PUSHD        # Make cd push the old directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS # Don’t push multiple copies of the same directory onto the directory stack.
setopt PUSHD_SILENT      # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME     # Have pushd with no arguments act like ‘pushd ${HOME}’.
setopt AUTOPARAMSLASH    # tab completing directory appends a slash

#
# Globbing and fds
#

# Optimized globbing settings
setopt NO_MULTIOS # Disabled - rarely needed and has performance overhead
setopt NO_CLOBBER # Prevent accidental overwrites (safety)
