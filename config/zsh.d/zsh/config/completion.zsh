#!/bin/bash

#######################################################################
#                        zmoudles: completion                         #
#######################################################################

# Add those zstyles to your ~/.zshrc before where the modules are initialized.
ZSH_COMPDUMP="$ZSH_CACHE/zcompdump"


# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' expand suffix
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._- ]=* r:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %S%l%s
zstyle ':compinstall'  filename "$ZDOTDIR/option.zsh"
# autoload -Uz compinit
# compinit
# End of lines added by compinstall
