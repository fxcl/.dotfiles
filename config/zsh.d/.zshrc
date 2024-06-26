# vim:ft=zsh:
# setopt warn_create_global

##############################################################
# Profiling.
##############################################################

# Start profiling (uncomment when necessary)
#
# See: https://stackoverflow.com/a/4351664/2103996

# Per-command profiling:

# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# exec 3>&2 2> startlog.$$
# setopt xtrace prompt_subst

# Per-function profiling:

# zmodload zsh/zprof

typeset -g ZPLG_MOD_DEBUG=1
declare -A ZINIT

# https://gist.github.com/matthewmccullough/787142
# https://unix.stackexchange.com/questions/273861/unlimited-history-in-zsh
# HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000                          # How many lines of history to keep in memory
SAVEHIST="$HISTSIZE"                      # Number of history entries to save to disk
HISTFILE="${XDG_DATA_HOME}/.zsh_history"  # Where to save history to disk

fpath=(
  ${ZDOTDIR}/functions
  $fpath
)

autoload -Uz ${ZDOTDIR}/functions/**/*(N:t)

##############################################################
# ZINIT https://github.com/zdharma-continuum/zinit
##############################################################
# Investigate why this doesn't work with tmux when I add it to zshenv
ZINIT[HOME_DIR]="$XDG_CACHE_HOME/zsh/zinit"
ZINIT[BIN_DIR]="$ZINIT[HOME_DIR]/bin"
ZINIT[PLUGINS_DIR]="$ZINIT[HOME_DIR]/plugins"
ZINIT[ZCOMPDUMP_PATH]="$XDG_CACHE_HOME/zsh/zcompdump"
# export ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]=1
export ZPFX="$ZINIT[HOME_DIR]/polaris"

local __ZINIT="$ZINIT[BIN_DIR]/zinit.zsh"

if [[ ! -f "$__ZINIT" ]]; then
  if (( $+commands[git] )); then
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT[BIN_DIR]"
  else
    echo 'git not found' >&2
    exit 1
  fi
fi

source "$__ZINIT"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Shell {{{
  # zinit snippet OMZP::gpg-agent

  PURE_SYMBOLS=("λ" "ϟ" "▲" "∴" "→" "»" "৸" "◗")
  # Arrays in zsh starts from 1
  export PURE_PROMPT_SYMBOL="${PURE_SYMBOLS[$RANDOM % ${#PURE_SYMBOLS[@]} + 1]}"
  zstyle :prompt:pure:path color 240
  zstyle :prompt:pure:git:branch color blue
  zstyle :prompt:pure:git:dirty color red
  zstyle :prompt:pure:git:action color 005
  zstyle :prompt:pure:prompt:success color 003
# }}}

# Utilities & enhancements {{{
  zinit ice wait lucid
  zinit light https://github.com/zsh-users/zsh-history-substring-search
  # bind UP and DOWN keys
  bindkey "${terminfo[kcuu1]}" history-substring-search-up
  bindkey "${terminfo[kcud1]}" history-substring-search-down

  # bind UP and DOWN arrow keys (compatibility fallback)
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
# }}}

# Recommended be loaded last {{{
  zinit ice wait blockf lucid atpull'zinit creinstall -q .'
  zinit light https://github.com/zsh-users/zsh-completions

  zinit ice wait lucid atinit'ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay' \
    atload'unset "FAST_HIGHLIGHT[chroma-whatis]" "FAST_HIGHLIGHT[chroma-man]"'
  zinit light https://github.com/zdharma-continuum/fast-syntax-highlighting

  zinit ice wait lucid atload'_zsh_autosuggest_start'
  zinit light https://github.com/zsh-users/zsh-autosuggestions

  ############### Autosuggest
  export ZSH_AUTOSUGGEST_USE_ASYNC="true"
  export ZSH_AUTOSUGGEST_STRATEGY=("match_prev_cmd" "completion")
# }}}

autoload -Uz compinit compdef && compinit -C -d "${ZDOTDIR}/${zcompdump_file:-.zcompdump}"

zinit cdreplay -q

############### Misc
if [ "$(uname)" = "Darwin" ]; then
  # For context https://github.com/github/hub/pull/1962
  # I run in the background to not affect startup time.
  # https://github.com/ahmedelgabri/dotfiles/commit/c8156c2f0cf74917392a0e700668005b8f1bbbdb#r33940655
  (
    if [ -e /usr/local/share/zsh/site-functions/_git ]; then
      command mv -f /usr/local/share/zsh/site-functions/{,disabled.}_git
    fi
  ) &!
fi

eval "$(direnv hook zsh)"
eval "$(zoxide init zsh --hook pwd)"

# starship isn't installed in all of my environments
if [[ `command -v starship` ]]; then
	  eval "$(starship init zsh)"
fi

# config micromamba
if command -v micromamba >/dev/null 2>&1; then
  eval "$(micromamba shell hook --shell zsh)"
  export MAMBA_ROOT_PREFIX="$HOME/micromamba"
fi

##############################################################
# LOCAL.
##############################################################

if [ -f $HOST_CONFIGS/zshrc ]; then
	source $HOST_CONFIGS/zshrc
fi

if [ -e /etc/motd ]; then
  if ! cmp -s ${HOME}/.hushlogin /etc/motd; then
    tee ${HOME}/.hushlogin < /etc/motd
  fi
fi

#
# End profiling (uncomment when necessary)
#

# Per-command profiling:

# unsetopt xtrace
# exec 2>&3 3>&-

# Per-function profiling:

# zprof
