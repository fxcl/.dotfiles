# curl
alias curlh="curl -sILX GET"
alias curld="curl -A \"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36\""
alias curlm="curl -A \"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) CriOS/28.0.1500.12 Mobile/10B329 Safari/8536.25\""

alias c="clear "
alias e='$EDITOR --listen /tmp/nvim.pipe'
alias ec='nvim --cmd ":lua vim.g.noplugins=1" ' #nvim --clean
alias cask="brew --cask "
alias df="df -kh"
alias du="du -kh"
# List the size of all files in a directory, excluding hidden files and directories, in a sorted manner
alias dt='du -sh * | sort -rh | awk '\''{sum+=$1; print} END {print "Total Size: " sum}'\'

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Detect which `ls` flavor is in use
# if ls --color >/dev/null 2>&1; then # GNU `ls`
#   colorflag="--color"
#   export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
# else # macOS `ls`
#   colorflag="-G"
#   export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
# fi

# # List all files colorized in long format
# alias l="ls -lF ${colorflag}"

# # List all files colorized in long format, excluding . and ..
# alias la="ls -lAF ${colorflag}"

# # List only directories
# alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# # Always use color output for `ls`
# alias ls="command ls ${colorflag}"

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
# alias grep='grep --color=auto'
# alias fgrep='fgrep --color=auto'
# alias egrep='egrep --color=auto'

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
#alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'

# List all files in a directory, excluding hidden files and directories, in a sorted manner
alias listdir='find ${1:-.} -type f -not -path "*/.*/*" -print0 | xargs -0 -I {} bash -c '\''echo "$(dirname "{}")/$(basename "{}")"'\'' | sort -t/ -k2 -k3'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

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

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Show active network interfaces
# alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Canonical hex dump; some systems have this symlinked
command -v hd >/dev/null || alias hd="hexdump -C"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum >/dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum >/dev/null || alias sha1sum="shasum"

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

for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "${method}"="lwp-request -m '${method}'"
done

alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

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

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Print each PATH entry on a separate line
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
alias reload='exec $SHELL -l'

# Ollama Ai
alias olrq='ollama run qwen2.5-coder:1.5b'
alias olsq='ollama stop qwen2.5-coder:1.5b'

alias olrn='ollama run nomic-embed-text:latest'
alias olsn='ollama stop nomic-embed-text:latest'

# Check for command availability
command -v htop &>/dev/null && alias top=htop
command -v bat &>/dev/null && alias cat='bat '
command -v fd &>/dev/null && alias fd='fd --hidden '
command -v yarn &>/dev/null && alias y=yarn

if command -v lsd &>/dev/null; then
  alias ls="lsd -tr1lh"
  alias ll='lsd --tree --group-directories-first -I "node_modules" '
elif command -v tree &>/dev/null; then
  alias ll="type tree >/dev/null && tree --dirsfirst -a -L 1 || l -d .*/ */ "
  alias tree='tree -I  "node_modules" '
else
  alias ll="echo 'You have to install lsd or tree'"
fi

if command -v jq &>/dev/null; then
  alias formatJSON='jq .'
else
  alias formatJSON='python -m json.tool'
fi

# check size
alias \
  dcap="df -h /" \
  sizeof="du -sh"

# counting folders and files
alias count="ls -a | wc -l"

# python aliases
alias \
  cvenv='[ ! -d .venv ] && python -m venv .venv; . ./.venv/bin/activate' \
  dvenv='type deactivate >/dev/null && deactivate' \
  rvenv='type deactivate >/dev/null; deactivate; rm -rf .venv' \
  pip='python -m pip' \
  upip='pip --disable-pip-version-check list --outdated --format=json | jq -r ".[].name" | xargs -I{} pip install --no-cache-dir -U "{}"' \
  pyprofile='python -m cProfile -o profile' \
  pytest='python -m pytest'

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

if [[ "$(uname)" == Darwin* ]]; then
  alias finder='open -a Finder ./'
  alias flushdns='sudo killall -HUP mDNSResponder'
  alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
  alias curl='curl --keepalive-time 60'
  alias zed='/Applications/Zed.app/Contents/MacOS/zed'
  alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
  alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary'

  # emacs-mac
  # brew tap railwaycat/emacsmacport
  # brew install emacs-mac
  # brew untap railwaycat/emacsmacport
  #alias emacs='/usr/local/opt/emacs-mac/Emacs.app/Contents/MacOS/Emacs --no-splash'
  # emacs standard
  # brew install emacs --with-cocoa
  # alias emacs='/usr/local/opt/emacs/Emacs.app/Contents/MacOS/Emacs --no-splash --fullscreen'
  # emacs cask
  # brew install --cask emacs
  # installed in /Applications but linked as /usr/local/bin/emacs
  # also could work with:
  # alias emacs='open -a Emacs' but with errors taking arguments :\

  # alias j17="export JAVA_HOME=`/usr/libexec/java_home -v 17`; java -version"
  # alias j11="export JAVA_HOME=`/usr/libexec/java_home -v 11.0.15`; java -version"
  # alias j8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"

  # Turn the prompt symbol red if the user is root
  # if [ $( id -u ) -eq 0 ];
  # then # you are root, make the prompt red
  #  export PS1='\[\e[1;31m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
  # else
  #  export PS1='\[\e[1;32m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
  # fi
fi
