{ pkgs, ... }:
let
  username = "kelvin";

in
{
  enable = true;
  enableZshIntegration = true;
  nix-direnv.enable = true;
  # See: https://github.com/nix-community/nix-direnv
  # enableNixDirenvIntegration = true;

  config = {
    global = {
      strict_env = true;
    };

    whitelist = {
      prefix = [
        "/Users/${username}/Workspace/"
      ];
    };
  };

  stdlib = ''
    layout_poetry() {
      if [[ ! -f pyproject.toml ]]; then
        log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
        exit 2
      fi
      # create venv if it doesn't exist
      poetry run true
      export VIRTUAL_ENV=$(poetry env info --path)
      export POETRY_ACTIVE=1
      PATH_add "$VIRTUAL_ENV/bin"
    }
    layout_node() {
      PATH_add node_modules/.bin
    }
    # if [[ -f pyproject.toml ]]; then
    #   layout_poetry
    # fi
    # if [[ -f node_modules ]]; then
    #   layout_node
    # fi
  '';

}
