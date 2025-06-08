# Cache directory for preview results
typeset -g FZF_PREVIEW_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/fzf-preview"

# In-memory cache for preview results: stores content and timestamp
typeset -gA FZF_PREVIEW_IN_MEMORY_CACHE

# Cache expiration time (1 hour in seconds)
typeset -gi FZF_PREVIEW_CACHE_EXPIRATION_SECONDS=3600

# Create cache directory if it doesn't exist
[[ ! -d "$FZF_PREVIEW_CACHE_DIR" ]] && mkdir -p "$FZF_PREVIEW_CACHE_DIR"

# Generate a unique cache key for a given command and its arguments
_fzf_generate_cache_key() {
  local command_and_args="$@"
  echo "${command_and_args}" | sha1sum | awk '{print $1}'
}

# Generate a file-specific cache key based on path and modification time
_fzf_file_cache_key() {
  local file_path="$1"
  if [[ -f "$file_path" ]]; then
    echo "${file_path}:$(stat -f %m "$file_path" 2>/dev/null || stat -c %Y "$file_path" 2>/dev/null)"
  else
    echo "${file_path}:no_file"
  fi
}

# Get cached preview if available and not stale
_fzf_get_cached_preview() {
  local cache_key="$(_fzf_generate_cache_key "$@")"
  local current_time=$(date +%s)

  # Check in-memory cache first
  if [[ -n "${FZF_PREVIEW_IN_MEMORY_CACHE[$cache_key]}" ]]; then
    local cached_data="${FZF_PREVIEW_IN_MEMORY_CACHE[$cache_key]}"
    local timestamp="${cached_data%%:*}"
    local content="${cached_data#*:}"

    if (((current_time - timestamp) < FZF_PREVIEW_CACHE_EXPIRATION_SECONDS)); then
      echo "$content"
      return 0
    else
      # In-memory cache expired
      unset "FZF_PREVIEW_IN_MEMORY_CACHE[$cache_key]"
    fi
  fi

  # Check file cache
  local file_cache_key="$(_fzf_file_cache_key "$@")"
  local cache_file="$FZF_PREVIEW_CACHE_DIR/${file_cache_key//[^a-zA-Z0-9_.-]/_}"

  if [[ -f "$cache_file" ]]; then
    local file_timestamp=$(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null)
    if (((current_time - file_timestamp) < FZF_PREVIEW_CACHE_EXPIRATION_SECONDS)); then
      local content=$(cat "$cache_file")
      # Populate in-memory cache
      FZF_PREVIEW_IN_MEMORY_CACHE[$cache_key]="${current_time}:${content}"
      echo "$content"
      return 0
    else
      # File cache expired, remove it
      rm -f "$cache_file"
    fi
  fi

  return 1 # No valid cache found
}

# Cache preview result
_fzf_cache_preview() {
  local cache_key="$(_fzf_generate_cache_key "$@")"
  local current_time=$(date +%s)
  local content=$(cat) # Read content from stdin

  # Store in in-memory cache with current timestamp
  FZF_PREVIEW_IN_MEMORY_CACHE[$cache_key]="${current_time}:${content}"

  # Store in file cache
  local file_cache_key="$(_fzf_file_cache_key "$@")"
  local cache_file="$FZF_PREVIEW_CACHE_DIR/${file_cache_key//[^a-zA-Z0-9_.-]/_}"
  echo "$content" >"$cache_file"
}

# Optimized path completion
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Optimized directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Handle directory previews
_fzf_preview_directory() {
  local dir_path="$1"
  if [[ -d "$dir_path" ]]; then
    eza --tree --level=2 --color=always --git "$dir_path" 2>/dev/null | head -50
  else
    echo "Not a directory: $dir_path"
  fi
}

# Handle environment variable previews
_fzf_preview_env_var() {
  local var_name="$1"
  if [[ -n "$var_name" ]]; then
    eval "echo \$$var_name" 2>/dev/null || echo "Environment variable not found: $var_name"
  else
    echo "No environment variable specified."
  fi
}

# Handle SSH host previews
_fzf_preview_ssh_host() {
  local host="$1"
  if [[ -n "$host" ]]; then
    # Using getent hosts for faster lookup than dig
    getent hosts "$host" 2>/dev/null || echo "Could not resolve host: $host"
  else
    echo "No SSH host specified."
  fi
}

# Handle generic file previews based on mime type
_fzf_preview_file() {
  local file_path="$1"
  if [[ -f "$file_path" ]]; then
    case $(file --mime-type -b "$file_path") in
    text/*)
      bat --color=always --style=numbers --line-range=:200 "$file_path" 2>/dev/null || cat "$file_path" | head -200
      ;;
    image/*)
      exiftool "$file_path" 2>/dev/null || echo "Binary file: $file_path"
      ;;
    application/json)
      jq -C '.' "$file_path" 2>/dev/null || cat "$file_path" | head -200
      ;;
    application/x-executable | application/x-pie-executable)
      file -b "$file_path" 2>/dev/null
      ;;
    *)
      file -b "$file_path" 2>/dev/null || echo "Cannot preview file type: $file_path"
      ;;
    esac
  else
    echo "Not a regular file: $file_path"
  fi
}

# Enhanced preview command runner with caching and error handling
_fzf_comprun() {
  local command="$1"
  local target_item="$2" # The item being previewed (e.g., file path, variable name, host)
  local preview_content=""

  # Try to get cached preview first
  preview_content="$(_fzf_get_cached_preview "$command" "$target_item")"

  if [[ -n "$preview_content" ]]; then
    echo "$preview_content"
    return 0
  fi

  # Generate preview based on command and target item
  case "$command" in
  cd)
    preview_content="$(_fzf_preview_directory "$target_item")"
    ;;
  export | unset)
    preview_content="$(_fzf_preview_env_var "$target_item")"
    ;;
  ssh)
    preview_content="$(_fzf_preview_ssh_host "$target_item")"
    ;;
  *)
    preview_content="$(_fzf_preview_file "$target_item")"
    ;;
  esac

  # Cache the generated preview content
  if [[ -n "$preview_content" ]]; then
    echo "$preview_content" | _fzf_cache_preview "$command" "$target_item"
  else
    echo "Failed to generate preview for $command $target_item" | _fzf_cache_preview "$command" "$target_item"
  fi
}
