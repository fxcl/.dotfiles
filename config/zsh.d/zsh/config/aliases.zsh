# CURL - HTTP request shortcuts
# Optimized curl aliases for different user agents and HTTP methods
# Basic curl shortcuts with different user agents
alias curlh="curl -sILX GET"                                                                                                                                             # Silent mode with headers
alias curld="curl -A \"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36\""                                      # Desktop user agent
alias curlm="curl -A \"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) CriOS/28.0.1500.12 Mobile/10B329 Safari/8536.25\"" # Mobile user agent

# HTTP method shortcuts
alias curl-get="curl -i -X GET"                                # Include headers in output
alias curl-post="curl -X POST -d"                              # POST with data payload
alias curl-post-file="curl -X POST -f"                         # POST with file upload
alias curl-put="curl -X PUT -d"                                # PUT with data payload
alias curl-fetch-header='curl -I'                              # Get headers only
alias curl-fetch-header-check-compression='curl -I --compress' # Check compression support

alias c="clear "
alias e='$EDITOR --listen /tmp/nvim.pipe'
alias ec='nvim --cmd ":lua vim.g.noplugins=1" ' #nvim --clean
alias cask="brew --cask "
alias df="df -kh"
alias du="du -kh"
# List the size of all files in a directory, excluding hidden files and directories, in a sorted manner
alias dt='du -sh * | sort -rh | awk '\''{sum+=$1; print} END {print "Total Size: " sum}'\'

# Directory navigation shortcuts
# Quick directory traversal aliases
alias ..="cd .."             # Go up one directory
alias ...="cd ../.."         # Go up two directories
alias ....="cd ../../.."     # Go up three directories
alias .....="cd ../../../.." # Go up four directories
alias ~="cd ~"               # Go to home directory
alias -- -="cd -"            # Go to previous directory

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
#alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'

# List all files in a directory, excluding hidden files and directories, in a sorted manner
alias listdir='find ${1:-.} -type f -not -path "*/.*/*" -print0 | xargs -0 -I {} bash -c '\''echo "$(dirname "{}")/$(basename "{}")"'\'' | sort -t/ -k2 -k3'

# Network utilities
# IP address information shortcuts
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"                                                                                                  # Get public IP address
alias localip="ipconfig getifaddr en0"                                                                                                                         # Get local IP address (en0 interface)
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'" # List all IP addresses

# Clipboard utilities
# Clipboard manipulation shortcuts for text processing
alias pbunformat="pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy" # Remove formatting from clipboard text
alias pb-tab-to-pace="pbpaste | expand | pbcopy"                                        # Convert tabs to spaces in clipboard
alias pb-sort="pbpaste | sort | pbcopy"                                                 # Sort clipboard content
alias pb-dedup="pbpaste | uniq | pbcopy"                                                # Remove duplicate lines from clipboard
alias pb-sort-dedup="pbpaste | sort | uniq | pbcopy"                                    # Sort and remove duplicates from clipboard
alias pwdc="pwd | tr -d '\n' | pbcopy"                                                  # Copy current directory path to clipboard

# Ctags
alias ctags-make="ctags -R ." # creates tags using universal-ctags from brew

# Stack for Haskell
alias ghci="stack --silent ghci --ghci-options -v0" # ghci without loading messages
alias gghci='stack ghci'                            # default ghci
alias ghc="ghci-color"                              # ghci-color in ~/.dotfiles/bin, NOTE: do not alias to 'ghci', causes Haskell prompt to halt when printing specific values (ex. [":)"])
# alias sb='stack build' # Stack build

# Maven
alias mvnd="mvnDebug" # runs Maven in debug mode (allows remote debugger to attach at port 8000)
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

# Node.js development aliases
# NPM shortcuts for common operations
alias ns="npm start"              # Start npm script
alias ni="npm install"            # Install dependencies
alias nl="npm list --depth=0"     # List only top-level modules
alias nlg="npm list -g --depth=0" # List only top-level global modules
alias prettify="prettier --write" # Format code with Prettier
alias nr="npm run"                # Run npm script
alias nu="npm uninstall"          # Uninstall package
alias nrd="npm run dev"           # Run development server
alias nrb="npm run build"         # Build project

# System info
alias mem-info='free -m -l -t'         # pass options to free
alias ps-mem='ps -axf | sort -nr -k 4' # get top process by memory usage
alias ps-mem10='ps -axf | sort -nr -k 4 | head -10'
alias ps-cpu='ps -axf | sort -nr -k 3' # get top process by cpu usage
alias ps-cpu10='ps -axf | sort -nr -k 3 | head -10'
alias cpu-info='lscpu' # get server cpu info

# History
alias h="history"    # use 1st arg to specify starting index of history
alias ha="history 1" # show all history (1 is the index of first history)
alias hd="dirs -v"   # show history of directories visited in current shell session
# alias htop='history | sort -rn | head' # TODO: realias and reenable
alias hg='history 1 | grep' # search for string in history with grep
alias hag='history 1 | ag'  # search for string in history with ag

# Youtube
alias yd="youtube-dl"
alias yd-movie="youtube-dl --ignore-errors --output '~/Movies/%(title)s.%(ext)s'"                                                                                          # download video with audio-format defaulted to best, skip unavailable songs when downloading a playlist
alias yd-music="youtube-dl --ignore-errors --extract-audio --audio-format mp3 --output '~/Library/Mobile Documents/com~apple~CloudDocs/Music/New Songs/%(title)s.%(ext)s'" # download audio as mp3 format, skip unavailable videos when downloading a playlist

# TODO: add aliases/functions to control AirDrop

# Weather
alias weather="curl 'wttr.in/?0'"  # show current weather
alias weather-month='curl wttr.in' # shows today, tomorrow, and day-after's weather
alias weather-help='curl wttr.in/:help'

# Show active network interfaces
# alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Cross-platform command fallbacks
# Set up fallbacks for commands that might not exist on all systems
{ command -v hd >/dev/null || alias hd="hexdump -C"; } 2>/dev/null       # Canonical hex dump fallback
{ command -v md5sum >/dev/null || alias md5sum="md5"; } 2>/dev/null      # md5sum fallback for macOS
{ command -v sha1sum >/dev/null || alias sha1sum="shasum"; } 2>/dev/null # sha1sum fallback for macOS

# macOS
# TODO: verify if 'make-finder-alias' creates Finder Alias that's compatible with iTunes
alias top-cpu='top -o cpu'   # sort by cpu
alias top-mem='top -o rsize' # sort by memory
alias getmod="stat -f %A"    # prints the permission of $1 in octal
alias finder-utils"cd /System/Library/CoreServices/Finder.app/Contents/Applications/"
alias make-finder-alias='mkalias -c' # -c omit copying source file's icon to target alias, requires 'osxutils' from Brew, creates a macOS Finder Alias (similar, but not same as soft/hard symlinks)
alias hide='chflags hidden'          # make file/dir invisible in Finder (still visible in shell)
alias unhide='chflags nohidden'      # make file/dir visible in Finder (still visible in shell)
alias sudo-='sudo $SHELL -c "$(fc -ln -1)"'
alias quit-all="open ~/.dotfiles/config/macos/QuitAll.app" # quits all active applications
alias paths-env='env | grep PATH'
alias battery-settings='pmset -g'
alias dns-clear-local-cache="sudo killall -HUP mDNSResponder"
alias clear-dir-acls="sudo chmod -RN" # clear ACLs for passed in path to folder
alias ip-en="ipconfig getifaddr en0"  # wifi (en1) or ethernet (en0), use en0 if not wired connection
alias ip-lan="ipconfig getifaddr en1" # usually wifi
alias ip-external="curl ifconfig.me"
alias password-generate-secure-to-clipboard="LC_ALL=C tr -dc \"[:alpha:][:alnum:]\" < /dev/urandom | head -c 20 | pbcopy"
alias shutdown="sudo shutdown -h now"
alias restart="sudo shutdown -r now"
alias sip-status="csrutil status" # show System Integrity Protection status
alias restart-notification-center="killall NotificationCenter"
alias clear-asl-logs="sudo rm -rf /private/var/log/asl/*.asl" # clear Apple System Logs to speed up Terminal
alias disks="diskutil list"
alias net="netstat"
alias apps="find /Applications -path '*Contents/_MASReceipt/receipt' -maxdepth 4 -print |\sed 's#.app/Contents/_MASReceipt/receipt#.app#g; s#/Applications/##'" # via find
alias spotlight="mdfind kMDItemAppStoreHasReceipt=1"                                                                                                            # via Spotlight
alias plistbuddy="/usr/libexec/PlistBuddy"
alias reload="exec $SHELL -l" # Reload the shell (i.e. invoke as a login shell)
alias power="pmset -g batt"
alias power-remaining="pmset -g ps  |  sed -n 's/.*[[:blank:]]+*\(.*%\).*/\1/p'"
alias power-settings='pmset -g'
alias mute="osascript -e 'set volume output muted true'"
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias screen-saver="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"
alias cpu='top -F -R -o cpu'
alias sleep='pmset sleepnow'
alias airdrop-enable-all="defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true"
alias airdrop-enable="defaults remove com.apple.NetworkBrowser DisableAirDrop"
alias airdrop-disable="defaults write com.apple.NetworkBrowser DisableAirDrop -bool YES"
alias apps-update-all="sudo softwareupdate -ia"
alias apps-update-ls="sudo softwareupdate -l"
alias macos-system-icons="open /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/" # NOTE: .icns in here must be copied to another folder and chmod to 777 to be usable as folder icons

# JavaScriptCore REPL
jscbin="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc"
[ -e "${jscbin}" ] && alias jsc="${jscbin}"
unset jscbin

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# HTTP method shortcuts using lwp-request
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "${method}"="lwp-request -m '${method}'"
done

alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Merge PDF files, preserving hyperlinks
# Usage: `mergepdf input{1,2,3}.pdf`
alias mergepdf='gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf'

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Airport CLI alias
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "${method}"="lwp-request -m '${method}'"
done

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume output volume 100'"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Shell and environment utilities
alias reload="exec ${SHELL} -l"     # Reload the shell as a login shell
alias path='echo -e ${PATH//:/\\n}' # Print each PATH entry on a separate line

alias fd="fd --hidden "
alias fs="stat -f '%z bytes'"
alias history-stat="fc -l 1 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
alias history='fc -il 1'
alias jobs="jobs -l "
alias play='mx ϟ'
alias y="yarn"
alias p="pnpm"
alias npmlist="npm list --global --parseable --depth=0"
alias nrd="npm run dev"
alias nrb="npm run build"
alias ni="npm install"
alias nu="npm uninstall"
alias nr="npm run"
alias nrp="npm run prisma:studio"
alias toolsup="echo $'Proto upgrade' ; proto upgrade ;"
alias gdcm="git diff HEAD | ask cm"

# https://github.com/neomutt/neomutt/issues/4058#issuecomment-1751682305
alias neomutt="TERM=xterm-direct neomutt"
# https://github.com/direnv/direnv/wiki/Tmux
alias tmux='direnv exec / tmux'

alias pp='xsel --clipboard --input'

# Ollama AI model management
alias olrq='ollama run qwen2.5-coder:1.5b'       # Run Qwen coder model
alias olsq='ollama stop qwen2.5-coder:1.5b'      # Stop Qwen coder model
alias olrn='ollama run nomic-embed-text:latest'  # Run Nomic embedding model
alias olsn='ollama stop nomic-embed-text:latest' # Stop Nomic embedding model

# Conditional aliases based on command availability
# Efficiently set up aliases only when commands are available

# Enhanced tools - apply only when available
(command -v htop >/dev/null && alias top=htop) || true
(command -v bat >/dev/null && alias cat='bat') || true
(command -v fd >/dev/null && alias fd='fd --hidden') || true
(command -v yarn >/dev/null && alias y=yarn) || true

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
(command -v jq >/dev/null && alias formatJSON='jq .') || alias formatJSON='python -m json.tool'

# check size
alias \
  dcap="df -h /" \
  sizeof="du -sh"

# counting folders and files
alias count="ls -a | wc -l"

# Python development utilities
# Virtual environment management and Python tools

# Convert complex aliases to functions for better performance
python_venv_create() {
  [ ! -d .venv ] && python -m venv .venv
  . ./.venv/bin/activate
}

python_venv_deactivate() {
  type deactivate >/dev/null && deactivate
}

python_venv_remove() {
  python_venv_deactivate
  [ -d .venv ] && rm -rf .venv
}

python_pip_upgrade() {
  python -m pip --disable-pip-version-check list --outdated --format=json |
    jq -r ".[].name" 2>/dev/null |
    xargs -I{} python -m pip install --no-cache-dir -U "{}"
}

# Set up aliases to the functions
alias cvenv='python_venv_create'
alias dvenv='python_venv_deactivate'
alias rvenv='python_venv_remove'
alias pip='python -m pip'
alias upip='python_pip_upgrade'
alias pyprofile='python -m cProfile -o profile'
alias pytest='python -m pytest'

# network
alias \
  check-ciphers="nmap -sV --script ssl-enum-ciphers"

## commands
alias \
  dpsi='docker ps --format="{{.Image}} -> {{.Names}}"'

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
