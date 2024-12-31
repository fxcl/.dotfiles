{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.finder;
in

{
  options = with lib; {
    my.modules.finder = {
      enable = mkEnableOption ''
        Whether to enable finder module
      '';

      entries = mkOption {
        description = ''
          Entries for the Finder
        '';
        type = with types; listOf (submodule {
          options = {
            path = lib.mkOption {
              type = str;
            };

            alias = lib.mkOption {
              type = str;
              default = "";
            };
          };
        });
      };
    };
  };

  config = with lib;
    mkIf cfg.enable (
      let
        normalize = path: if hasSuffix "/" path then path else path + "/";

        entryURI = path: "file://" + (builtins.replaceStrings
          [ " " "!" "\"" "#" "$" "%" "&" "'" "(" ")" ]
          [ "%20" "%21" "%22" "%23" "%24" "%25" "%26" "%27" "%28" "%29" ]
          (normalize path)
        );

        wantURIs = concatMapStrings
          (entry: "${entryURI entry.path}\n")
          cfg.entries;

        createEntries = concatMapStrings
          (entry: "mysides add '${entry.alias}' '${entryURI entry.path}'\n")
          cfg.entries;
      in
      {
        environment = {
          systemPackages = with pkgs; [
            mysides
          ];
        };

        system.activationScripts.postUserActivation.text = ''
          echo >&2 "Setting up finder items..."
          haveURIs="$(mysides list | ${pkgs.coreutils}/bin/cut -d' ' -f3)"
          if ! diff -wu <(echo -n "$haveURIs") <(echo -n '${wantURIs}') >&2; then
            echo >&2 "Resetting finder"
            mysides remove all
            ${createEntries}
          else
            echo >&2 "Finder is how we want it"
          fi
        '';
      }
    );
}
