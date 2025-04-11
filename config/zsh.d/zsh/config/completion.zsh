#
# Completion enhancements - Optimized for speed
#

#
# initialization
#

# if it's a dumb terminal, return.
if [[ ${TERM} == 'dumb' ]]; then
  return 1
fi

#
# zsh options
#

setopt ALWAYS_TO_END # If a completion is performed with the cursor within a word, and a full completion is inserted, the cursor is moved to the end of the word
setopt PATH_DIRS     # Perform a path search even on command names with slashes in them.
unsetopt CASE_GLOB   # Make globbing (filename generation) not sensitive to case.
unsetopt LIST_BEEP   # Don't beep on an ambiguous completion.

#
# completion module options
#

# group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group yes
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
# Simplified format styles for performance
zstyle ':completion:*:corrections' format ' -- %d (errors: %e) --'
zstyle ':completion:*:descriptions' format ' -- %d --'
zstyle ':completion:*:messages' format ' -- %d --'
zstyle ':completion:*:warnings' format ' -- no matches found --'
zstyle ':completion:*' format ' -- %d --'
zstyle ':completion:*' group-name ''
# Reduced verbosity to improve speed
zstyle ':completion:*' verbose no
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

zstyle ":completion:*" list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*:default' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'expand'
zstyle ':completion:*' squeeze-slashes true

# 启用并优化补全缓存设置
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR}/.zcompcache"
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' accept-exact-dirs 'yes'

# Optimize completion performance
zstyle ':completion:*' rehash true
zstyle ':completion:*' list-packed yes
zstyle ':completion:*' file-sort modification
# Limit menu selection for faster response
zstyle ':completion:*' menu select=5
zstyle ':completion:*' special-dirs true

# Optimize completion matching strategy
zstyle ':completion:*' completer _complete
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
# Simplified matcher list for better performance
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ignore useless commands and functions
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'

# completion sorting
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# history
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'
