# https://nix-community.github.io/home-manager/options.html#opt-programs.starship.enable
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

        settings = {
          aws = {
            style = "bold #ffb86c";
          };

          character = {
            error_symbol = "[λ](bold #ff5555)";
            success_symbol = "[λ](bold #50fa7b)";
          };

          cmd_duration = {
            style = "bold #f1fa8c";
          };

          directory = {
            style = "bold #50fa7b";
          };

          git_branch = {
            style = "bold #ff79c6";
          };

          git_status = {
            style = "bold #ff5555";
          };

          hostname = {
            style = "bold #bd93f9";
          };

          username = {
            format = "[$user]($style) on ";
            style_user = "bold #8be9fd";
          };

        };
      };
    };
}
