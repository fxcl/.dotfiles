#!/bin/zsh

#------------------------------------------------------------------------------
# GENERAL ALIASES
#------------------------------------------------------------------------------
# Basic command shortcuts
alias c="clear"                                                                          # Clear terminal screen
alias e='$EDITOR --listen /tmp/nvim.pipe'                                                # Open editor with socket
alias ec='nvim --cmd ":lua vim.g.noplugins=1"'                                           # Open nvim without plugins
alias df="df -kh"                                                                        # Disk free with human-readable sizes
alias du="du -kh"                                                                        # Disk usage with human-readable sizes
alias dt='du -sh * | sort -rh | awk "{sum+=$1; print} END {print \"Total Size: \" sum}"' # Directory sizes sorted

#------------------------------------------------------------------------------
# NAVIGATION SHORTCUTS
#------------------------------------------------------------------------------
alias ..="cd .."             # Go up one directory
alias ...="cd ../.."         # Go up two directories
alias ....="cd ../../.."     # Go up three directories
alias .....="cd ../../../.." # Go up four directories
alias ~="cd ~"               # Go to home directory
alias -- -="cd -"            # Go to previous directory

#------------------------------------------------------------------------------
# FILE LISTING & MANAGEMENT
#------------------------------------------------------------------------------
# List all files excluding hidden ones, sorted
alias listdir='find ${1:-.} -type f -not -path "*/.*/*" -print0 | xargs -0 -I {} bash -c "echo \"$(dirname \"{}\")\"$(basename \"{}\")\"" | sort -t/ -k2 -k3'

# Cross-platform fallbacks - optimized conditional loading
command -v hd >/dev/null || alias hd="hexdump -C"
command -v md5sum >/dev/null || alias md5sum="md5"
command -v sha1sum >/dev/null || alias sha1sum="shasum"

#------------------------------------------------------------------------------
# DOWNLOAD UTILITIES
#------------------------------------------------------------------------------
# Smart downloader that uses the fastest available tool
if command -v aria2c >/dev/null; then
  alias get='aria2c --max-connection-per-server=5 --continue'
elif command -v axel >/dev/null; then
  alias get='axel --num-connections=5 --alternate'
elif command -v wget >/dev/null; then
  alias get='wget --continue --progress=bar --timestamping'
elif command -v curl >/dev/null; then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
fi

#------------------------------------------------------------------------------
# CURL & HTTP SHORTCUTS
#------------------------------------------------------------------------------
# Basic curl with different options
alias curlh="curl -sILX GET" # Silent mode with headers

# User agent variations
alias curld="curl -A \"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36\""                                      # Desktop
alias curlm="curl -A \"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) CriOS/28.0.1500.12 Mobile/10B329 Safari/8536.25\"" # Mobile

# HTTP method shortcuts
alias curl-get="curl -i -X GET"                                # GET with headers
alias curl-post="curl -X POST -d"                              # POST with data
alias curl-put="curl -X PUT -d"                                # PUT with data
alias curl-post-file="curl -X POST -f"                         # POST with file
alias curl-fetch-header='curl -I'                              # Headers only
alias curl-fetch-header-check-compression='curl -I --compress' # Check compression

#------------------------------------------------------------------------------
# NETWORK UTILITIES
#------------------------------------------------------------------------------
# IP address information
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"                                                                                                  # Public IP
alias localip="ipconfig getifaddr en0"                                                                                                                         # Local IP (en0 interface)
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'" # All IPs
alias ip-en="ipconfig getifaddr en0"                                                                                                                           # Ethernet/WiFi IP
alias ip-lan="ipconfig getifaddr en1"                                                                                                                          # Usually WiFi IP
alias ip-external="curl ifconfig.me"                                                                                                                           # External IP via web service

# DNS and cache management
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder" # Flush DNS cache
alias dns-clear-local-cache="sudo killall -HUP mDNSResponder"       # Clear local DNS cache

#------------------------------------------------------------------------------
# CLIPBOARD UTILITIES
#------------------------------------------------------------------------------
alias pbunformat="pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy" # Remove formatting
alias pb-tab-to-pace="pbpaste | expand | pbcopy"                                        # Convert tabs to spaces
alias pb-sort="pbpaste | sort | pbcopy"                                                 # Sort clipboard content
alias pb-dedup="pbpaste | uniq | pbcopy"                                                # Remove duplicates
alias pb-sort-dedup="pbpaste | sort | uniq | pbcopy"                                    # Sort and deduplicate
alias pwdc="pwd | tr -d '\n' | pbcopy"                                                  # Copy current directory path

#------------------------------------------------------------------------------
# DEVELOPMENT TOOLS
#------------------------------------------------------------------------------
# Homebrew
alias cask="brew --cask" # Homebrew cask shortcut

# Ctags
alias ctags-make="ctags -R ." # Generate tags recursively

# Haskell
alias ghci="stack --silent ghci --ghci-options -v0" # Silent GHCI
alias gghci='stack ghci'                            # Default GHCI
alias ghc="ghci-color"                              # Colored GHCI

# Maven
alias mvnd="mvnDebug" # Maven debug mode
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
alias cdo='cargo doc --open'
alias cgt='cargo test'
alias cgb='cargo build'
alias cgc='cargo check'

# Node.js/NPM
alias ns="npm start"
alias ni="npm install"
alias nl="npm list --depth=0"
alias nlg="npm list -g --depth=0"
alias prettify="prettier --write"
alias nr="npm run"
alias nu="npm uninstall"
alias nrd="npm run dev"
alias nrb="npm run build"

#------------------------------------------------------------------------------
# JAVASCRIPT TOOLS
#------------------------------------------------------------------------------
# JavaScriptCore REPL
jscbin="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc"
[ -e "${jscbin}" ] && alias jsc="${jscbin}"
unset jscbin

#------------------------------------------------------------------------------
# MACOS SYSTEM UTILITIES
#------------------------------------------------------------------------------
# File management
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"                                                                                                                                                                  # Remove .DS_Store files
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'" # Empty trash and logs

# Finder controls
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"     # Show hidden files
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"    # Hide hidden files
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder" # Hide desktop icons
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"  # Show desktop icons

# Spotlight controls
alias spotoff="sudo mdutil -a -i off" # Disable Spotlight
alias spoton="sudo mdutil -a -i on"   # Enable Spotlight

# System tools
alias plistbuddy="/usr/libexec/PlistBuddy"                                                                # PList editor
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport' # Airport utility
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"     # Lock screen
alias reload="exec ${SHELL} -l"                                                                           # Reload shell
alias path='echo -e ${PATH//:/\\n}'                                                                       # Print PATH entries

# Audio controls
alias stfu="osascript -e 'set volume output muted true'"     # Mute sound
alias pumpitup="osascript -e 'set volume output volume 100'" # Max volume

# Browser management
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill" # Kill Chrome tabs

#------------------------------------------------------------------------------
# FILE & TEXT PROCESSING
#------------------------------------------------------------------------------
# Text processing
alias c="tr -d '\n' | pbcopy"                                                             # Trim newlines and copy
alias map="xargs -n1"                                                                     # Map function
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"' # URL encode

# PDF tools
alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf' # Merge PDFs

# File stats
alias fs="stat -f '%z bytes'" # File size
alias sizeof="du -sh"         # Directory size
alias dcap="df -h /"          # Disk capacity
alias count="ls -a | wc -l"   # Count files

#------------------------------------------------------------------------------
# SHELL & HISTORY
#------------------------------------------------------------------------------
# History management
alias history='fc -il 1'                                                              # Show history
alias history-stat="fc -l 1 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head" # History stats
alias jobs="jobs -l"                                                                  # List jobs

#------------------------------------------------------------------------------
# ENHANCED TOOLS (CONDITIONAL)
#------------------------------------------------------------------------------
# Only create aliases when commands exist - optimized checks
command -v htop >/dev/null && alias top=htop
command -v bat >/dev/null && alias cat='bat'
command -v fd >/dev/null && alias fd='fd --hidden'
command -v yarn >/dev/null && alias y=yarn

# File listing enhancements
if command -v lsd >/dev/null 2>&1; then
  alias ls="lsd -tr1lh"                                             # Enhanced ls with LSD
  alias ll='lsd --tree --group-directories-first -I "node_modules"' # Tree view
elif command -v tree >/dev/null 2>&1; then
  alias ll="tree --dirsfirst -a -L 1 2>/dev/null || ls -la" # Tree fallback
  alias tree='tree -I "node_modules"'                       # Ignore node_modules
else
  alias ll="ls -la" # Standard fallback
fi

# JSON formatting - optimized conditional
if command -v jq >/dev/null; then
  alias formatJSON='jq .'
else
  alias formatJSON='python -m json.tool'
fi

#------------------------------------------------------------------------------
# PACKAGE MANAGEMENT
#------------------------------------------------------------------------------
# Node.js package managers
alias y="yarn"                                          # Yarn
alias p="pnpm"                                          # PNPM
alias npmlist="npm list --global --parseable --depth=0" # List global packages

# Additional npm shortcuts
alias nrp="npm run prisma:studio"                       # Run Prisma studio
alias toolsup="echo $'Proto upgrade' ; proto upgrade ;" # Upgrade tools

#------------------------------------------------------------------------------
# AI & DEVELOPMENT TOOLS
#------------------------------------------------------------------------------
# Ollama AI models
alias olrq='ollama run qwen2.5-coder:1.5b'       # Run Qwen coder model
alias olsq='ollama stop qwen2.5-coder:1.5b'      # Stop Qwen coder model
alias olrn='ollama run nomic-embed-text:latest'  # Run Nomic embedding model
alias olsn='ollama stop nomic-embed-text:latest' # Stop Nomic embedding model

# Git tools
alias gdcm="git diff HEAD | ask cm" # Git diff with AI

# Terminal tools
alias neomutt="TERM=xterm-direct neomutt" # Fix for neomutt
alias tmux='direnv exec / tmux'           # Fix for tmux with direnv
alias pp='xsel --clipboard --input'       # Clipboard input

#------------------------------------------------------------------------------
# PYTHON DEVELOPMENT
#------------------------------------------------------------------------------
# Virtual environment functions - optimized for performance
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
alias cvenv='python_venv_create'                # Create virtual env
alias dvenv='python_venv_deactivate'            # Deactivate virtual env
alias rvenv='python_venv_remove'                # Remove virtual env
alias pip='python -m pip'                       # Use module pip
alias upip='python_pip_upgrade'                 # Upgrade pip packages
alias pyprofile='python -m cProfile -o profile' # Profile Python code
alias pytest='python -m pytest'                 # Run pytest

#------------------------------------------------------------------------------
# NETWORK & DOCKER
#------------------------------------------------------------------------------
# Network tools
alias check-ciphers="nmap -sV --script ssl-enum-ciphers" # Check SSL ciphers

# Docker commands
alias dpsi='docker ps --format="{{.Image}} -> {{.Names}}"' # Docker PS with formatting

if [[ "$(uname)" == linux* ]]; then
  alias chmod='chmod --preserve-root -v'
  alias chown='chown --preserve-root -v'
fi

# macOS specific aliases and functions
# Only load these on macOS systems
if [[ "$(uname)" == Darwin* ]]; then
  # File and application shortcuts
  alias finder='open -a Finder ./'                 # Open current directory in Finder
  alias flushdns='sudo killall -HUP mDNSResponder' # Clear DNS cache
  alias curl='curl --keepalive-time 60'            # Curl with keepalive

  # Application launchers
  alias zed='/Applications/Zed.app/Contents/MacOS/zed'                                          # Launch Zed editor
  alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'                 # Launch Chrome
  alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary' # Launch Chrome Canary

  # VSCode launcher function with proper working directory
  code() {
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args "$@"
  }

  # Removed commented out aliases and configurations to improve loading speed
fi
