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
          # "google-chrome"
          "mpv"
          "iina"
          "appcleaner"
          "raycast"
          "rectangle"
          # "aria2"
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
            #slack
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
          ".config/tig" = {
            recursive = true;
            source = ../../../config/tig;
          };

          ".config/aria2" = {
            recursive = true;
            source = ../../../config/aria2;
          };
          ".cargo/config" = {
            text = ''
              [alias]
              i = "init"
              nb = "new --bin"
              nl = "new --lib"

              r = "run"
              rr = "run --release"
              re = "run --example"
              rer = "run --release --example"

              b = "build"
              br = "build --release"
              be = "build --example"
              ber = "build --release --example"

              c = "check"
              cl = "clean"
              clp = "clippy --manifest-path=Cargo.toml --all-targets -- -D warnings"
              d = "doc"
              do = "doc --open"
              t = "test"
              ben = "bench"
              u = "update"
              s = "search"
              p = "publish"
              in = "install"
              un = "uninstall"
              h = "--help"
              f = "fmt"
              ls = "--list"
              [build]
              target = "x86_64-apple-darwin"
              rustflags = "-L /usr/local/lib"

              [target.'cfg(all(target_os = "macos", target_arch = "x86_64"))']
              rustflags = ["-C", "link-args=-framework CoreFoundation"]

            '';
          };
        };
      }
    ]);
}
