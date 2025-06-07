#!/bin/zsh

# Early return for non-interactive sessions
[[ ! -o interactive ]] && return 0

###############################################################################
# Core Aliases - Loaded Immediately
###############################################################################
# Basic command shortcuts
alias c="clear"                                # Clear terminal screen
alias e='$EDITOR --listen /tmp/nvim.pipe'      # Open editor with socket
alias ec='nvim --cmd ":lua vim.g.noplugins=1"' # Open nvim without plugins
alias df="df -kh"                              # Disk free with human-readable sizes
alias du="du -kh"                              # Disk usage with human-readable sizes

# Navigation shortcuts
alias ..="cd .."             # Go up one directory
alias ...="cd ../.."         # Go up two directories
alias ....="cd ../../.."     # Go up three directories
alias .....="cd ../../../.." # Go up four directories
alias ~="cd ~"               # Go to home directory
alias -- -="cd -"           # Go to previous directory

# Essential file operations
alias ls="ls -G"            # Colored output
alias l="ls -lah"           # Long format, hidden files
alias ll="ls -lh"           # Long format
alias la="ls -lAh"          # Long format, almost all hidden files

###############################################################################
# Development Tools
###############################################################################
# Homebrew
alias cask="brew --cask"

# Node.js/NPM
alias ns="npm start"
alias ni="npm install"
alias nl="npm list --depth=0"
alias nlg="npm list -g --depth=0"
alias nr="npm run"
alias nrd="npm run dev"
alias nrb="npm run build"

# Git shortcuts
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"

# Maven
alias mci="mvn clean install"
alias mcid="mvn clean install -DskipTests"
alias mcp="mvn clean package"
alias mcv="mvn clean verify"
alias mct="mvn clean test"

# Gradle
alias gw='./gradlew'
alias gwr='gw run'
alias gwi='gw idea'

# Rust
alias cgr='cargo run'
alias cgt='cargo test'
alias cgb='cargo build'
alias cgc='cargo check'

###############################################################################
# System Tools
###############################################################################
# File management
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash"

# Finder controls
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# System tools
alias reload="exec ${SHELL} -l"
alias path='echo -e ${PATH//:/\\n}'

# Clipboard utilities
alias pbunformat="pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy"
alias pb-sort="pbpaste | sort | pbcopy"
alias pb-dedup="pbpaste | uniq | pbcopy"
alias pwdc="pwd | tr -d '\n' | pbcopy"

# File stats
alias fs="stat -f '%z bytes'"
alias sizeof="du -sh"
alias dcap="df -h /"
alias count="ls -a | wc -l"

###############################################################################
# Network Tools
###############################################################################
# IP address information
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)'"
alias ip-external="curl ifconfig.me"

# DNS and cache management
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"
alias dns-clear-local-cache="sudo killall -HUP mDNSResponder"

# Curl shortcuts with cached command check
if command -v curl >/dev/null; then
  alias curlh="curl -sILX GET"
  alias curl-get="curl -i -X GET"
  alias curl-post="curl -X POST -d"
  alias curl-put="curl -X PUT -d"
  alias curl-fetch-header='curl -I'
fi

# Download utility with smart fallback
if command -v aria2c >/dev/null; then
  alias get='aria2c --max-connection-per-server=5 --continue'
elif command -v axel >/dev/null; then
  alias get='axel --num-connections=5 --alternate'
elif command -v wget >/dev/null; then
  alias get='wget --continue --progress=bar --timestamping'
elif command -v curl >/dev/null; then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
fi
