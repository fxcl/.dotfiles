# vim:ft=zsh:
# setopt warn_create_global

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

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

# zmodload zsh/zprof

typeset -g ZPLG_MOD_DEBUG=1

# https://gist.github.com/matthewmccullough/787142
# https://unix.stackexchange.com/questions/273861/unlimited-history-in-zsh
HISTSIZE=1000000
SAVEHIST="$HISTSIZE"
HISTFILE="${XDG_DATA_HOME}/.zsh_history"

fpath=(
  ${ZDOTDIR}/functions
  $fpath
)

autoload -Uz ${ZDOTDIR}/functions/**/*(N:t)

PURE_SYMBOLS=("λ" "ϟ" "▲" "∴" "→" "»" "৸")
# Arrays in zsh starts from 1
export PURE_PROMPT_SYMBOL="${PURE_SYMBOLS[$RANDOM % ${#PURE_SYMBOLS[@]} + 1]}"

# For speed:
# https://github.com/zsh-users/zsh-autosuggestions#disabling-automatic-widget-re-binding
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export ZSH_AUTOSUGGEST_USE_ASYNC="true"
export ZSH_AUTOSUGGEST_STRATEGY=("match_prev_cmd" "completion")
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Note that this will only ensure unique history if we supply a prefix
# before hitting "up" (ie. we perform a "search"). HIST_FIND_NO_DUPS
# won't prevent dupes from appearing when just hitting "up" without a
# prefix (ie. that's "zle up-line-or-history" and not classified as a
# "search"). So, we have HIST_IGNORE_DUPS to make life bearable for that
# case.
#
# https://superuser.com/a/1494647/322531
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

############### Misc
if [[ "$OSTYPE" = "darwin"* ]]; then
  # For context https://github.com/github/hub/pull/1962
  # I run in the background to not affect startup time.
  # https://github.com/ahmedelgabri/dotfiles/commit/c8156c2f0cf74917392a0e700668005b8f1bbbdb#r33940655
  (
    if [ -e /usr/local/share/zsh/site-functions/_git ]; then
      command mv -f /usr/local/share/zsh/site-functions/{,disabled.}_git
    fi
  )
fi

# starship isn't installed in all of my environments
if [[ $(command -v starship) ]]; then
  eval "$(starship init zsh)"
fi

# Download proto manager if missing.

if test ! $(which proto); then
  echo "Installing proto..."
  curl -fsSL https://moonrepo.dev/install/proto.sh | bash
  #proto setup
  #proto install node lts
  #proto install yarn
  #proto install pnpm
  #proto install bun
  #proto install rust

  echo 'Done'
fi

# Initialize FZF (requires >=fzf@0.48.0)
source <(fzf --zsh)

# config clang
if command -v clang++ >/dev/null 2>&1; then
  export CXXFLAGS="-stdlib=libc++"
  export LDFLAGS="-stdlib=libc++"
  # export CXX=clang++
fi

##############################################################
# LOCAL.
##############################################################

if [ -f $HOST_CONFIGS/zshrc ]; then
  source $HOST_CONFIGS/zshrc
fi

if [ -e /etc/motd ]; then
  if ! cmp -s ${HOME}/.hushlogin /etc/motd; then
    tee ${HOME}/.hushlogin </etc/motd
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

unset key
