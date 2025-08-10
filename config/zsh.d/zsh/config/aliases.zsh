#!/bin/zsh

# Early return for non-interactive sessions
[[ ! -o interactive ]] && return 0

###############################################################################
# Core Aliases - Loaded Immediately
###############################################################################
# Basic command shortcuts
alias c="clear"                                                                          # Clears the terminal screen.
alias e='$EDITOR --listen /tmp/nvim.pipe'                                                # Opens the editor with a socket for external communication.
alias ec='nvim --cmd ":lua vim.g.noplugins=1"'                                           # Opens Neovim without loading plugins.
alias df="df -kh"                                                                        # Displays disk free space in human-readable format.
alias du="du -kh"                                                                        # Displays disk usage in human-readable format.
alias dt='du -sh * | sort -rh | awk "{sum+=$1; print} END {print \"Total Size: \" sum}"' # Lists directory sizes, sorted by size, and shows total.

# Navigation Shortcuts
alias ..="cd .."             # Navigates up one directory.
alias ...="cd ../.."         # Navigates up two directories.
alias ....="cd ../../.."     # Navigates up three directories.
alias .....="cd ../../../.." # Navigates up four directories.
alias ~="cd ~"               # Navigates to the home directory.
alias -- -="cd -"            # Navigates to the previous directory.

# Cross-platform Fallbacks
# Provides aliases for common commands that might have different names across platforms.
command -v hd >/dev/null || alias hd="hexdump -C"       # Hexdump utility.
command -v md5sum >/dev/null || alias md5sum="md5"      # MD5 checksum utility.
command -v sha1sum >/dev/null || alias sha1sum="shasum" # SHA1 checksum utility.

# Essential File Operations
alias ls="ls -G"   # Lists files with colored output.
alias l="ls -lah"  # Lists files in long format, including hidden files.
alias ll="ls -lh"  # Lists files in long format.
alias la="ls -lAh" # Lists files in long format, including almost all hidden files.

_setup_development_aliases() {
  # Homebrew
  alias cask="brew --cask" # Manages Homebrew Casks.

  # Node.js/NPM Aliases
  alias ns="npm start"              # Starts the application.
  alias ni="npm install"            # Installs Node.js dependencies.
  alias nl="npm list --depth=0"     # Lists installed npm packages with no depth.
  alias nlg="npm list -g --depth=0" # Lists globally installed npm packages with no depth.
  alias nr="npm run"                # Executes an npm script.
  alias nrd="npm run dev"           # Runs the development script.
  alias nrb="npm run build"         # Runs the build script.
  alias nu="npm uninstall"          # Uninstalls npm packages.
  alias nrp="npm run prisma:studio" # Runs Prisma Studio.
  alias prettify="prettier --write" # Formats code using Prettier.

  # Git Shortcuts
  alias g="git"                       # Alias for the git command.
  alias gs="git status"               # Shows the working tree status.
  alias ga="git add"                  # Adds file contents to the index.
  alias gc="git commit"               # Records changes to the repository.
  alias gp="git push"                 # Updates remote refs along with associated objects.
  alias gl="git pull"                 # Fetches from and integrates with another repository or a local branch.
  alias gd="git diff"                 # Shows changes between commits, commit and working tree, etc.
  alias gco="git checkout"            # Switches branches or restores working tree files.
  alias gdcm="git diff HEAD | ask cm" # Shows diff from HEAD and pipes to 'ask cm'.
  alias lg="lazygit"                  # Opens lazygit.

  # Maven Aliases
  alias mvnd="mvnDebug"                      # Runs Maven in debug mode.
  alias mci="mvn clean install"              # Cleans and installs Maven project.
  alias mcid="mvn clean install -DskipTests" # Cleans and installs Maven project, skipping tests.
  alias mcp="mvn clean package"              # Cleans and packages Maven project.
  alias mcv="mvn clean verify"               # Cleans and verifies Maven project.
  alias mct="mvn clean test"                 # Cleans and runs tests for Maven project.
  alias mvn-ls-deps="mvn dependency:tree"    # Displays the dependency tree for a Maven project.
  alias run-spring="mvn spring-boot:run"     # Runs a Spring Boot application.

  # Gradle Aliases
  alias gw='./gradlew' # Alias for the Gradle wrapper.
  alias gwr='gw run'   # Runs the Gradle project.
  alias gwi='gw idea'  # Generates IntelliJ IDEA project files.

  # Rust Aliases
  alias cgr='cargo run'        # Runs a Rust binary or example.
  alias cgt='cargo test'       # Runs Rust tests.
  alias cgb='cargo build'      # Compiles the current Rust package.
  alias cgc='cargo check'      # Checks the current Rust package for errors.
  alias cdo='cargo doc --open' # Builds and opens the package's documentation.
}

_setup_system_tool_aliases() {
  # File management
  alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"                                                                                                                                                                  # Removes all .DS_Store files recursively.
  alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'" # Empties trash and clears quarantine events.

  # Finder Controls
  alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"     # Shows all hidden files in Finder.
  alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"    # Hides all hidden files in Finder.
  alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder" # Hides desktop icons.
  alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"  # Shows desktop icons.

  # Spotlight Controls
  alias spotoff="sudo mdutil -a -i off" # Disables Spotlight indexing for all volumes.
  alias spoton="sudo mdutil -a -i on"   # Enables Spotlight indexing for all volumes.

  # System Utilities
  alias reload="exec ${SHELL} -l"                                                                           # Reloads the current shell.
  alias path='echo -e ${PATH//:/\\n}'                                                                       # Displays the PATH variable with each entry on a new line.
  alias plistbuddy="/usr/libexec/PlistBuddy"                                                                # Alias for PlistBuddy.
  alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport' # Alias for the airport utility.
  alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"     # Locks the screen.

  # Audio Controls
  alias stfu="osascript -e 'set volume output muted true'"     # Mutes the system volume.
  alias pumpitup="osascript -e 'set volume output volume 100'" # Sets the system volume to 100%.

  # Browser Management
  alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill" # Kills all Chrome Helper renderer processes.

  # Clipboard Utilities
  alias pbunformat="pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy" # Pastes clipboard content as unformatted text.
  alias pb-tab-to-pace="pbpaste | expand | pbcopy"                                        # Converts tabs to spaces in clipboard content.
  alias pb-sort="pbpaste | sort | pbcopy"                                                 # Sorts lines in clipboard content.
  alias pb-dedup="pbpaste | uniq | pbcopy"                                                # Removes duplicate lines from clipboard content.
  alias pb-sort-dedup="pbpaste | sort | uniq | pbcopy"                                    # Sorts and removes duplicate lines from clipboard content.
  alias pwdc="pwd | tr -d '\n' | pbcopy"                                                  # Copies the current working directory to the clipboard.
}

_setup_network_aliases() {
  # IP address information
  alias ip="dig +short myip.opendns.com @resolver1.opendns.com"                                                                                                  # Displays external IP address.
  alias localip="ipconfig getifaddr en0"                                                                                                                         # Displays local IP address for en0.
  alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'" # Lists all IP addresses.
  alias ip-en="ipconfig getifaddr en0"                                                                                                                           # Displays local IP address for en0.
  alias ip-lan="ipconfig getifaddr en1"                                                                                                                          # Displays local IP address for en1.
  alias ip-external="curl ifconfig.me"                                                                                                                           # Displays external IP address using curl.

  # DNS and Cache Management
  alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder" # Flushes DNS cache.
  alias dns-clear-local-cache="sudo killall -HUP mDNSResponder"       # Clears local DNS cache.

  # Curl Shortcuts
  if command -v curl >/dev/null; then
    alias curlh="curl -sILX GET"                                                                                                                                             # Performs a silent, include headers, location, GET request.
    alias curld="curl -A \"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36\""                                      # Performs curl request with a desktop user agent.
    alias curlm="curl -A \"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_3 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) CriOS/28.0.1500.12 Mobile/10B329 Safari/8536.25\"" # Performs curl request with a mobile user agent.
    alias curl-get="curl -i -X GET"                                                                                                                                          # Performs an HTTP GET request with headers.
    alias curl-post="curl -X POST -d"                                                                                                                                        # Performs an HTTP POST request with data.
    alias curl-put="curl -X PUT -d"                                                                                                                                          # Performs an HTTP PUT request with data.
    alias curl-post-file="curl -X POST -f"                                                                                                                                   # Performs an HTTP POST request with file upload.
    alias curl-fetch-header='curl -I'                                                                                                                                        # Fetches only the HTTP header.
    alias curl-fetch-header-check-compression='curl -I --compress'                                                                                                           # Fetches HTTP header and checks for compression.
  fi
}

_setup_enhanced_tool_aliases() {
  # Only create aliases when commands exist
  command -v htop >/dev/null && alias top=htop       # Uses htop if available, otherwise falls back to top.
  command -v bat >/dev/null && alias cat='bat'       # Uses bat (cat clone with wings) if available.
  command -v fd >/dev/null && alias fd='fd --hidden' # Uses fd (find alternative) with hidden files included.
  command -v yarn >/dev/null && alias y=yarn         # Alias for yarn package manager.

  # File Listing Enhancements
  # Provides enhanced directory listing commands based on available tools (lsd, tree, or fallback find).
  if command -v lsd >/dev/null 2>&1; then
    alias ls="lsd -tr1lh"                                             # Lists files using lsd with tree, reverse, one-per-line, human-readable, and long format.
    alias ll='lsd --tree --group-directories-first -I "node_modules"' # Lists files as a tree, grouping directories first, ignoring node_modules.
    alias listdir='lsd -a --group-directories-first --depth=1'        # Lists directories with lsd, showing all, grouping directories first, and depth of 1.
  elif command -v tree >/dev/null 2>&1; then
    alias ll="tree --dirsfirst -a -L 1 2>/dev/null || ls -la"                                                                                                                                                               # Lists files as a tree, directories first, all files, depth of 1, or falls back to ls -la.
    alias tree='tree -I "node_modules"'                                                                                                                                                                                     # Lists directory contents as a tree, ignoring node_modules.
    alias listdir='tree -L 1 -a -I "node_modules" 2>/dev/null || find ${1:-.} -maxdepth 1 -type f -not -path "*/.*/*" -print0 | xargs -0 -I {} bash -c "echo \"$(dirname \"{}\")\"$(basename \"{}\")\"" | sort -t/ -k2 -k3' # Lists directories using tree or falls back to find.
  else
    alias ll="ls -la"                                                                                                                                                         # Fallback for long format listing, including hidden files.
    alias listdir='find ${1:-.} -maxdepth 1 -type f -not -path "*/.*/*" -print0 | xargs -0 -I {} bash -c "echo \"$(dirname \"{}\")\"$(basename \"{}\")\"" | sort -t/ -k2 -k3' # Fallback for listing directories using find.
  fi

  # JSON Formatting
  # Provides an alias for JSON formatting based on available tools (jq or python's json.tool).
  if command -v jq >/dev/null; then
    alias formatJSON='jq .' # Formats JSON using jq.
  else
    alias formatJSON='python -m json.tool' # Formats JSON using Python's json.tool.
  fi
}

_setup_ai_tool_aliases() {
  # Ollama AI models
  alias olrq='ollama run qwen2.5-coder:1.5b'       # Runs the Qwen 2.5 Coder model with Ollama.
  alias olsq='ollama stop qwen2.5-coder:1.5b'      # Stops the Qwen 2.5 Coder model with Ollama.
  alias olrn='ollama run nomic-embed-text:latest'  # Runs the Nomic Embed Text model with Ollama.
  alias olsn='ollama stop nomic-embed-text:latest' # Stops the Nomic Embed Text model with Ollama.

  # Terminal Tools
  alias neomutt="TERM=xterm-direct neomutt" # Launches Neomutt with direct xterm terminal.
  alias tmux='direnv exec / tmux'           # Executes tmux with direnv.
  alias pp='xsel --clipboard --input'       # Pipes input to the clipboard.
}

_setup_python_aliases() {
  # Virtual environment functions
  python_venv_create() {
    # Creates a Python virtual environment if it doesn't exist and activates it.
    if [[ ! -d .venv ]]; then
      echo "Creating Python virtual environment in ./.venv..."
      python -m venv .venv || {
        echo "Error: Failed to create virtual environment."
        return 1
      }
    fi
    echo "Activating virtual environment..."
    source ./.venv/bin/activate || {
      echo "Error: Failed to activate virtual environment."
      return 1
    }
  }

  python_venv_deactivate() {
    # Deactivates the current Python virtual environment.
    command -v deactivate >/dev/null && deactivate
  }

  python_venv_remove() {
    # Deactivates and removes the Python virtual environment.
    python_venv_deactivate
    [[ -d .venv ]] && rm -rf .venv
  }

  # Strategy for parsing pip outdated packages using jq
  _python_pip_parse_jq() {
    python -m pip --disable-pip-version-check list --outdated --format=json 2>/dev/null | jq -r ".[].name" 2>/dev/null
  }

  # Strategy for parsing pip outdated packages using awk fallback
  _python_pip_parse_awk() {
    echo "Warning: jq is not installed. Falling back to less efficient parsing."
    python -m pip --disable-pip-version-check list --outdated 2>/dev/null | awk '/^Package/ {next} {print $1}'
  }

  # Function to get outdated pip packages based on available tools
  _python_pip_get_outdated_packages() {
    if command -v jq >/dev/null; then
      _python_pip_parse_jq
    else
      _python_pip_parse_awk
    fi
  }

  python_pip_upgrade() {
    # Upgrades all outdated Python pip packages.
    if ! command -v python >/dev/null; then
      echo "Error: Python is not installed."
      return 1
    fi
    if ! command -v pip >/dev/null; then
      echo "Error: pip is not installed."
      return 1
    fi

    local outdated_packages
    outdated_packages=$(_python_pip_get_outdated_packages)

    if [[ -n "$outdated_packages" ]]; then
      echo "$outdated_packages" | xargs -I{} python -m pip install --no-cache-dir -U "{}"
    else
      echo "All Python packages are up to date."
    fi
  }

  # Python Aliases
  alias cvenv='python_venv_create'                # Creates and activates a Python virtual environment.
  alias dvenv='python_venv_deactivate'            # Deactivates the current Python virtual environment.
  alias rvenv='python_venv_remove'                # Removes the Python virtual environment.
  alias pip='python -m pip'                       # Alias for the pip command.
  alias upip='python_pip_upgrade'                 # Upgrades all outdated pip packages.
  alias pyprofile='python -m cProfile -o profile' # Profiles a Python script.
  alias pytest='python -m pytest'                 # Runs pytest.
}

_setup_macos_aliases() {
  if [[ "$(uname)" == Darwin* ]]; then
    # Application Launchers
    alias zed='/Applications/Zed.app/Contents/MacOS/zed'                                          # Launches the Zed editor.
    alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'                 # Launches Google Chrome.
    alias canary='/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary' # Launches Google Chrome Canary.
    alias vsc='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'            # Launches Visual Studio Code.

    VSC_BIN='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin'
    PATH=$VSC_BIN:$PATH
    export PATH # Adds VSCode binary directory to PATH.

    # VSCode Launcher Function
    codium() {
      # Launches VSCode with the current working directory.
      VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args "$@"
    }
  fi
}

_setup_aliases() {
  _setup_development_aliases
  _setup_system_tool_aliases
  _setup_network_aliases
  _setup_enhanced_tool_aliases
  _setup_ai_tool_aliases
  _setup_python_aliases
  _setup_macos_aliases
}

_setup_aliases
