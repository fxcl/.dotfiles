#!/bin/zsh

# Early return for non-interactive sessions
[[ ! -o interactive ]] && return 0

###############################################################################
# Core Aliases - Loaded Immediately
###############################################################################
# Basic command shortcuts
alias c="clear"                                                                          # Clear terminal screen
alias e='$EDITOR --listen /tmp/nvim.pipe'                                                # Open editor with socket
alias ec='nvim --cmd ":lua vim.g.noplugins=1"'                                           # Open nvim without plugins
alias df="df -kh"                                                                        # Disk free with human-readable sizes
alias du="du -kh"                                                                        # Disk usage with human-readable sizes
alias dt='du -sh * | sort -rh | awk "{sum+=$1; print} END {print \"Total Size: \" sum}"' # Directory sizes sorted

# Navigation shortcuts
alias ..="cd .."             # Go up one directory
alias ...="cd ../.."         # Go up two directories
alias ....="cd ../../.."     # Go up three directories
alias .....="cd ../../../.." # Go up four directories
alias ~="cd ~"               # Go to home directory
alias -- -="cd -"           # Go to previous directory

# List all files excluding hidden ones, sorted
alias listdir='find ${1:-.} -type f -not -path "*/.*/*" -print0 | xargs -0 -I {} bash -c "echo \"$(dirname \"{}\")\"$(basename \"{}\")\"" | sort -t/ -k2 -k3'

# Cross-platform fallbacks
command -v hd >/dev/null || alias hd="hexdump -C"
command -v md5sum >/dev/null || alias md5sum="md5"
command -v sha1sum >/dev/null || alias sha1sum="shasum"

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
alias nu="npm uninstall"
alias nrp="npm run prisma:studio"
alias prettify="prettier --write"

# Git shortcuts
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gdcm="git diff HEAD | ask cm"

# Maven
alias mvnd="mvnDebug"
alias mci="mvn clean install"
alias mcid="mvn clean install -DskipTests"
alias mcp="mvn clean package"
alias mcv="mvn clean verify"
alias mct="mvn clean test"
alias mvn-ls-deps="mvn dependency:tree"
alias run-spring="mvn spring-boot:run"

# Gradle
alias gw='./gradlew'
alias gwr='gw run'
alias gwi='gw idea'

# Rust
alias cgr='cargo run'
alias cgt='cargo test'
alias cgb='cargo build'
alias cgc='cargo check'
alias cdo='cargo doc --open'

###############################################################################
# System Tools
###############################################################################
# File management
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Finder controls
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Spotlight controls
alias spotoff="sudo mdutil -a -i off"
alias spoton="sudo mdutil -a -i on"

# System tools
alias reload="exec ${SHELL} -l"
alias path='echo -e ${PATH//:/\\n}'
alias plistbuddy="/usr/libexec/PlistBuddy"
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Audio controls
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume output volume 100'"

# Browser management
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Clipboard utilities
alias pbunformat="pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy"
alias pb-tab-to-pace="pbpaste | expand | pbcopy"
alias pb-sort="pbpaste | sort | pbcopy"
alias pb-dedup="pbpaste | uniq | pbcopy"
alias pb-sort-dedup="pbpaste | sort | uniq | pbcopy"
alias pwdc="pwd | tr -d '\n' | pbcopy"

###############################################################################
# Network Tools
###############################################################################
# IP address information
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias ip-en="ipconfig getifaddr en0"
alias ip-lan="ipconfig getifaddr en1"
alias ip-external="curl ifconfig.me"

# DNS and cache management
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"
alias dns-clear-local-cache="sudo killall -HUP mDNSResponder"

# Curl shortcuts
if command -v curl >/dev/null; then
  alias curlh="curl -sILX GET"
  alias curld="curl -A \"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36\""
  alias curlm="curl -A \"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) CriOS/28.0.1500.12 Mobile/10B329 Safari/8536.25\""
  alias curl-get="curl -i -X GET"
  alias curl-post="curl -X POST -d"
  alias curl-put="curl -X PUT -d"
  alias curl-post-file="curl -X POST -f"
  alias curl-fetch-header='curl -I'
  alias curl-fetch-header-check-compression='curl -I --compress'
fi

###############################################################################
# Enhanced Tools
###############################################################################
# Only create aliases when commands exist
command -v htop >/dev/null && alias top=htop
command -v bat >/dev/null && alias cat='bat'
command -v fd >/dev/null && alias fd='fd --hidden'
command -v yarn >/dev/null && alias y=yarn

# File listing enhancements
if command -v lsd >/dev/null 2>&1; then
  alias ls="lsd -tr1lh"
  alias ll='lsd --tree --group-directories-first -I "node_modules"'
elif command -v tree >/dev/null 2>&1; then
  alias ll="tree --dirsfirst -a -L 1 2>/dev/null || ls -la"
  alias tree='tree -I "node_modules"'
else
  alias ll="ls -la"
fi

# JSON formatting
if command -v jq >/dev/null; then
  alias formatJSON='jq .'
else
  alias formatJSON='python -m json.tool'
fi

###############################################################################
# AI & Development Tools
###############################################################################
# Ollama AI models
alias olrq='ollama run qwen2.5-coder:1.5b'
alias olsq='ollama stop qwen2.5-coder:1.5b'
alias olrn='ollama run nomic-embed-text:latest'
alias olsn='ollama stop nomic-embed-text:latest'

# Terminal tools
alias neomutt="TERM=xterm-direct neomutt"
alias tmux='direnv exec / tmux'
alias pp='xsel --clipboard --input'

###############################################################################
# Python Development
###############################################################################
# Virtual environment functions
python_venv_create() {
  [[ ! -d .venv ]] && python -m venv .venv
  source ./.venv/bin/activate
}

python_venv_deactivate() {
  command -v deactivate >/dev/null && deactivate
}

python_venv_remove() {
  python_venv_deactivate
  [[ -d .venv ]] && rm -rf .venv
}

python_pip_upgrade() {
  python -m pip --disable-pip-version-check list --outdated --format=json 2>/dev/null |
    jq -r ".[].name" 2>/dev/null |
    xargs -I{} python -m pip install --no-cache-dir -U "{}"
}

# Python aliases
alias cvenv='python_venv_create'
alias dvenv='python_venv_deactivate'
alias rvenv='python_venv_remove'
alias pip='python -m pip'
alias upip='python_pip_upgrade'
alias pyprofile='python -m cProfile -o profile'
alias pytest='python -m pytest'

###############################################################################
# macOS Specific
###############################################################################
if [[ "$(uname)" == Darwin* ]]; then
  # Application launchers
  alias zed='/Applications/Zed.app/Contents/MacOS/zed'
  alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
  alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'
  alias vsc='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'
  
  VSC_BIN='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin'
  PATH=$VSC_BIN:$PATH
  export PATH

  # VSCode launcher function
  codium() {
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args "$@"
  }
fi
