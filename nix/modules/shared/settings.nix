{ config, pkgs, lib, home-manager, options, ... }:

with lib;

let
  mkOptStr = value:
    mkOption {
      type = with types; uniq str;
      default = value;
    };

  mkSecret = description: default:
    mkOption {
      inherit description default;
      type = with types; either str (listOf str);
    };

  mkOpt = type: default: mkOption { inherit type default; };

  mkOpt' = type: default: description:
    mkOption { inherit type default description; };

  mkBoolOpt = default:
    mkOption {
      inherit default;
      type = types.bool;
      example = true;
    };

  home =
    if pkgs.stdenv.isDarwin then
      "/Users/${config.my.username}"
    else
      "/home/${config.my.username}";

in
{
  options = with types; {
    my = {
      fullname = mkOptStr "Kelvin Zhao";
      timezone = mkOptStr "Asia/Shanghai ";
      username = mkOptStr "kelvin";
      website = mkOptStr "https://gabri.me";
      github_username = mkOptStr "fxcl";
      email = mkOptStr "me@gnux.cn";
      terminal = mkOptStr "kitty";

      nix_managed = mkOptStr
        "vim: set nomodifiable : Nix managed - DO NOT EDIT - see source inside ~/.dotfiles or use `:set modifiable` to force.";
      user = mkOption { type = options.users.users.type.functor.wrapped; };
      hostConfigHome = mkOptStr "";
      hm = {
        file = mkOpt' attrs { } "Files to place directly in $HOME";
        configFile = mkOpt' attrs { } "Files to place in $XDG_CONFIG_HOME";

        configHome = mkOpt' path "${home}/.config" "Absolute path to directory holding application configurations.";
        cacheHome = mkOpt' path "${home}/.cache" "Absolute path to directory holding application caches.";

        dataFile = mkOpt' attrs { } "Files to place in $XDG_DATA_HOME";
        dataHome = mkOpt' path "${home}/.local/share" "Absolute path to directory holding application data.";

        stateHome = mkOpt' path "${home}/.local/state" "Absolute path to directory holding application states.";
        binHome = mkOpt' path "${home}/.local/bin" "Absolute path to directory holding application data.";
        programs = mkOpt' attrs { } "Programs to enable via home-manager";
        services = mkOpt' attrs { } "Services to enable via home-manager";
      };

      env = mkOption {
        type = attrsOf (either (either str path) (listOf (either str path)));
        apply = mapAttrs (n: v:
          if isList v then
            concatMapStringsSep ":" (x: toString x) v
          else
            (toString v));
        default = { };
        description = "Environment variables to be set";
      };

      init = mkOption {
        type = types.lines;
        description = ''
          An init script that runs after the environment has been rebuilt or
          booted. Anything done here should be idempotent and inexpensive.
        '';
      };

      modules = { };
    };
  };

  config = {
    users.users."${config.my.username}" = mkAliasDefinitions options.my.user;

    my.user = {
      inherit home;
      description = "Primary user account";
    };

    my.hostConfigHome = "${config.my.hm.dataHome}/${config.networking.hostName}";

    # PATH should always start with its old value
    # must already begin with pre-existing PATH. Also, can't use binDir here,
    # because it contains a nix store path.
    # my.env.PATH  = [ <bin> "$PATH" ];
    my.env.PATH = [ "$NODE_HOME/bin" "/Users/kelvin/.local/share/cargo/bin" "/Users/kelvin/.cache/npm/bin" ./bin "$XDG_BIN_HOME" "$PATH" ];

    # let nix manage home-manager profiles and use global nixpkgs
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      #backupFileExtension = "backup";

      # I only need a subset of home-manager's capabilities. That is, access to
      # its home.file, home.xdg.configFile and home.xdg.dataFile so I can deploy
      # files easily to my $HOME, but 'home-manager.users.${config.my.username}.home.file.*'
      # Re-defining home-manager settings for modified option-names:
      # is much too long and harder to maintain, so I've made aliases in:
      #   my.hm -> home-manager.users.<primary user>
      #   my.hm.file        ->  home-manager.users.zxfstd.home.file
      #   my.hm.configFile  ->  home-manager.users.zxfstd.home.xdg.configFile
      #   my.hm.dataFile    ->  home-manager.users.zxfstd.home.xdg.dataFile
      users."${config.my.username}" = {
        home = {
          # Necessary for home-manager to work with flakes, otherwise it will
          # look for a nixpkgs channel.
          stateVersion =
            if pkgs.stdenv.isDarwin then "23.05" else config.system.stateVersion;
          inherit (config.my) username;
          file = mkAliasDefinitions options.my.hm.file;
        };

        xdg = {
          enable = true;
          cacheHome = mkAliasDefinitions options.my.hm.cacheHome;
          configFile = mkAliasDefinitions options.my.hm.configFile;
          # configHome = mkAliasDefinitions options.my.hm.configHome;
          dataFile = mkAliasDefinitions options.my.hm.dataFile;
          # dataHome = mkAliasDefinitions options.my.hm.dataHome;
          stateHome = mkAliasDefinitions options.my.hm.stateHome;

        };

        programs = mkAliasDefinitions options.my.hm.programs;
        services = mkAliasDefinitions options.my.hm.services;

        #programs = {
        #  # Let Home Manager install and manage itself.
        #  home-manager.enable = true;
        #};
      };

    };


    environment.extraInit =
      let exportLines = mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.my.env;
      in
      ''
        # export XAUTHORITY=/tmp/Xauthority
        # [ -e ~/.Xauthority ] && mv -f ~/.Xauthority "$XAUTHORITY"
        ${concatStringsSep "\n" exportLines}
      '';

  };
}
