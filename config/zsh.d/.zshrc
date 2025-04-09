# vim:ft=zsh:

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

if whence brew >/dev/null; then
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fi

# Load all functions from ZDOTDIR/functions
autoload -Uz ${ZDOTDIR}/functions/**/*(N:t)

##############################################################
# ZI Configuration (https://wiki.zshell.dev)
# Initialize ZI package manager with optimized settings
##############################################################
typeset -g ZI_MOD_DEBUG=0 # Disable debug mode for better performance
declare -A ZI

# Set ZI paths with optimized cache settings
ZI[HOME_DIR]="$XDG_CACHE_HOME/zsh/zi"
ZI[BIN_DIR]="$ZI[HOME_DIR]/bin"
ZI[PLUGINS_DIR]="$ZI[HOME_DIR]/plugins"
ZI[ZCOMPDUMP_PATH]="${ZDOTDIR}/.zcompdump"
ZI[COMPINIT_OPTS]="-C" # Skip security check for faster startup
ZPFX="$ZI[HOME_DIR]/polaris"

local __ZI="${ZI[BIN_DIR]}/zi.zsh"

# Install zi if not present
if [[ ! -f "$__ZI" ]]; then
  if whence git >/dev/null; then
    git clone --depth 1 https://github.com/z-shell/zi.git "${ZI[BIN_DIR]}"
  else
    print -P "%F{red}Git is not installed, cannot install zi%f" >&2
    exit 1
  fi
fi

source "$__ZI"
autoload -Uz _zi
[[ -v _comps ]] && typeset -gA _comps && _comps[zi]=_zi

##############################################################
# Plugin Configuration
# Load plugins with turbo mode for better performance
##############################################################
# Pure theme - Load theme components with optimization
PURE_SYMBOLS=("λ" "ϟ" "▲" "∴" "→" "»" "৸")
export PURE_PROMPT_SYMBOL="${PURE_SYMBOLS[$RANDOM % ${#PURE_SYMBOLS[@]} + 1]}"

# 使用wait'0'而不是wait'!'可以稍微延迟加载主题，但不会影响视觉体验
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

# 优化zstyle配置 - 在compinit之前设置以提高性能
# 设置补全缓存
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR}/.zcompcache"

# 优化补全匹配和性能
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' accept-exact-dirs 'yes'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# 限制补全列表大小以提高性能
zstyle ':completion:*' list-packed yes
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'

# Completion system - Load with turbo mode
zi ice wait'0' lucid blockf atpull'zi creinstall -q .'
zi light zsh-users/zsh-completions

# 优化completion系统初始化 - 只在必要时重新生成zcompdump
# 检查缓存是否需要重建（每天只检查一次）
# Cross-platform stat command to get file modification time
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

autoload -Uz compinit compdef
if [[ -f "${ZDOTDIR}/.zcompdump" ]] && (($(stat_mtime "${ZDOTDIR}/.zcompdump") <= ($(date +%s) - 86400))); then
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
# macOS specific configuration - Handle completion conflicts
# Disable git completion on macOS if it exists in homebrew location
if [[ "$OSTYPE" = darwin* ]]; then
  if [[ -e /usr/local/share/zsh/site-functions/_git ]]; then
    # Run synchronously but quickly since we're just moving one file
    command mv -f /usr/local/share/zsh/site-functions/_git \
      /usr/local/share/zsh/site-functions/disabled._git 2>/dev/null
  fi
fi
# Load environment tools with lazy loading - optimized for faster startup
# Initialize direnv and zoxide asynchronously
# Initialize direnv and zoxide with proper error handling
if whence direnv >/dev/null; then
  eval "$(direnv hook zsh 2>/dev/null)" || echo "Failed to initialize direnv"
fi
if whence zoxide >/dev/null; then
  eval "$(zoxide init zsh --hook pwd 2>/dev/null)" || echo "Failed to initialize zoxide"
fi

# Initialize starship prompt if available
if whence starship >/dev/null; then
  eval "$(starship init zsh)"
fi

# Load FZF configuration
[[ -f "$(which fzf)" ]] && source <(fzf --zsh 2>/dev/null)

# Source proto setup script from dotfiles if available
[[ -f "$ZDOTDIR/bin/proto" ]] && source "$ZDOTDIR/bin/proto"

# Configure C++ environment if clang++ is available
if whence clang++ >/dev/null; then
  export CXXFLAGS="-stdlib=libc++"
  export LDFLAGS="-stdlib=libc++"
fi

##############################################################
# Local Configuration
# Load host-specific configurations
##############################################################
[[ -f $HOST_CONFIGS/zshrc ]] && source $HOST_CONFIGS/zshrc
[[ -e /etc/motd ]] && [[ ! -f ${HOME}/.hushlogin ]] && tee ${HOME}/.hushlogin </etc/motd
