## [2025-10-22] - Zsh History Display Limit

- **Added**: Custom history function in `config/zsh.d/zsh/config/aliases.zsh` that displays the last 1000 commands by default instead of showing all 200,000 history entries.
- **Added**: `history_custom()` function with configurable default count (1000) that uses the `fc` command to display history.
- **Added**: Alias for `history` command that overrides the default behavior to use the custom function.
- **Added**: `_setup_history_aliases()` function to organize history-related aliases following the project's pattern.

## [2025-10-02] - Git Hooks Fix

- **Fixed**: Updated `config/git/hooks/pre-commit` to properly detect git conflict markers by correcting the regex pattern from `^[<]{7} |^[>]{7} ` to `^<{7}|^={7}|^>{7}` to match standard git conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).

## [2025-09-25] - Prime Directive Rule Conversion

- **Changed**: Converted `.continue/rules/prime-directive.md` to YAML format (`.continue/rules/prime-directive.yaml`) with proper Continue rules schema.
- **Changed**: Converted `.continue/rules/one-function-one-file.md` to YAML format (`.continue/rules/one-function-one-file.yaml`) with proper Continue rules schema.
- **Changed**: Converted `.continue/rules/functional-programming.md` to YAML format (`.continue/rules/functional-programming.yaml`) with proper Continue rules schema.

### Changed

- **config/zsh.d/zsh/config/aliases.zsh**: Added Python aliases to use python3 binary for both `python` and `python3` commands.
- **config/zsh.d/zsh/bin/proto**: Add `NODE_EXTRA_CA_CERTS` export for macOS to handle custom SSL certificates.
-e ### Fix .zshrc (config/zsh.d/.zshrc) - Final

- **Simplified `zdelay` Function**: Removed the dependency on the `zsh/mathfunc` module and the custom `float_eval` function. The `zdelay` function now uses Zsh's native floating-point arithmetic, making it more robust and self-contained.

## 2025-06-28

### Fixed

- **`config/zsh.d/.zshenv`**: Corrected a globbing bug in the macOS `PATH` configuration that prevented the `rustup` path from being added correctly.
- **`config/zsh.d/.zshenv`**: Made the `RUST_SRC_PATH` detection dynamic to prevent breakage when the Rust toolchain is updated.

### Changed

- **`config/zsh.d/.zshenv`**: Improved readability of the `_no_proxy_hosts` list by grouping related hosts.

---

## 2025-06-28

- **Refactor(`config/zsh.d/.zshenv`):** Correctly set and unset `no_proxy` and `NO_PROXY` environment variables in proxy management functions to ensure cross-tool compatibility.

# Changes Log

## [2025-06-28] - Zsh Environment Configuration Refactoring

- Refactored `config/zsh.d/.zshenv` to improve readability and maintainability.
- Renamed `_exists` to `_is_dir` and updated it to check for directories.
- Added comments to the `PATH` configuration and standardized directory checks.
- Simplified the `lesspipe` setup using a loop.
- Re-defined `_NO_PROXY` as a multi-line array to improve readability.
- Updated proxy management functions to provide clearer output.

## [2025-06-27] - Proto Script Optimization

- Optimized 'config/zsh.d/zsh/bin/proto' for improved performance and readability.
- Removed commented-out plugin installation checks to clean up the script.
- Grouped environment variable exports for better organization.
- Simplified Node.js and Go setup with conditional checks.
- Refactored custom proto commands to reduce repetition and improve clarity.
- Converted multi-line `if` statement for `NODE_VERSION` and `GOROOT` to a single line for better readability.
- Converted multi-line `if` statement for `NODE_VERSION` in Node.js setup to a single line for consistency.
