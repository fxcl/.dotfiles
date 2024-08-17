{ pkgs, lib, config, ... }:

let

  cfg = config.my.modules.misc;

in
{
  options = with lib; {
    my.modules.misc = {
      enable = mkEnableOption ''
        Whether to enable misc module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      my.hm.file = {
        ".config/starship.toml" = { source = ../../../config/starship.toml; };
        ".gemrc" = { source = ../../../config/.gemrc; };
        ".curlrc" = { source = ../../../config/.curlrc; };
        ".ignore" = { source = ../../../config/.ignore; };
        ".config/fd/ignore" = {
          recursive = true;
          text = builtins.readFile ../../../config/.ignore;
        };
        ".mailcap" = { source = ../../../config/.mailcap; };
        ".psqlrc" = { source = ../../../config/.psqlrc; };
        ".urlview" = { source = ../../../config/.urlview; };
        ".condarc" = { source = ../../../config/.condarc; };
        ".editorconfig" = { source = ../../../config/.editorconfig; };
        ".config/tldr/config.toml" = {
          recursive = true;
          text = builtins.readFile ../../../config/tldr/config.toml;
        };
      };
    };
}
