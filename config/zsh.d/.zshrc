# vim:ft=zsh:
# setopt warn_create_global

##############################################################
# Profiling.
##############################################################

# uncomment to profile & run `zprof`
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
  ${ASDF_DIR}/completions
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
  zinit light https://github.com/Aloxaf/fzf-tab

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

  # # fnm
  # zinit ice wait"2" lucid from"gh-r" as"program" atload'!eval "$(fnm env --multi --use-on-cd --log-level=quiet)"'
  # zinit light Schniz/fnm

  # asdf
### Added by Zinit's installer
ZINIT_DIR="$HOME/.local/share/zinit"
ZINIT_HOME="$ZINIT_DIR/zinit.git"
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$ZINIT_DIR" && command chmod g-rwX "$ZINIT_DIR"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk


# Autosuggestions & fast-syntax-highlighting
zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# zsh-autosuggestions
zinit ice wait lucid atload"!_zsh_autosuggest_start"
zinit load zsh-users/zsh-autosuggestions

# zsh-bd - https://github.com/Tarrasch/zsh-bd
zinit ice wait lucid
zinit light tarrasch/zsh-bd


zinit ice wait'0b' lucid id-as"junegunn/fzf_completions" pick"/dev/null" \
  multisrc"shell/{completion,key-bindings}.zsh"
zinit light junegunn/fzf

# FZF
zinit ice from="gh-r" as="command" bpick="*linux_amd64*"
zinit light junegunn/fzf

# BurntSushi/ripgrep
zinit ice as"command" from"gh-r" mv"ripgrep* -> rg" pick"rg/rg"
zinit light BurntSushi/ripgrep

# fdfind
zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

#stylua
zinit wait'1b' lucid light-mode from'gh-r' as'command' bpick'*linux*.tar.gz' for \
    bpick'*linux.zip' JohnnyMorganz/StyLua \

# shfmt
zinit ice from"gh-r" as"program" mv"shfmt* -> shfmt" fbin"shfmt"
zinit light mvdan/sh

zinit ice wait"0a" as"command" from"gh-r" lucid \
  mv"zoxide*/zoxide -> zoxide" \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide

# zinit ice wait'0' lucid
# zinit snippet 'https://github.com/git/git/contrib/completion/git-prompt.sh'

# asdf-vm
zinit wait lucid as"null" \
    from"github" src"asdf.sh" as"program" for \
    @asdf-vm/asdf

zinit ice lucid wait'1' from"gh-r" as"program" mv"direnv* -> direnv" \
    atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
    pick"direnv" src="zhook.zsh" for \
        direnv/direnv

# it also works with turbo mode:
zinit ice wait lucid
zinit load redxtech/zsh-asdf-direnv

zinit ice wait lucid as"completion"
zinit snippet https://github.com/asdf-vm/asdf/blob/master/completions/_asdf

  ############### Autosuggest
  export ZSH_AUTOSUGGEST_USE_ASYNC="true"
  export ZSH_AUTOSUGGEST_STRATEGY=("match_prev_cmd" "completion")
# }}}

autoload -Uz compinit compdef && compinit -C -d "${ZDOTDIR}/${zcompdump_file:-.zcompdump}"

zinit cdreplay -q

############### Kitty
if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-cursor"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

if [[ ! -z "${KITTY_WINDOW_ID}" ]]; then
  kitty + complete setup zsh | source /dev/stdin
fi

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

##############################################################
# LOCAL.
##############################################################

# https://github.com/zdharma-continuum/zinit#quick-start maybe?
# SSH
alias ssh="ssh $SSH_CONFIG $SSH_ID "
alias ssh-copy-id="ssh-copy-id $SSH_ID"
alias wget="wget --hsts-file="$XDG_CACHE_HOME/wget-hsts""

if [ -f $HOST_CONFIGS/zshrc ]; then
	source $HOST_CONFIGS/zshrc
fi

if [ -e /etc/motd ]; then
  if ! cmp -s ${HOME}/.hushlogin /etc/motd; then
    tee ${HOME}/.hushlogin < /etc/motd
  fi
fi

add-zsh-hook -Uz chpwd (){
  [ -d "node_modules" ] &&
  bin=$PWD/node_modules/.bin
  if [[ ":$PATH:" != *":$bin:"* ]]; then     # check if $bin is already in $PATH
    export PATH=$bin:$PATH                   # prepend $bin to $PATH
  fi
}
