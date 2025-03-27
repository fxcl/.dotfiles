# Zsh input configuration and key bindings
# =======================================

# [Terminal Capability Check]
# Exit if terminal doesn't support advanced features
[[ ${TERM} == 'dumb' ]] && return 1

# [Vi Mode Configuration]
# Enable vi mode with shorter timeout (1/100 sec)
bindkey -v
export KEYTIMEOUT=1

# [Terminal Key Info Setup]
# Load terminal capabilities and define key mappings
zmodload -F zsh/terminfo +b:echoti +p:terminfo

typeset -gA key_info=(
  # Modifier keys
  'Control'   '\C-'
  'Escape'    '\e'
  'Meta'      '\M-'

  # Navigation keys
  'Left'      ${terminfo[kcub1]}
  'Right'     ${terminfo[kcuf1]}
  'Up'        ${terminfo[kcuu1]}
  'Down'      ${terminfo[kcud1]}
  'Home'      ${terminfo[khome]}
  'End'       ${terminfo[kend]}

  # Editing keys
  'Backspace' ${terminfo[kbs]}
  'Delete'    ${terminfo[kdch1]}
  'Insert'    ${terminfo[kich1]}

  # Function keys
  'F1'        ${terminfo[kf1]}
  'F2'        ${terminfo[kf2]}
  'F3'        ${terminfo[kf3]}
  'F4'        ${terminfo[kf4]}
  'F5'        ${terminfo[kf5]}
  'F6'        ${terminfo[kf6]}
  'F7'        ${terminfo[kf7]}
  'F8'        ${terminfo[kf8]}
  'F9'        ${terminfo[kf9]}
  'F10'       ${terminfo[kf10]}
  'F11'       ${terminfo[kf11]}
  'F12'       ${terminfo[kf12]}

  # Special keys
  'BackTab'   ${terminfo[kcbt]}
  'PageUp'    ${terminfo[kpp]}
  'PageDown'  ${terminfo[knp]}
)

# [Smart Expansion Features]
# Enable double-dot expansion if configured
if [[ ${zdouble_dot_expand} == 'true' ]]; then
  double-dot-expand() {
    [[ ${LBUFFER} == *.. ]] && LBUFFER+='/..' || LBUFFER+='.'
  }
  zle -N double-dot-expand
  bindkey '.' double-dot-expand
fi

# [Key Bindings]
# General bindings
bindkey ' ' magic-space                     # Smart space expansion
bindkey "${key_info[Control]}L" clear-screen # Ctrl+L to clear screen
[[ -n ${key_info[BackTab]} ]] && bindkey ${key_info[BackTab]} reverse-menu-complete # Shift+Tab for reverse completion

# Vi mode specific bindings
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
bindkey -M vicmd 'v' edit-command-line

# [Terminal Application Mode]
# Handle terminal application mode switching
zle-line-init() {
  (( ${+terminfo[smkx]} )) && echoti smkx
  zle -K viins  # Start in insert mode
}
zle-line-finish() { (( ${+terminfo[rmkx]} )) && echoti rmkx }
zle -N zle-line-init
zle -N zle-line-finish
