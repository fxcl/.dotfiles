###############################################################################
# ZSH Completion Configuration - Optimized for Performance
###############################################################################

# Early return for non-interactive or dumb terminals
if [[ ${TERM} == 'dumb' || ! -o interactive ]]; then
  return 0
fi

# Lazy-load completion system to improve shell startup time
# This function is called only on first tab press
_zsh_comp_setup() {
  # Performance: Local variables are faster than globals
  local cache_dir="${ZDOTDIR:-$HOME}/.zcompcache"
  local dump_file="${ZDOTDIR:-$HOME}/.zcompdump"
  
  ###############################################################################
  # Core Options - Minimal set for better performance
  ###############################################################################
  setopt ALWAYS_TO_END    # Move cursor to end of completed word
  setopt PATH_DIRS        # Perform path search even on command names with slashes
  unsetopt CASE_GLOB      # Case insensitive globbing
  unsetopt LIST_BEEP      # Don't beep on ambiguous completion

  ###############################################################################
  # Cache Configuration - Reduces disk I/O
  ###############################################################################
  zstyle ':completion::complete:*' use-cache on
  zstyle ':completion::complete:*' cache-path "$cache_dir"
  
  ###############################################################################
  # Completion Behavior - Optimized for speed and usability
  ###############################################################################
  # Only show menu when there are at least 5 items
  zstyle ':completion:*' menu select=5
  
  # Case-insensitive matching (single rule for better performance)
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
  
  # Limit completion strategies to essential ones
  zstyle ':completion:*' completer _complete _match _approximate
  zstyle ':completion:*:match:*' original only
  zstyle ':completion:*:approximate:*' max-errors 1 numeric
  
  ###############################################################################
  # Display Optimization - Reduces formatting overhead
  ###############################################################################
  # Sort files by modification time (most recent first)
  zstyle ':completion:*' file-sort modification
  
  # Compact display settings
  zstyle ':completion:*' list-packed yes
  zstyle ':completion:*' special-dirs true
  zstyle ':completion:*' squeeze-slashes true
  
  # Minimal formatting with essential visual cues
  zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
  zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' verbose no
  
  # Use LS_COLORS for file coloring (if available)
  [[ -n "$LS_COLORS" ]] && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  
  ###############################################################################
  # Context-Specific Optimizations
  ###############################################################################
  # Directory navigation prioritization
  zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
  
  # Skip internal/helper functions in completion
  zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'
  
  # Avoid suggesting words from current line for certain commands
  zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
  
  # History word completion settings
  zstyle ':completion:*:history-words' remove-all-dups yes
  zstyle ':completion:*:history-words' list false
  zstyle ':completion:*:history-words' menu yes
  
  # Load man page sections separately (on-demand loading)
  zstyle ':completion:*:manuals' separate-sections true
  
  ###############################################################################
  # Initialize Completion System
  ###############################################################################
  # Initialize completion (creates/updates dump file)
  compinit -d "$dump_file"
  
  # Clean up: Remove this function to free memory after initialization
  unfunction _zsh_comp_setup
}

###############################################################################
# Lazy Loading Implementation
###############################################################################

# Hook that runs when a new command line is initialized
# Replaces itself with normal completion after first run
zle-line-init() {
  # Remove this widget to prevent future calls
  zle -D zle-line-init
  
  # Restore normal tab completion behavior
  bindkey "^I" expand-or-complete
  
  # Load completion system asynchronously
  _zsh_comp_setup &!
}

# Register the line initialization hook
zle -N zle-line-init

# Bind tab key to delayed completion initially
bindkey "^I" _delayed_completion

# Function called on first tab press
_delayed_completion() {
  # Initialize completion system immediately
  _zsh_comp_setup
  
  # Execute normal completion
  zle expand-or-complete
}

# Register the delayed completion function
zle -N _delayed_completion
