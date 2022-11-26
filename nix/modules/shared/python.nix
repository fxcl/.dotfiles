{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.python;

in

{
  options = with lib; {
    my.modules.python = {
      enable = mkEnableOption ''
        Whether to enable python module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      my = {
        env = { PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/config.py"; };
        user = {
          packages = with pkgs;
            [
              (python39.withPackages (ps:
                with ps; [
                  pip

                  black # Code formatter
                  setuptools
                  pylint # Linter
                  # poetry # Better package manager
                  python-lsp-server
                  # virtualenv
                  flake8
                  # ipython
                ]))
              # nixos.python38Packages.httpx
            ];

        };

        hm.file = {
          ".config/python" = {
            recursive = true;
            source = ../../../config/python;
          };
          ".config/pip" = {
            recursive = true;
            source = ../../../config/pip;
          };
        };
      };
    };
}
