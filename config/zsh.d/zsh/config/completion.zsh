#!/bin/bash

# set the titles to show the command name typed by the user while
# the command is being executed and then the current directory
# name after the command ended (i.e. before each prompt)
# https://github.com/zimfw/termtitle
zstyle ':zim:termtitle' hooks 'preexec' 'precmd'
zstyle ':zim:termtitle:preexec' format '${1}'
zstyle ':zim:termtitle:precmd'  format '%~'
