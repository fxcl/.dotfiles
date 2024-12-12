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
# List all files in a directory, excluding hidden files and directories, in a sorted manner
alias listdir='find ${1:-.} -type f -not -path "*/.*/*" -print0 | xargs -0 -I {} bash -c '\''echo "$(dirname "{}")/$(basename "{}")"'\'' | sort -t/ -k2 -k3'

# List the size of all files in a directory, excluding hidden files and directories, in a sorted manner
alias dt='du -sh * | sort -rh | awk '\''{sum+=$1; print} END {print "Total Size: " sum}'\'

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
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "${method}"="lwp-request -m '${method}'"
done

alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

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
alias gs="git status"
alias gcm="git commit -m"
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
