###############################################################################
# ZSH Input Configuration - Optimized for Performance
###############################################################################

# Early return for non-interactive sessions
[[ ! -o interactive ]] && return 0

###############################################################################
# Core Input Settings
###############################################################################

# Enable vi mode for command line editing
bindkey -v

# Disable terminal flow control (allows Ctrl+S and Ctrl+Q usage)
[[ -t 0 ]] && stty -ixon

###############################################################################
# Key Binding Setup Function - Lazy Loaded
###############################################################################

# Main function for setting up key bindings - called only once
_setup_key_bindings() {
  # Load terminfo module with minimal features to reduce overhead
  # Only load the specific capabilities we need
  zmodload -F zsh/terminfo +b:echoti +p:terminfo 2>/dev/null
  
  ###############################################################################
  # Key Mapping Configuration
  ###############################################################################
  
  # Use local associative array for better performance
  local -A _key_info
  
  # Define core key prefixes
  _key_info=(
    'Control' '\C-'  # Control key prefix
    'Escape'  '\e'   # Escape key prefix
    'Meta'    '\M-'  # Meta/Alt key prefix
  )
  
  # Map essential terminal keys from terminfo database
  # Only map the most frequently used keys to reduce initialization time
  _key_info[Backspace]=${terminfo[kbs]}
  _key_info[Left]=${terminfo[kcub1]}
  _key_info[Right]=${terminfo[kcuf1]}
  _key_info[Up]=${terminfo[kcuu1]}
  _key_info[Down]=${terminfo[kcud1]}
  _key_info[BackTab]=${terminfo[kcbt]}
  
  # Export key mappings to global scope for other scripts
  typeset -gA key_info
  key_info=(${(kv)_key_info})
  
  ###############################################################################
  # Core Key Bindings
  ###############################################################################
  
  # Space expands history references like !!, !$, etc.
  bindkey ' ' magic-space
  
  # Ctrl+L clears the screen
  bindkey "${_key_info[Control]}L" clear-screen
  
  # Shift+Tab for reverse completion menu navigation
  [[ -n ${_key_info[BackTab]} ]] && bindkey ${_key_info[BackTab]} reverse-menu-complete
  
  ###############################################################################
  # Optional Features - Only loaded when needed
  ###############################################################################
  
  # Double-dot expansion: typing .. expands to ../
  if [[ ${zdouble_dot_expand} == 'true' ]]; then
    double-dot-expand() {
      if [[ ${LBUFFER} == *.. ]]; then
        LBUFFER+='/..' # Expand to path
      else
        LBUFFER+='.'   # Just add a dot
      fi
    }
    zle -N double-dot-expand
    bindkey '.' double-dot-expand
  fi
  
  ###############################################################################
  # Version-specific Compatibility
  ###############################################################################
  
  # Special handling for older ZSH versions (< 5.3)
  if ! is-at-least 5.3 2>/dev/null; then
    # Show visual indicator during completion and ensure proper redisplay
    expand-or-complete-with-redisplay() {
      print -Pn '...' # Visual indicator
      zle expand-or-complete
      zle redisplay   # Force redisplay after completion
    }
    zle -N expand-or-complete-with-redisplay
    bindkey "${_key_info[Control]}I" expand-or-complete-with-redisplay
  fi
  
  ###############################################################################
  # Command Line Editing Enhancements
  ###############################################################################
  
  # Enable edit-command-line widget for full-featured editing
  autoload -Uz edit-command-line
  zle -N edit-command-line
  bindkey -M vicmd '!' edit-command-line # Edit command in vi command mode
  
  # Memory optimization: clean up temporary variables
  unset _key_info
}

###############################################################################
# Initialization
###############################################################################

# Preload minimal required functions
autoload -Uz is-at-least

# Defer key binding setup for faster shell startup
# Falls back to immediate execution if zsh-defer is not available
zsh-defer _setup_key_bindings 2>/dev/null || _setup_key_bindings
