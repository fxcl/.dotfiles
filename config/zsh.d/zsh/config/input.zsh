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

# Disable terminal flow control (freeing Ctrl+S/Ctrl+Q)
[[ -t 0 ]] && stty -ixon

###############################################################################
# Key Binding Setup - Modular Loading
###############################################################################

# Load terminfo module once globally
zmodload -F zsh/terminfo +b:echoti +p:terminfo 2>/dev/null

# Core bindings (immediate load)
_setup_core_bindings() {
  typeset -gA key_info=(
    'Control' '\C-'
    'Escape' '\e'
    'Meta' '\M-'
    'Backspace' "${terminfo[kbs]:-^?}"
    'Left' "${terminfo[kcub1]:-^[[D}"
    'Right' "${terminfo[kcuf1]:-^[[C}"
  )

  # Magic space expands history abbreviations
  bindkey ' ' magic-space

  # Ctrl+L clears screen
  bindkey "${key_info[Control]}L" clear-screen
}

# Optional features (deferred load)
_setup_optional_bindings() {
  # Double-dot path expansion (e.g., '..' becomes '../..')
  if [[ ${zdouble_dot_expand} == 'true' ]]; then
    double-dot-expand() {
      LBUFFER+="${LBUFFER[-2, -1]== '..' ? '/..' : '.'}"
    }
    zle -N double-dot-expand
    bindkey '.' double-dot-expand
  fi

  # Edit command in $EDITOR (bound to '!' in vicmd mode)
  autoload -Uz edit-command-line
  zle -N edit-command-line
  bindkey -M vicmd '!' edit-command-line
}

# Backward compatibility (deferred load)
_setup_version_compat() {
  # Visual indicator for older zsh versions (<5.8)
  if ((ZSH_VERSION < 5.8)); then
    expand-or-complete-with-indicator() {
      print -Pn '...'
      zle expand-or-complete
      zle redisplay
    }
    zle -N expand-or-complete-with-indicator
    bindkey "${key_info[Control]}I" expand-or-complete-with-indicator
  fi
}

###############################################################################
# Initialization
###############################################################################

# Load core functionality immediately
_setup_core_bindings

# Defer non-critical features
if (( $+commands[zsh-defer] )); then
  zsh-defer -t 0.1 _setup_optional_bindings
  zsh-defer -t 0.2 _setup_version_compat
else
  # Fallback to immediate load if zsh-defer missing
  _setup_optional_bindings
  _setup_version_compat
fi
