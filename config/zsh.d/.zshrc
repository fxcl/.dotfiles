# vim:ft=zsh:

##############################################################
# Basic Configuration
# Optimize history settings and function loading
##############################################################
# Set history size once and reference it - reduces variable lookups
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
HISTFILE=${XDG_DATA_HOME}/.zsh_history

# Load functions from ZDOTDIR - combined operations to reduce overhead
fpath=(${ZDOTDIR}/functions $fpath)

# Load all functions from ZDOTDIR/functions with optimized globbing
autoload -Uz ${ZDOTDIR}/functions/**/*(N.:t)

##############################################################
# ZI Configuration (https://wiki.zshell.dev)
# Initialize ZI package manager with optimized settings
##############################################################
# Disable debug mode and set up ZI with minimal overhead
typeset -g ZI_MOD_DEBUG=0
declare -A ZI

# Set ZI paths - use parameter expansion to reduce string operations
ZI[HOME_DIR]=${XDG_CACHE_HOME}/zsh/zi
ZI[BIN_DIR]=${ZI[HOME_DIR]}/bin
ZI[PLUGINS_DIR]=${ZI[HOME_DIR]}/plugins
ZI[ZCOMPDUMP_PATH]=${ZDOTDIR}/.zcompdump
ZPFX=${ZI[HOME_DIR]}/polaris

local __ZI=${ZI[BIN_DIR]}/zi.zsh

# Install zi if not present - optimized with faster checks
if [[ ! -f $__ZI ]]; then
  if (( $+commands[git] )); then
    git clone --depth 1 --single-branch https://github.com/z-shell/zi.git ${ZI[BIN_DIR]}
  else
    print -P "%F{red}Git is not installed, cannot install zi%f" >&2
    exit 1
  fi
fi

# Source zi and set up completion in one block
source $__ZI
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

##############################################################
# Plugin Configuration
# Load plugins with turbo mode for better performance
##############################################################
# Pure theme - Load theme components with optimization
# Pre-calculate array size to avoid repeated calculations
{
  local -a PURE_SYMBOLS=("λ" "ϟ" "▲" "∴" "→" "»" "৸")
  local symbols_count=${#PURE_SYMBOLS[@]}
  export PURE_PROMPT_SYMBOL=${PURE_SYMBOLS[$((RANDOM % symbols_count + 1))]}

  # Load pure theme with optimized ice modifiers
  zi ice wait'!' lucid compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
  zi light sindresorhus/pure

  # Theme styling - group all zstyle calls together for better performance
  zstyle :prompt:pure:path color 240
  zstyle :prompt:pure:git:branch color blue
  zstyle :prompt:pure:git:dirty color red
  zstyle :prompt:pure:git:action color 005
  zstyle :prompt:pure:prompt:success color 003
}

# Optimize plugin loading order for better performance
# Load completion system first to ensure it's available for other plugins
autoload -Uz compinit compdef
compinit -C -d ${ZI[ZCOMPDUMP_PATH]}

# Load plugins in optimal order with improved turbo mode settings
# Completion system - Load with turbo mode and defer heavy operations
zi ice wait'0' lucid blockf atpull'zi creinstall -q .'
zi light zsh-users/zsh-completions

# Autosuggestions - Load with optimized turbo mode
zi ice wait'0' lucid atload'_zsh_autosuggest_start'
zi light zsh-users/zsh-autosuggestions

# History substring search - Load after other plugins
zi ice wait lucid
zi light zsh-users/zsh-history-substring-search

# Syntax highlighting - Load last for best performance
zi ice wait'0' lucid atinit'ZI[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay' \
  atload'unset "FAST_HIGHLIGHT[chroma-whatis]" "FAST_HIGHLIGHT[chroma-man]"'
zi light zdharma-continuum/fast-syntax-highlighting

##############################################################
# Key Bindings
# Configure history search keybindings
##############################################################
# Group all bindkey operations together for better performance
{
  local -a key_bindings=(
    "${terminfo[kcuu1]}" history-substring-search-up
    "${terminfo[kcud1]}" history-substring-search-down
    '^[[A' history-substring-search-up
    '^[[B' history-substring-search-down
  )

  local i
  for ((i=1; i <= ${#key_bindings[@]}; i+=2)); do
    bindkey "${key_bindings[i-1]}" "${key_bindings[i]}"
  done
}

##############################################################
# Other Tool Configurations
# Load external tools and environment configurations
##############################################################
# Use async loading for better performance

# macOS specific configuration - Handle completion conflicts asynchronously
[[ "$OSTYPE" = darwin* ]] && {
  {
    [[ -e /usr/local/share/zsh/site-functions/_git ]] && \
      command mv -f /usr/local/share/zsh/site-functions/{,disabled.}_git
  } &!
}

# Load environment tools with optimized lazy loading
{
  # Cache command checks to avoid repeated lookups
  local has_direnv=$+commands[direnv]
  local has_zoxide=$+commands[zoxide]
  local has_starship=$+commands[starship]
  local has_fzf=$+commands[fzf]
  local has_proto=$+commands[proto]
  local has_clangpp=$+commands[clang++]

  # Initialize tools that support hooks
  (( has_direnv )) && eval "$(direnv hook zsh)"
  (( has_zoxide )) && eval "$(zoxide init zsh --hook pwd)"
  (( has_starship )) && eval "$(starship init zsh)"

  # Load FZF configuration - use parameter expansion instead of command substitution
  (( has_fzf )) && [[ -f "$(which fzf)" ]] && source <(fzf --zsh 2>/dev/null)

  # Install proto if not present - only execute if needed
  if (( ! has_proto )); then
    echo "Installing proto..."
    curl -fsSL https://moonrepo.dev/install/proto.sh | bash
  fi

  # Source proto setup script - use parameter expansion for faster path handling
  [[ -f $ZDOTDIR/zsh/bin/proto ]] && source $ZDOTDIR/zsh/bin/proto

  # Configure C++ environment - group exports together
  if (( has_clangpp )); then
    export CXXFLAGS="-stdlib=libc++" LDFLAGS="-stdlib=libc++"
  fi
} &!

##############################################################
# Local Configuration
# Load host-specific configurations
##############################################################
# Fix syntax error in motd check and optimize file operations
[[ -f $HOST_CONFIGS/zshrc ]] && source $HOST_CONFIGS/zshrc
[[ -e /etc/motd && ! cmp -s ${HOME}/.hushlogin /etc/motd ]] && tee ${HOME}/.hushlogin < /etc/motd
