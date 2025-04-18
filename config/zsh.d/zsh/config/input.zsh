#
# Editor and input char assignment - Optimized for faster loading
#

# Set vi mode
bindkey -v

# Allow using Ctrl+S and Ctrl+Q
[ -t 0 ] && stty -ixon

# Lazy load terminfo module and key bindings
_setup_key_bindings() {
  # Load terminfo module on demand
  zmodload -F zsh/terminfo +b:echoti +p:terminfo 2>/dev/null
  
  # Use local variables to reduce memory usage
  local -A _key_info
  _key_info=(
    'Control' '\C-'
    'Escape' '\e'
    'Meta' '\M-'
  )
  
  # Only predefine the most commonly used keys, define others as needed
  _key_info[Backspace]=${terminfo[kbs]}
  _key_info[Left]=${terminfo[kcub1]}
  _key_info[Right]=${terminfo[kcuf1]}
  _key_info[Up]=${terminfo[kcuu1]}
  _key_info[Down]=${terminfo[kcud1]}
  _key_info[BackTab]=${terminfo[kcbt]}
  
  # Export to global variable for use by other scripts
  typeset -gA key_info
  key_info=(${(kv)_key_info})
  
  # Basic key bindings
  bindkey ' ' magic-space
  bindkey "${_key_info[Control]}L" clear-screen
  [[ -n ${_key_info[BackTab]} ]] && bindkey ${_key_info[BackTab]} reverse-menu-complete
  
  # Conditional features
  if [[ ${zdouble_dot_expand} == 'true' ]]; then
    double-dot-expand() {
      if [[ ${LBUFFER} == *.. ]]; then
        LBUFFER+='/..' 
      else
        LBUFFER+='.'
      fi
    }
    zle -N double-dot-expand
    bindkey '.' double-dot-expand
  fi
  
  # Version-specific features
  if ! is-at-least 5.3 2>/dev/null; then
    # Redisplay after completing
    expand-or-complete-with-redisplay() {
      print -Pn '...'
      zle expand-or-complete
      zle redisplay
    }
    zle -N expand-or-complete-with-redisplay
    bindkey "${_key_info[Control]}I" expand-or-complete-with-redisplay
  fi
  
  # Command line editing features
  autoload -Uz edit-command-line
  zle -N edit-command-line
  bindkey -M vicmd '!' edit-command-line
  
  # Clean up local variables that are no longer needed
  unset _key_info
}

# Preload necessary autoload
autoload -Uz is-at-least

# Use zsh hook function to lazy load key bindings
zsh-defer _setup_key_bindings 2>/dev/null || _setup_key_bindings
