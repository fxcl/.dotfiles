# vim:ft=zsh:

# Helper functions
has() {
  whence "$1" >/dev/null
}

# Combined initialization function
init_env() {
  # macOS specific setup
  if [[ "$OSTYPE" = darwin* ]]; then
    [[ -e /usr/local/share/zsh/site-functions/_git ]] &&
      command mv -f /usr/local/share/zsh/site-functions/_git \
        /usr/local/share/zsh/site-functions/disabled._git 2>/dev/null
    has clang++ && export CXXFLAGS="-stdlib=libc++" LDFLAGS="-stdlib=libc++"
  fi

  # Initialize external tools silently
  has direnv && eval "$(direnv hook zsh 2>/dev/null)"
  has zoxide && eval "$(zoxide init zsh --hook pwd 2>/dev/null)"
  has starship && eval "$(starship init zsh)"
  has fzf && source <(fzf --zsh 2>/dev/null)
}

##############################################################
# Basic Configuration
# Optimize history settings and function loading
##############################################################
HISTSIZE=1000000
SAVEHIST="$HISTSIZE"
HISTFILE="${XDG_DATA_HOME}/.zsh_history"

# Load functions from ZDOTDIR
fpath=(
  ${ZDOTDIR}/functions
  $fpath
)

# Setup fpath with brew if available
if has brew; then
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fi

# Load all functions from ZDOTDIR/functions
autoload -Uz ${ZDOTDIR}/functions/**/*(N:t)

# Optimized ZI configuration
typeset -gA ZI=(
  [HOME_DIR]="$XDG_CACHE_HOME/zsh/zi"
  [BIN_DIR]="$XDG_CACHE_HOME/zsh/zi/bin"
  [PLUGINS_DIR]="$XDG_CACHE_HOME/zsh/zi/plugins"
  [ZCOMPDUMP_PATH]="${ZDOTDIR}/.zcompdump"
  [COMPINIT_OPTS]="-C"
)
ZPFX="$ZI[HOME_DIR]/polaris"

# Load ZI if available, otherwise install it
if [[ -f "${ZI[BIN_DIR]}/zi.zsh" ]]; then
  source "${ZI[BIN_DIR]}/zi.zsh"
  autoload -Uz _zi
  [[ -v _comps ]] && _comps[zi]=_zi
elif has git; then
  git clone --depth 1 https://github.com/z-shell/zi.git "${ZI[BIN_DIR]}" &&
    source "${ZI[BIN_DIR]}/zi.zsh" &&
    autoload -Uz _zi &&
    [[ -v _comps ]] && _comps[zi]=_zi
fi

##############################################################
# Plugin Configuration
# Load plugins with turbo mode for better performance
##############################################################
# Pure theme - Load theme components with optimization
PURE_SYMBOLS=("λ" "ϟ" "▲" "∴" "→" "»" "৸")
export PURE_PROMPT_SYMBOL="${PURE_SYMBOLS[$RANDOM % ${#PURE_SYMBOLS[@]} + 1]}"

# Using wait'0' instead of wait'!' slightly delays theme loading without affecting visual experience
zi ice wait'0' lucid compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zi light sindresorhus/pure

# Theme styling
zstyle :prompt:pure:path color 240
zstyle :prompt:pure:git:branch color blue
zstyle :prompt:pure:git:dirty color red
zstyle :prompt:pure:git:action color 005
zstyle :prompt:pure:prompt:success color 003

# History substring search - Load after compinit
zi ice wait lucid
zi light zsh-users/zsh-history-substring-search

# Optimize zstyle configuration - Set before compinit for better performance
# Configure completion cache
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR}/.zcompcache"

# Optimize completion matching and performance
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' accept-exact-dirs 'yes'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Limit completion list size for better performance
zstyle ':completion:*' list-packed yes
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'

# Optimized completion loading
zi ice wait'0' lucid blockf
zi light zsh-users/zsh-completions

# Optimized compinit logic with cross-platform stat
stat_mtime() {
  local file=$1
  local mtime=0

  # Try BSD stat first (macOS)
  if mtime=$(stat -f %m "$file" 2>/dev/null); then
    echo $mtime
    return 0
  fi

  # Try GNU stat if BSD stat failed
  if mtime=$(stat -c %Y "$file" 2>/dev/null); then
    echo $mtime
    return 0
  fi

  # Fallback to current time if stat fails
  mtime=$(date +%s)
  echo $mtime
  return 0
}

autoload -Uz compinit
if [[ -f "${ZI[ZCOMPDUMP_PATH]}" ]] && (($(stat_mtime "${ZI[ZCOMPDUMP_PATH]}") <= ($(date +%s) - 86400))); then
  compinit -d "${ZI[ZCOMPDUMP_PATH]}"
else
  compinit -C -d "${ZI[ZCOMPDUMP_PATH]}"
fi

# Syntax highlighting - Load with optimized settings and increased delay
zi ice wait'2' lucid atinit'ZI[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay' \
  atload'unset "FAST_HIGHLIGHT[chroma-whatis]" "FAST_HIGHLIGHT[chroma-man]" "FAST_HIGHLIGHT[chroma-which]"'
zi light zdharma-continuum/fast-syntax-highlighting

# Autosuggestions - Load with increased delay for faster startup
zi ice wait'2' lucid atload'_zsh_autosuggest_start'
zi light zsh-users/zsh-autosuggestions

##############################################################
# Key Bindings
# Configure history search keybindings
##############################################################
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

##############################################################
# Other Tool Configurations
# Load external tools and environment configurations
##############################################################
# Initialize environment
init_env

# Source proto setup script from dotfiles if available
[[ -f "$ZDOTDIR/bin/proto" ]] && source "$ZDOTDIR/bin/proto"

##############################################################
# Local Configuration
# Load host-specific configurations
##############################################################
[[ -f $HOST_CONFIGS/zshrc ]] && source $HOST_CONFIGS/zshrc
[[ -e /etc/motd ]] && [[ ! -f ${HOME}/.hushlogin ]] && tee ${HOME}/.hushlogin </etc/motd
