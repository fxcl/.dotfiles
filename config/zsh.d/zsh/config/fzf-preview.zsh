# Cache directory for preview results
typeset -g FZF_PREVIEW_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/fzf-preview"

# Create cache directory if it doesn't exist
[[ ! -d "$FZF_PREVIEW_CACHE_DIR" ]] && mkdir -p "$FZF_PREVIEW_CACHE_DIR"

# Generate cache key for a file
_fzf_cache_key() {
  echo "$1:$(stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null)"
}

# Get cached preview if available and not stale
_fzf_get_cached_preview() {
  local cache_key="$(_fzf_cache_key "$1")"
  local cache_file="$FZF_PREVIEW_CACHE_DIR/${cache_key//\//_}"
  [[ -f "$cache_file" ]] && cat "$cache_file"
}

# Cache preview result
_fzf_cache_preview() {
  local cache_key="$(_fzf_cache_key "$1")"
  local cache_file="$FZF_PREVIEW_CACHE_DIR/${cache_key//\//_}"
  cat > "$cache_file"
}

# Optimized path completion
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Optimized directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Enhanced preview command runner with caching
_fzf_comprun() {
  local command=$1
  shift

  # Try to get cached preview first
  local cached_preview
  cached_preview="$(_fzf_get_cached_preview "$command")"
  
  if [[ -n "$cached_preview" ]]; then
    echo "$cached_preview"
    return
  fi

  # Generate and cache preview based on file type
  case "$command" in
    cd)
      # Directory preview with tree structure
      eza --tree --level=2 --color=always --git {} | head -50 | tee >(_fzf_cache_preview "$command")
      ;;
    
    export|unset)
      # Environment variable preview
      eval 'echo \$'{} | tee >(_fzf_cache_preview "$command")
      ;;
    
    ssh)
      # Host preview with DNS info
      dig {} | tee >(_fzf_cache_preview "$command")
      ;;
    
    *)
      # Smart file preview based on file type
      if [[ -f {} ]]; then
        case $(file --mime-type {} -b) in
          text/*)
            bat --color=always --style=numbers --line-range=:200 {} | tee >(_fzf_cache_preview "$command")
            ;;
          image/*)
            exiftool {} | tee >(_fzf_cache_preview "$command")
            ;;
          application/json)
            jq -C '.' {} | tee >(_fzf_cache_preview "$command")
            ;;
          application/x-executable|application/x-pie-executable)
            file -b {} | tee >(_fzf_cache_preview "$command")
            ;;
          *)
            file -b {} | tee >(_fzf_cache_preview "$command")
            ;;
        esac
      else
        echo "Not a regular file" | tee >(_fzf_cache_preview "$command")
      fi
      ;;
  esac
}
