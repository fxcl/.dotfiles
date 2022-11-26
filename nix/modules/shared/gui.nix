{ pkgs, lib, config, options, ... }:

let

  cfg = config.my.modules.gui;

in
{
  options = with lib; {
    my.modules.gui = {
      enable = mkEnableOption ''
        Whether to enable gui module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable (mkMerge [
      (if (builtins.hasAttr "homebrew" options) then {
        # TODO: (automate) Requires homebrew to be installed
        homebrew.taps = [
          "homebrew/cask"
          "homebrew/cask-versions"
          "homebrew/cask-fonts"
        ];
        homebrew.casks = [
          "iterm2"
          "notunes"
          "keepingyouawake"
          "google-chrome"
          "mpv"
          "iina"
          "appcleaner"
          "raycast"
          "rectangle"
          # "bitwarden"
          # "hammerspoon"
          # "adobe-acrobat-reader"
          # "authy"
          # "bartender"
          # "battle-net"
          # "deezer"
          # "discord"
          # "lima"
          # "element"
          "balenaetcher"
          # "eul"
          # "ImageOptim"
          # "jabra-direct"
          # "lastpass"
          # "lens"
          # "macdown"
          # "mattermost"
          # "multipass"
          # "owncloud"

          # "signal"
          # "slack"
          # "steam"
          # "microsoft-teams"
          # "zoom"
          # "franz"
          # "firefox"

          # "anki"
          # "corelocationcli"
          # "db-browser-for-sqlite"
          # "figma"
          # "brave-browser"
          # "imageoptim"
          # "kap"
          # "launchcontrol"
          # "obsidian"
          # "sync"
          # "visual-studio-code"
          # "logseq"
          # "vscodium"
        ];

        # my.hm.file = {
        #   ".hammerspoon" = {
        #     recursive = true;
        #     source = ../../../config/.hammerspoon;
        #   };
        # };

      } else {
        my = {
          user.packages = with pkgs; [
            ngrok
            mpv
            anki
            #brave
            firefox
            #obsidian
            logseq
            #zoom-us
            #signal-desktop
            slack
            #docker
            # sqlitebrowser
            # virtualbox
          ];
        };
      })

      {
        my.hm.file = {
          ".config/mpv" = {
            recursive = true;
            source = ../../../config/mpv;
          };
        };
      }
    ]);
}
