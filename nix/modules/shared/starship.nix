{ pkgs, lib, config, options, ... }:

let cfg = config.my.modules.starship;

in {
  options = with lib; {
    my.modules.starship = {
      enable = mkEnableOption ''
        Whether to enable starship module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      my.hm.programs.starship = {
        enable = true;
        enableZshIntegration = true;
      };
    };
}
