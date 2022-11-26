{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.nix;

in

{
  options = with lib; {
    my.modules.nix = {
      enable = mkEnableOption ''
        Whether to enable nix module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      services = {
        nix-daemon = {
          enable = true;
        };
      };
    };
}
