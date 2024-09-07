{ pkgs, lib, config, ... }:

let

  cfg = config.my.modules.emacs;
  # MacOS: Pasting images to emacs
  pngpaste = pkgs.stdenv.mkDerivation rec {
    name = "pngpaste";
    buildInputs = [ pkgs.darwin.apple_sdk.frameworks.Cocoa ];
    src = pkgs.fetchFromGitHub {
      owner = "jcsalterego";
      repo = "pngpaste";
      rev = "67c39829fedb97397b691617f10a68af75cf0867";
      sha256 = "089rqjk7khphs011hz3f355c7z6rjd4ydb4qfygmb4x54z2s7xms";
    };
    installPhase = ''
      mkdir -p $out/bin
      cp pngpaste $out/bin/
    '';
  };

in {
  options = with lib; {
    my.modules.emacs = {
      enable = mkEnableOption ''
        Whether to enable emacs module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      my = {
        user = {
          packages = with pkgs;
            [
              emacs
              # Doom emacs dependencies
              # https://github.com/hlissner/doom-emacs
              coreutils
              git
              ripgrep
              fd

              # Modules dependencies
              gcc # Required to build sqlite if not compiled.
              sqlite # Org Roam's database.
              plantuml # To export Plant UML diagrams.
              xapian # Notdeft's backend to index files.
              pandoc # Preview markdown.
            ] ++ lib.optionals pkgs.stdenv.isDarwin [ pngpaste ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              (makeDesktopItem {
                name = "org-protocol";
                exec = "emacsclient %u";
                comment = "Org Protocol";
                desktopName = "org-protocol";
                type = "Application";
                mimeTypes = [ "x-scheme-handler/org-protocol" ];
              })
            ];
        };

        hm.file = {
          ".config/doom" = {
            recursive = true;
            source = ../../../config/doom;
          };
        };
      };
    };
}
