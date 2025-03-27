export LS_COLORS=$(vivid generate one-light)
export COLORTERM="truecolor"
# Better spell checking & auto correction prompt
export SPROMPT="zsh: correct %F{red}'%R'%f to %F{blue}'%r'%f [%B%Uy%u%bes, %B%Un%u%bo, %B%Ue%u%bdit, %B%Ua%u%bbort]?"
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS="-F -g -i -M -R -S -w -X -z-4"
export KEYTIMEOUT="1"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export DOTFILES="$HOME/.dotfiles"
export PROJECTS="$HOME/Sites/personal/dev"
export WORK="$HOME/Sites/work"
export PERSONAL_STORAGE="$HOME/Sync"
export NOTES_DIR="$PERSONAL_STORAGE/notes"

export CLICOLOR=1
export GPG_TTY="${GPG_TTY:-$(tty)}"
export HOMEBREW_NO_AUTO_UPDATE=1
export RUST_BACKTRACE=1

# I use a single zk notes dir, so set it and forget
export ZK_NOTEBOOK_DIR=$NOTES_DIR
# export HOST_CONFIGS="$XDG_DATA_HOME/$(hostname)"

############### APPS/POGRAMS XDG SPEC CLEANUP
export RLWRAP_HOME="$XDG_DATA_HOME/rlwrap"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export _ZO_DATA_DIR="$XDG_CONFIG_HOME/zoxide"

#ollama amd gpu
export HSA_OVERRIDE_GFX_VERSION="10.3.0"

# Canonical hex dump; some systems have this symlinked
command -v hd >/dev/null || alias hd="hexdump -C"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum >/dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum >/dev/null || alias sha1sum="shasum"

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]/}

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
for command in lesspipe lesspipe.sh; do
  if [[ -n ${commands[$command]} ]]; then
    export LESSOPEN="| /usr/bin/env ${commands[$command]} %s 2>/dev/null"
    break
  fi
done

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath manpath path

##############################################################
# PATH.
# (N-/): do not register if the directory does not exists
# (Nn[-1]-/)
#
#  N   : NULL_GLOB option (ignore path if the path does not match the glob)
#  n   : Sort the output
#  [-1]: Select the last item in the array
#  -   : follow the symbol links
#  /   : ignore files
#  t   : tail of the path
##############################################################

# PATH configuration (optimized for performance)
typeset -U path  # Ensure PATH entries are unique

# System paths (absolute paths only)
path=(
  /usr/local/bin
  /usr/local/sbin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $path
)

# User paths (only add if directories exist)
[[ -d "${ZDOTDIR}/bin" ]] && path=("${ZDOTDIR}/bin" $path)
[[ -d "${HOME}/.local/bin" ]] && path=("${HOME}/.local/bin" $path)
[[ -n "${GOBIN}" && -d "${GOBIN}" ]] && path=("${GOBIN}" $path)

# M1/M2 Homebrew paths
[[ -d "/opt/homebrew/bin" ]] && path=("/opt/homebrew/bin" $path)
