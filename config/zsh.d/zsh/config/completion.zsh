#
# Completion enhancements - Optimized for speed
#

# If it's a dumb terminal, return immediately
if [[ ${TERM} == 'dumb' ]]; then
  return 1
fi

# Lazy load completion system, significantly improves startup speed
# Only loads completion system on first Tab key press
_zsh_comp_setup() {
  # Basic completion options
  setopt ALWAYS_TO_END PATH_DIRS
  unsetopt CASE_GLOB LIST_BEEP

  # Enable completion cache and optimize
  zstyle ':completion::complete:*' use-cache on
  zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
  
  # Core completion settings - streamlined for speed
  zstyle ':completion:*' menu select=5
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Single matching rule is faster
  zstyle ':completion:*' completer _complete _match _approximate
  zstyle ':completion:*:match:*' original only
  zstyle ':completion:*:approximate:*' max-errors 1 numeric
  
  # Optimize file sorting and list display
  zstyle ':completion:*' file-sort modification
  zstyle ':completion:*' list-packed yes
  zstyle ':completion:*' special-dirs true
  zstyle ':completion:*' squeeze-slashes true
  
  # Simplify format settings - reduce formatting overhead
  zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
  zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*' verbose no # Reduce verbose output
  
  # Color settings - use variable reference instead of calculating each time
  [[ -n "$LS_COLORS" ]] && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  
  # Directory completion optimization
  zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
  
  # Ignore patterns - reduce unnecessary completion items
  zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'
  zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
  
  # Efficient history completion
  zstyle ':completion:*:history-words' remove-all-dups yes
  zstyle ':completion:*:history-words' list false
  zstyle ':completion:*:history-words' menu yes
  
  # On-demand man page completion
  zstyle ':completion:*:manuals' separate-sections true
  
  # Preload common completion modules to reduce first completion delay
  compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
  
  # Unload this function to avoid memory usage
  unfunction _zsh_comp_setup
}

# Lazy load completion system - only triggered on first Tab press
zle-line-init() {
  zle -D zle-line-init
  # Remove this widget to avoid repeated calls
  bindkey "^I" expand-or-complete
  # Asynchronously load completion system
  _zsh_comp_setup &!
}

# Set up lazy loading trigger
zle -N zle-line-init
bindkey "^I" _delayed_completion

# Delayed completion function
_delayed_completion() {
  # Load completion system immediately on first Tab press
  _zsh_comp_setup
  # Then perform normal completion
  zle expand-or-complete
}
zle -N _delayed_completion
