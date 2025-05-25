{ pkgs, lib, config, options, ... }:

let cfg = config.my.modules.nix;

in {
  options = with lib; {
    my.modules.nix = {
      enable = mkEnableOption ''
        Whether to enable nix module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      # nix-daemon is now managed unconditionally when nix.enable is on
      # services.nix-daemon.enable option has been removed
    };
}
