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
# Key Binding Setup Functions - Modular and Lazy Loaded
###############################################################################

# Core bindings setup - loaded immediately
_setup_core_bindings() {
  local -A _key_info
  
  # Define core key prefixes
  _key_info=(
    'Control' '\C-'
    'Escape'  '\e'
    'Meta'    '\M-'
  )
  
  # Map essential keys
  zmodload -F zsh/terminfo +b:echoti +p:terminfo 2>/dev/null
  _key_info[Backspace]=${terminfo[kbs]}
  _key_info[Left]=${terminfo[kcub1]}
  _key_info[Right]=${terminfo[kcuf1]}
  
  # Export key mappings
  typeset -gA key_info
  key_info=(${(kv)_key_info})
  
  # Core bindings
  bindkey ' ' magic-space
  bindkey "${_key_info[Control]}L" clear-screen
  
  unset _key_info
}

# Optional bindings setup - deferred loading
_setup_optional_bindings() {
  # Double-dot expansion
  if [[ ${zdouble_dot_expand} == 'true' ]]; then
    double-dot-expand() {
      [[ ${LBUFFER} == *.. ]] && LBUFFER+='/..' || LBUFFER+='.'
    }
    zle -N double-dot-expand
    bindkey '.' double-dot-expand
  fi
  
  # Command line editing
  autoload -Uz edit-command-line
  zle -N edit-command-line
  bindkey -M vicmd '!' edit-command-line
}

# Version compatibility setup - deferred loading
_setup_version_compat() {
  # Simplified version check
  if ! zmodload zsh/pcre 2>/dev/null; then
    # Show visual indicator during completion
    expand-or-complete-with-redisplay() {
      print -Pn '...'
      zle expand-or-complete
      zle redisplay
    }
    zle -N expand-or-complete-with-redisplay
    bindkey "${key_info[Control]}I" expand-or-complete-with-redisplay
  fi
}

###############################################################################
# Initialization with Progressive Loading
###############################################################################

# Load core bindings immediately
_setup_core_bindings

# Defer optional features
zsh-defer -t 0.1 _setup_optional_bindings 2>/dev/null || _setup_optional_bindings

# Defer compatibility features
zsh-defer -t 0.2 _setup_version_compat 2>/dev/null || _setup_version_compat
