# vim: ft=zsh et ts=4 sw=0
# inspired by: https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/af-magic.zsh-theme


# the color palette
typeset -gA _fg
   _fg[red]='%F{009}'
 _fg[steel]='%F{075}'
   _fg[sky]='%F{110}'
_fg[orange]='%F{214}'
  _fg[gray]='%F{247}'

export LS_COLORS="$LS_COLORS:di=01;38;5;39:ln=01;38;5;37:"


# the primary prompt
setopt PROMPT_{SUBST,PERCENT}
PROMPT='$_fg[steel]$(initials)'
PROMPT+='${(e)git_info[prompt]}'
PROMPT+=" %(!.$_fg[red]#.$_fg[sky]»)%f "


# the secondary prompt
PROMPT2="$_fg[red]\ %f"


# the right prompt
typeset -g VIRTUAL_ENV_DISABLE_PROMPT=1
RPROMPT="$_fg[gray]%n@%m "
RPROMPT+='%(?.${VIRTUAL_ENV:+$_fg[sky]}.$_fg[red])${${VIRTUAL_ENV##*/}:-%y}%f'


# depends on the git-info module to show git information
typeset -gA git_info
if (( ${+functions[git-info]} )); then
    zstyle ':zim:git-info:branch'    format '%b'
    zstyle ':zim:git-info:commit'    format '%c'
    zstyle ':zim:git-info:action'    format ': %s'
    zstyle ':zim:git-info:unindexed' format '*'
    zstyle ':zim:git-info:indexed'   format '+'
    zstyle ':zim:git-info:keys'      format 'prompt' \
        "$_fg[sky](%b%c%s$_fg[orange]%I%i$_fg[sky])%f"
    add-zsh-hook precmd git-info
fi

# Completion enhancements
#


#
# initialization
#

# if it's a dumb terminal, return.
if [[ ${TERM} == 'dumb' ]]; then
  return 1
fi

#
# completion module options
#

#group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group yes
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' '+r:|?=**'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'expand'
zstyle ':completion:*' squeeze-slashes true

# enable caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR}/.zcompcache"

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
# autoload -Uz compinit
# compinit
# End of lines added by compinstall
