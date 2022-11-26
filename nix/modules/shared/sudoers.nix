{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.sudoers;

in

{
  options = with lib; {
    my.modules.sudoers = {
      enable = mkEnableOption ''
        Whether to enable sudoers module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      environment = {
        etc = {
          "sudoers.d/admin" = {
            text = ''
              %admin ALL=(ALL) NOPASSWD:ALL
            '';
          };
        };
      };
    };
}
