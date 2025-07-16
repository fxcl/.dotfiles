#!/bin/zsh

# Early return for non-interactive or dumb terminals to prevent issues.
[[ ${TERM} == 'dumb' || ! -o interactive ]] && return 0

###############################################################################
# Completion System Setup - Efficient Loading
###############################################################################

# Load required Zsh modules for completion.
zmodload zsh/complist
zmodload zsh/mathfunc

# Define global variables for cache and dump file paths for better performance.
typeset -g cache_dir="${ZDOTDIR:-$HOME}/.zcompcache"                       # Directory for completion cache files.
typeset -g dump_file="${ZI[ZCOMPDUMP_PATH]:-${ZDOTDIR:-$HOME}/.zcompdump}" # Path to the completion dump file.

###############################################################################
# Core Options - Performance Optimized
###############################################################################

# Essential completion options for improved user experience.
setopt ALWAYS_TO_END PATH_DIRS # Always move cursor to end of completion; search for executables in PATH.
unsetopt CASE_GLOB LIST_BEEP   # Disable case-insensitive globbing; disable beep on completion.

# Cache configuration for faster completion loading.
zstyle ':completion:*' use-cache on            # Enable completion caching.
zstyle ':completion:*' cache-path "$cache_dir" # Set the cache directory.

# Optimized completion behavior settings.
zstyle ':completion:*' menu select=3                      # Show completion menu after 3 items.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching.
zstyle ':completion:*' completer _complete _approximate   # Use standard and approximate completers.
zstyle ':completion:*:approximate:*' max-errors 1 numeric # Allow 1 error for approximate matching.

# Display optimization settings for a cleaner completion menu.
zstyle ':completion:*' {list-packed,special-dirs,squeeze-slashes} yes # Pack lists, handle special dirs, squeeze slashes.
zstyle ':completion:*' file-sort modification                         # Sort files by modification time.
zstyle ':completion:*' group-name ''                                  # Do not display group names.
zstyle ':completion:*' verbose no                                     # Do not display verbose completion messages.

# Minimal but effective formatting for completion descriptions and warnings.
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'  # Format descriptions in yellow.
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f' # Format warnings in red.

# Use LS_COLORS for colored completion output if available.
[[ -n "$LS_COLORS" ]] && zstyle ':completion:*' list-colors "$LS_COLORS"

###############################################################################
# Context-Specific Optimizations
###############################################################################

# Directory navigation completion order.
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# Function completion: ignore internal or prompt-related functions.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'

# Command-specific settings: ignore current line for rm, kill, diff.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other

# History completion settings.
zstyle ':completion:*:history-words' {remove-all-dups,list,menu} yes # Remove duplicates, list, and show menu for history words.

# Man pages completion: separate sections for better organization.
zstyle ':completion:*:manuals' separate-sections true

###############################################################################
# Initialize Completion System
###############################################################################

# Initialize the Zsh completion system.
_zsh_completion_init() {
  # Compile zcompdump if needed
  local zcd="$dump_file"

  autoload -Uz compinit
  if [[ ! -f "$zcd" ]] || ((zcd_time < ($(date +%s) - 5256000))); then
    compinit -i -d "$zcd"
  else
    compinit -C -d "$zcd"
  fi

  if ! zmodload zsh/stat || ! zstat -L +mtime "$zcd" >/dev/null || ((EPOCHSECONDS - zstat_mtime > 86400)); then
    zcompile -R "$zcd" && command touch "$zcd"
  fi
}

_zsh_completion_init
