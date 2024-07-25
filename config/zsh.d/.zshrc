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
# # More human readable
# PS4=$'%D{%S.%.} %N:%i> '
# exec 3>&2 2> startlog.$$
# setopt xtrace prompt_subst

# Per-function profiling:

zmodload zsh/zprof

typeset -g ZPLG_MOD_DEBUG=1
declare -A ZINIT

# https://gist.github.com/matthewmccullough/787142
# https://unix.stackexchange.com/questions/273861/unlimited-history-in-zsh
HISTSIZE=1000000
SAVEHIST="$HISTSIZE"
HISTFILE="${XDG_DATA_HOME}/.zsh_history"
HISTDUP=erase

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
ZINIT[ZCOMPDUMP_PATH]="${ZDOTDIR}/.zcompdump"
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


# Keybindings
# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region


# bind UP and DOWN keys
#bindkey "${terminfo[kcuu1]}" history-substring-search-up
#bindkey "${terminfo[kcud1]}" history-substring-search-down

# bind UP and DOWN arrow keys (compatibility fallback)
#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down

#
# zsh-history-substring-search
#

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

# For speed:
# https://github.com/zsh-users/zsh-autosuggestions#disabling-automatic-widget-re-binding
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export ZSH_AUTOSUGGEST_USE_ASYNC="true"
export ZSH_AUTOSUGGEST_STRATEGY=("match_prev_cmd" "completion")

# Note that this will only ensure unique history if we supply a prefix
# before hitting "up" (ie. we perform a "search"). HIST_FIND_NO_DUPS
# won't prevent dupes from appearing when just hitting "up" without a
# prefix (ie. that's "zle up-line-or-history" and not classified as a
# "search"). So, we have HIST_IGNORE_DUPS to make life bearable for that
# case.
#
# https://superuser.com/a/1494647/322531
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# NOTE: must come before zsh-history-substring-search & zsh-syntax-highlighting.
autoload -U select-word-style
select-word-style bash # only alphanumeric chars are considered WORDCHARS

zinit ice wait lucid
zinit light https://github.com/zsh-users/zsh-history-substring-search

zinit ice wait blockf lucid atpull'zinit creinstall -q .'
zinit light https://github.com/zsh-users/zsh-completions

#zinit ice wait lucid atinit'ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay' \
# atload'unset "FAST_HIGHLIGHT[chroma-whatis]" "FAST_HIGHLIGHT[chroma-man]"'
#zinit light https://github.com/zdharma-continuum/fast-syntax-highlighting

zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light https://github.com/zsh-users/zsh-autosuggestions

autoload -Uz compinit compdef && compinit -C -d "$ZINIT[ZCOMPDUMP_PATH]"

zinit cdreplay -q

############### Misc
if [[ "$OSTYPE" = "darwin"* ]]; then
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

# Download proto manager if missing.
if [[ ! -e ${HOME}/.proto ]]; then
  curl -fsSL https://moonrepo.dev/install/proto.sh | bash
  #proto setup
  #proto install node 20
  #proto install yarn
  #proto install pnpm
fi

# Initialize FZF (requires >=fzf@0.48.0)
source <(fzf --zsh)

# config micromamba
if command -v micromamba >/dev/null 2>&1; then
  eval "$(micromamba shell hook --shell zsh)"
  export MAMBA_ROOT_PREFIX="$HOME/micromamba"
fi

# config clang
if command -v clang++ >/dev/null 2>&1; then
export CXXFLAGS="-stdlib=libc++"
export LDFLAGS="-stdlib=libc++"
#export CXX=clang++
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
