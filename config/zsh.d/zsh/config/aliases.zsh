# ======================
# cURL Related Aliases
# ======================
# Basic curl commands
alias curlh="curl -sILX GET"
alias curld="curl -A \"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36\""
alias curlm="curl -A \"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) CriOS/28.0.1500.12 Mobile/10B329 Safari/8536.25\""

# HTTP request methods
alias curl-get="curl -i -X GET"  # Include HTTP headers in output
alias curl-post="curl -X POST -d"  # POST request with JSON data and URL
alias curl-post-file="curl -X POST -f"  # File upload with file path and URL
alias curl-put="curl -X PUT -d"  # PUT request with JSON data and URL
alias curl-fetch-header='curl -I'  # Get server headers
alias curl-fetch-header-check-compression='curl -I --compress'  # Check server compression support

# ======================
# System Navigation & Operations
# ======================
alias c="clear"
alias e='$EDITOR --listen /tmp/nvim.pipe'
alias ec='nvim --cmd ":lua vim.g.noplugins=1"'
alias cask="brew --cask"
alias df="df -kh"
alias du="du -kh"
alias dt='du -sh * | sort -rh | awk '\''{sum+=$1; print} END {print "Total Size: " sum}'\'

# Directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias -- -="cd -"

# ======================
# Network & IP
# ======================
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias ip-en="ipconfig getifaddr en0"  # Ethernet
alias ip-lan="ipconfig getifaddr en1"  # Usually WiFi
alias ip-external="curl ifconfig.me"

# ======================
# Clipboard Operations
# ======================
alias pbunformat="pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy"
alias pb-tab-to-pace="pbpaste | expand | pbcopy"
alias pb-sort="pbpaste | sort | pbcopy"
alias pb-dedup="pbpaste | uniq | pbcopy"
alias pb-sort-dedup="pbpaste | sort | uniq | pbcopy"
alias pwdc="pwd | tr -d '\n' | pbcopy"

# ======================
# Development Tools
# ======================
# Ctags
alias ctags-make="ctags -R ."

# Haskell Stack
alias ghci="stack --silent ghci --ghci-options -v0"  # ghci without loading messages
alias gghci='stack ghci'  # Default ghci
alias ghc="ghci-color"  # Colored ghci

# Maven
alias mvnd="mvnDebug"  # Run Maven in debug mode
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

# Node
alias ns="npm start"
alias ni="npm install"
alias nl="npm list --depth=0"  # Show only top-level modules
alias nlg="npm list -g --depth=0"  # Show only global top-level modules
alias prettify="prettier --write"  # Format JS files with Prettier
alias nrd="npm run dev"
alias nrb="npm run build"
alias nu="npm uninstall"
alias nr="npm run"
alias nrp="npm run prisma:studio"

# ======================
# System Information
# ======================
alias mem-info='free -m -l -t'  # Memory info
alias ps-mem='ps -axf | sort -nr -k 4'  # Processes sorted by memory usage
alias ps-mem10='ps -axf | sort -nr -k 4 | head -10'
alias ps-cpu='ps -axf | sort -nr -k 3'  # Processes sorted by CPU usage
alias ps-cpu10='ps -axf | sort -nr -k 3 | head -10'
alias cpu-info='lscpu'  # CPU info

# ======================
# History
# ======================
alias h="history"  # Use first argument to specify history start index
alias ha="history 1"  # Show all history
alias hd="dirs -v"  # Show directory history in current shell session
alias hg='history 1 | grep'  # Search history with grep
alias hag='history 1 | ag'  # Search history with ag

# ======================
# Multimedia
# ======================
# YouTube downloads
alias yd="youtube-dl"
alias yd-movie="youtube-dl --ignore-errors --output '~/Movies/%(title)s.%(ext)s'"  # Download video
alias yd-music="youtube-dl --ignore-errors --extract-audio --audio-format mp3 --output '~/Library/Mobile Documents/com~apple~CloudDocs/Music/New Songs/%(title)s.%(ext)s'"  # Download audio as mp3

# Weather
alias weather="curl 'wttr.in/?0'"  # Current weather
alias weather-month='curl wttr.in'  # Show today, tomorrow and day after's weather
alias weather-help='curl wttr.in/:help'

# ======================
# macOS Specific
# ======================
# System maintenance
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"  # Flush DNS cache
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"  # Clean LaunchServices
alias dns-clear-local-cache="sudo killall -HUP mDNSResponder"
alias clear-dir-acls="sudo chmod -RN"  # Clear directory ACLs
alias restart-notification-center="killall NotificationCenter"
alias clear-asl-logs="sudo rm -rf /private/var/log/asl/*.asl"  # Clear system logs to speed up Terminal
alias sip-status="csrutil status"  # Show System Integrity Protection status

# Power management
alias power="pmset -g batt"
alias power-remaining="pmset -g ps  |  sed -n 's/.*[[:blank:]]+*\(.*%\).*/\1/p'"
alias power-settings='pmset -g'
alias shutdown="sudo shutdown -h now"
alias restart="sudo shutdown -r now"
alias sleep='pmset sleepnow'

# Finder operations
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias finder-utils"cd /System/Library/CoreServices/Finder.app/Contents/Applications/"
alias make-finder-alias='mkalias -c'  # Create Finder alias
alias hide='chflags hidden'  # Hide file/dir in Finder
alias unhide='chflags nohidden'  # Show file/dir in Finder

# Application management
alias apps-update-all="sudo softwareupdate -ia"
alias apps-update-ls="sudo softwareupdate -l"
alias macos-system-icons="open /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/"
alias quit-all="open ~/.dotfiles/config/macos/QuitAll.app"  # Quit all applications

# Miscellaneous
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume output volume 100'"
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"  # Kill Chrome tabs to free memory
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"  # Lock screen
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias screen-saver="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

# File operations
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"  # Recursively delete .DS_Store files
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
alias disks="diskutil list"  # List disks
alias net="netstat"  # Network status
alias apps="find /Applications -path '*Contents/_MASReceipt/receipt' -maxdepth 4 -print |\sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'"  # List installed apps
alias spotlight="mdfind kMDItemAppStoreHasReceipt=1"  # Find apps via Spotlight
alias plistbuddy="/usr/libexec/PlistBuddy"  # Plist tool
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'  # WiFi tool

# ======================
# Development Environment
# ======================
# JavaScriptCore REPL
jscbin="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc"
[ -e "${jscbin}" ] && alias jsc="${jscbin}"
unset jscbin

# HTTP methods
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "${method}"="lwp-request -m '${method}'"
done

# ======================
# Tool Enhancements
# ======================
# Check and replace default tools
command -v htop &>/dev/null && alias top=htop
command -v bat &>/dev/null && alias cat='bat '
command -v fd &>/dev/null && alias fd='fd --hidden '
command -v yarn &>/dev/null && alias y=yarn

# File listing
if command -v lsd &>/dev/null; then
  alias ls="lsd -tr1lh"
  alias ll='lsd --tree --group-directories-first -I "node_modules" '
elif command -v tree &>/dev/null; then
  alias ll="type tree >/dev/null && tree --dirsfirst -a -L 1 || l -d .*/ */ "
  alias tree='tree -I  "node_modules" '
else
  alias ll="echo 'You have to install lsd or tree'"
fi

# JSON formatting
if command -v jq &>/dev/null; then
  alias formatJSON='jq .'
else
  alias formatJSON='python -m json.tool'
fi

# Disk space
alias \
  dcap="df -h /" \
  sizeof="du -sh"

# Counting
alias count="ls -a | wc -l"

# Python
alias \
  cvenv='[ ! -d .venv ] && python -m venv .venv; . ./.venv/bin/activate' \
  dvenv='type deactivate >/dev/null && deactivate' \
  rvenv='type deactivate >/dev/null; deactivate; rm -rf .venv' \
  pip='python -m pip' \
  upip='pip --disable-pip-version-check list --outdated --format=json | jq -r ".[].name" | xargs -I{} pip install --no-cache-dir -U "{}"' \
  pyprofile='python -m cProfile -o profile' \
  pytest='python -m pytest'

# Network
alias \
  check-ciphers="nmap -sV --script ssl-enum-ciphers"

# Docker
alias \
  dpsi='docker ps --format="{{.Image}} -> {{.Names}}"'

# OS Specific
if [[ "$(uname)" == linux* ]]; then
  alias chmod='chmod --preserve-root -v'
  alias chown='chown --preserve-root -v'
fi

if [[ "$(uname)" == Darwin* ]]; then
  alias finder='open -a Finder ./'
  alias flushdns='sudo killall -HUP mDNSResponder'
  alias curl='curl --keepalive-time 60'
  alias zed='/Applications/Zed.app/Contents/MacOS/zed'
  alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
  alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'

  code() { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*; }
fi

# ======================
# Other Tools
# ======================
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf'
alias map="xargs -n1"
alias reload="exec ${SHELL} -l"
alias path='echo -e ${PATH//:/\\n}'
alias fd="fd --hidden "
alias fs="stat -f '%z bytes'"
alias history-stat="fc -l 1 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
alias history='fc -il 1'
alias jobs="jobs -l "
alias play='mx ϟ'
alias y="yarn"
alias p="pnpm"
alias npmlist="npm list --global --parseable --depth=0"
alias toolsup="echo $'Proto upgrade' ; proto upgrade ;"
alias gdcm="git diff HEAD | ask cm"
alias neomutt="TERM=xterm-direct neomutt"
alias tmux='direnv exec / tmux'
alias pp='xsel --clipboard --input'
alias reload='exec $SHELL -l'

# Ollama AI
alias olrq='ollama run qwen2.5-coder:1.5b'
alias olsq='ollama stop qwen2.5-coder:1.5b'
alias olrn='ollama run nomic-embed-text:latest'
alias olsn='ollama stop nomic-embed-text:latest'

# Zimfw update
alias zu="zimfw upgrade && zimfw update && echo 'zsh: updated Zim with: zmanage update'"
