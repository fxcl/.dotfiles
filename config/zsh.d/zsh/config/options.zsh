##############################################################
# General Shell Behavior
##############################################################

# Smart URL pasting and escaping
autoload -Uz bracketed-paste-url-magic && zle -N bracketed-paste bracketed-paste-url-magic
autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic

setopt AUTO_RESUME          # Resume existing suspended jobs when command name matches
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shells
setopt NO_FLOW_CONTROL      # Disable start/stop characters (C-s/C-q)
setopt CORRECT              # Suggest command corrections
setopt LONG_LIST_JOBS       # List jobs in long format by default
setopt NOTIFY               # Report background job status immediately
setopt NO_BG_NICE           # Don't lower priority of background jobs
setopt NO_CHECK_JOBS        # Don't check jobs before shell exit (use with NO_HUP)
setopt NO_HUP               # Don't send HUP signal to jobs on shell exit
setopt NO_BEEP              # Disable error beeps
setopt COMBINING_CHARS      # Display combining characters correctly
setopt RC_QUOTES            # Allow 'abc''def' to mean "abc'def"

##############################################################
# Command History Configuration
##############################################################

# Commands to exclude from history
HISTORY_IGNORE='(clear|c|pwd|exit|* —help|[bf]g *|less *|cd ..|cd -|l[alsh]#( *)#|zsh|vim|nvim|emacs|nano)'

setopt BANG_HIST              # Enable csh-style history expansion with !
setopt EXTENDED_HISTORY       # Record timestamp and duration in history
setopt INC_APPEND_HISTORY    # Write to history file immediately
setopt SHARE_HISTORY         # Share history between sessions
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first when trimming history
setopt HIST_IGNORE_DUPS      # Don't record consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS  # Delete older duplicates
setopt HIST_FIND_NO_DUPS     # Don't show duplicates when searching
setopt HIST_IGNORE_SPACE     # Don't record commands starting with space
setopt HIST_SAVE_NO_DUPS     # Don't write duplicates to history file
setopt HIST_VERIFY           # Show expanded history before executing
setopt HIST_REDUCE_BLANKS    # Remove extra blanks from commands
setopt APPEND_HISTORY        # Append to history file
setopt HIST_NO_STORE         # Don't store history commands
setopt HIST_NO_FUNCTIONS     # Don't store function definitions
unsetopt HIST_BEEP           # Disable history access beep

##############################################################
# Directory Navigation
##############################################################

setopt AUTO_CD            # cd to directory by typing its name
setopt AUTO_PUSHD        # Push directories to stack on cd
setopt PUSHD_IGNORE_DUPS # Don't push duplicates to directory stack
setopt PUSHD_SILENT      # Don't print directory stack after pushd/popd
setopt PUSHD_TO_HOME     # pushd with no args goes to home
setopt AUTOPARAMSLASH    # Append slash when tab completing directories
setopt CDABLE_VARS       # cd to paths stored in variables

##############################################################
# Globbing and File Operations
##############################################################

setopt EXTENDED_GLOB    # Enhanced globbing patterns (#, ~, ^)
setopt MULTIOS          # Implicit tees/cats for multiple redirections
setopt NO_CLOBBER       # Prevent > from overwriting files (use >! to force)
setopt NUMERIC_GLOB_SORT # Sort numeric filenames numerically

##############################################################
# Completion and Expansion
##############################################################

setopt ALWAYS_TO_END    # Move cursor to end after completion
setopt PATH_DIRS        # Perform path search on commands with slashes
setopt COMPLETE_IN_WORD # Complete within words
setopt EXTENDED_GLOB    # Enhanced globbing
setopt PROMPT_SUBST     # Enable prompt expansion
unsetopt CASE_GLOB      # Case-insensitive globbing
unsetopt LIST_BEEP      # Disable completion beep
