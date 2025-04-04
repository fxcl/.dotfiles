{ pkgs, lib, config, ... }:

let

  cfg = config.my.modules.starship;

in
{
  options = with lib; {
    my.modules.starship = {
      enable = mkEnableOption ''
        Whether to enable bat module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      my.hm.programs.starship = {
        enable = true;
      };
      my.user = { packages = with pkgs; [ starship ]; };
      my.hm.file = {
        ".config/starship.toml" = { source = ../../../config/starship.toml; };
      };
    };
}
