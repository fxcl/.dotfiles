# ==============================================
# Terminal Color Configuration
# ==============================================

# Skip color setup in minimal mode or if terminal doesn't support at least 8 colors
if [[ -z "$ZSH_MINIMAL" ]] && (( terminfo[colors] >= 8 )); then

  # LS Colors - Different settings for GNU and BSD systems
  if (( ${+commands[dircolors]} )); then
    # GNU ls colors
    if [[ ! -v LS_COLORS ]]; then
      if [[ -s ${HOME}/.dir_colors ]]; then
        eval "$(dircolors --sh ${HOME}/.dir_colors)"
      else
        export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43'
      fi
    fi
  else
    # BSD ls colors
    [[ ! -v LSCOLORS ]] && export LSCOLORS='ExfxcxdxbxGxDxabagacad'
  fi

  # Grep colors - Set both BSD (GREP_COLOR) and GNU (GREP_COLORS) variants
  [[ ! -v GREP_COLOR ]] && export GREP_COLOR='37;45'
  [[ ! -v GREP_COLORS ]] && export GREP_COLORS="mt=${GREP_COLOR}"

  # Configure grep alias with color support
  if [[ "$(uname)" == openbsd* ]] && (( ${+commands[ggrep]} )); then
    alias grep='ggrep --color=auto'
  else
    alias grep='grep --color=auto'
  fi

  # Less pager colors - Only set if less is the current pager
  if [[ ${PAGER} == 'less' ]]; then
    # Terminal capability strings for less
    [[ ! -v LESS_TERMCAP_mb ]] && export LESS_TERMCAP_mb=$'\E[1;31m'  # Blinking text
    [[ ! -v LESS_TERMCAP_md ]] && export LESS_TERMCAP_md=$'\E[1;31m'  # Bold text
    [[ ! -v LESS_TERMCAP_me ]] && export LESS_TERMCAP_me=$'\E[0m'     # End all modes
    [[ ! -v LESS_TERMCAP_se ]] && export LESS_TERMCAP_se=$'\E[0m'     # End standout mode
    [[ ! -v LESS_TERMCAP_so ]] && export LESS_TERMCAP_so=$'\E[7m'     # Standout mode
    [[ ! -v LESS_TERMCAP_ue ]] && export LESS_TERMCAP_ue=$'\E[0m'     # End underline
    [[ ! -v LESS_TERMCAP_us ]] && export LESS_TERMCAP_us=$'\E[1;32m'  # Underline text
  fi
fi

# ==============================================
# Download Utility Configuration
# ==============================================

# Define 'get' alias using the fastest available download tool
# Preference order: aria2c > axel > wget > curl
if (( ${+commands[aria2c]} )); then
  alias get='aria2c --max-connection-per-server=5 --continue'
elif (( ${+commands[axel]} )); then
  alias get='axel --num-connections=5 --alternate'
elif (( ${+commands[wget]} )); then
  alias get='wget --continue --progress=bar --timestamping'
elif (( ${+commands[curl]} )); then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
fi
