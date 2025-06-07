###############################################################################
# ZSH Completion Configuration - Optimized for Performance
###############################################################################

# Early return for non-interactive or dumb terminals
[[ ${TERM} == 'dumb' || ! -o interactive ]] && return 0

###############################################################################
# Completion System Setup - Efficient Loading
###############################################################################

# Load required modules
zmodload zsh/complist
zmodload zsh/mathfunc

# Local variables for better performance
typeset -g cache_dir="${ZDOTDIR:-$HOME}/.zcompcache"
typeset -g dump_file="${ZI[ZCOMPDUMP_PATH]:-${ZDOTDIR:-$HOME}/.zcompdump}"

###############################################################################
# Core Options - Performance Optimized
###############################################################################

# Essential completion options
setopt ALWAYS_TO_END PATH_DIRS
unsetopt CASE_GLOB LIST_BEEP

# Cache configuration
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$cache_dir"

# Optimized completion behavior
zstyle ':completion:*' menu select=3
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Display optimization
zstyle ':completion:*' {list-packed,special-dirs,squeeze-slashes} yes
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose no

# Minimal but effective formatting
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'

# Use LS_COLORS if available
[[ -n "$LS_COLORS" ]] && zstyle ':completion:*' list-colors "$LS_COLORS"

###############################################################################
# Context-Specific Optimizations
###############################################################################

# Directory navigation
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories

# Function completion
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'

# Command-specific settings
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other

# History completion
zstyle ':completion:*:history-words' {remove-all-dups,list,menu} yes

# Man pages
zstyle ':completion:*:manuals' separate-sections true

###############################################################################
# Initialize System
###############################################################################

# Initialize completion system
{
  # Compile zcompdump if needed
  local zcd="$dump_file"
  
  autoload -Uz compinit
  if [[ ! -f "$zcd" ]] || ((zcd_time < ($(date +%s) - 86400) )); then
    compinit -i -d "$zcd"
  else
    compinit -C -d "$zcd"
  fi

  if [[ -f "$zcd"(#qN.m+1) ]]; then
    zcompile -R "$zcd" && command touch "$zcd"
  fi
} &!
