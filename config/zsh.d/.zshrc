# vim:ft=zsh:
# setopt warn_create_global

##############################################################
# Basic Configuration
##############################################################
HISTSIZE=1000000
SAVEHIST="$HISTSIZE"
HISTFILE="${XDG_DATA_HOME}/.zsh_history"

fpath=(
  ${ZDOTDIR}/functions
  $fpath
)

autoload -Uz ${ZDOTDIR}/functions/**/*(N:t)

##############################################################
# ZI Configuration (https://wiki.zshell.dev)
##############################################################
typeset -g ZI_MOD_DEBUG=1
declare -A ZI

ZI[HOME_DIR]="$XDG_CACHE_HOME/zsh/zi"
ZI[BIN_DIR]="$ZI[HOME_DIR]/bin"
ZI[PLUGINS_DIR]="$ZI[HOME_DIR]/plugins"
ZI[ZCOMPDUMP_PATH]="${ZDOTDIR}/.zcompdump"
ZPFX="$ZI[HOME_DIR]/polaris"

local __ZI="${ZI[BIN_DIR]}/zi.zsh"

# Install zi if it doesn't exist
if [[ ! -f "$__ZI" ]]; then
  if (( $+commands[git] )); then
    git clone https://github.com/z-shell/zi.git "${ZI[BIN_DIR]}"
  else
    print -P "%F{red}Git is not installed, cannot install zi%f" >&2
    exit 1
  fi
fi

source "$__ZI"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

##############################################################
# Plugin Configuration
##############################################################
# Pure theme
PURE_SYMBOLS=("λ" "ϟ" "▲" "∴" "→" "»" "৸")
export PURE_PROMPT_SYMBOL="${PURE_SYMBOLS[$RANDOM % ${#PURE_SYMBOLS[@]} + 1]}"

zi ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zi light sindresorhus/pure

zstyle :prompt:pure:path color 240
zstyle :prompt:pure:git:branch color blue
zstyle :prompt:pure:git:dirty color red
zstyle :prompt:pure:git:action color 005
zstyle :prompt:pure:prompt:success color 003

# History substring search
zi ice wait lucid
zi light zsh-users/zsh-history-substring-search

# Completion system
zi ice wait blockf lucid atpull'zi creinstall -q .'
zi light zsh-users/zsh-completions

# Syntax highlighting
zi ice wait lucid atinit'ZI[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay' \
  atload'unset "FAST_HIGHLIGHT[chroma-whatis]" "FAST_HIGHLIGHT[chroma-man]"'
zi light zdharma-continuum/fast-syntax-highlighting

# Autosuggestions
zi ice wait lucid atload'_zsh_autosuggest_start'
zi light zsh-users/zsh-autosuggestions

# Completion initialization
autoload -Uz compinit compdef
compinit -C -d "${ZI[ZCOMPDUMP_PATH]}"

##############################################################
# Key Bindings
##############################################################
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

##############################################################
# Other Tool Configurations
##############################################################
# macOS specific configuration
if [[ "$OSTYPE" = "darwin"* ]]; then
  ( # Background completion conflict handling
    if [ -e /usr/local/share/zsh/site-functions/_git ]; then
      command mv -f /usr/local/share/zsh/site-functions/{,disabled.}_git
    fi
  ) &!
fi

# Environment tools
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh --hook pwd)"

# Starship prompt
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# FZF configuration
source <(fzf --zsh 2>/dev/null)

# Proto environment management
if ! (( $+commands[proto] )); then
  echo "Installing proto..."
  curl -fsSL https://moonrepo.dev/install/proto.sh | bash
fi

# C++ environment configuration
if (( $+commands[clang++] )); then
  export CXXFLAGS="-stdlib=libc++"
  export LDFLAGS="-stdlib=libc++"
fi

##############################################################
# Local Configuration
##############################################################
[[ -f $HOST_CONFIGS/zshrc ]] && source $HOST_CONFIGS/zshrc
[[ -e /etc/motd ]] && ! cmp -s ${HOME}/.hushlogin /etc/motd ]] && tee ${HOME}/.hushlogin < /etc/motd
