# As a first step, I will try to symlink my configs as much as possible then
# migrate the configs to Nix
#
# https://nixcloud.io/ for Nix syntax
# https://nix.dev/
# https://nixos.org/guides/nix-pills/
# https://nix-community.github.io/awesome-nix/
# https://discourse.nixos.org/t/home-manager-equivalent-of-apt-upgrade/8424/3
# https://www.reddit.com/r/NixOS/comments/jmom4h/new_neofetch_nixos_logo/gayfal2/
# https://www.youtube.com/user/elitespartan117j27/videos?view=0&sort=da&flow=grid
# https://www.youtube.com/playlist?list=PLRGI9KQ3_HP_OFRG6R-p4iFgMSK1t5BHs
# https://www.reddit.com/r/NixOS/comments/k9xwht/best_resources_for_learning_nixos/
# https://www.reddit.com/r/NixOS/comments/k8zobm/nixos_preferred_packages_flow/
# https://www.reddit.com/r/NixOS/comments/j4k2zz/does_anyone_use_flakes_to_manage_their_entire/
# https://serokell.io/blog/practical-nix-flakes
# https://stephank.nl/p/2023-02-28-using-flakes-for-nixos-configs.html
# https://zero-to-nix.com/
{
  description = "NixOS and Darwin configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";

    # Home inputs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure versions are consistent.

    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs = {
        nix-darwin.follows = "darwin";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # MacOS inputs
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure versions are consistent.
    };

    # nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
    nixpkgs-mozilla.flake = false;

    emacs.url = "github:cmacrae/emacs";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";

    };

    zk = {
      url = "github:mickael-menu/zk";
      flake = false;
    };

  };

  outputs = { self, flake-utils, ... }@inputs:
    let
      darwinHosts = {
        "tony" = "x86_64-darwin";
        "vvh" = "aarch64-darwin";
      };

      darwinSystems =
        inputs.nixpkgs.lib.unique (inputs.nixpkgs.lib.attrValues darwinHosts);

      linuxHosts = { "nixos" = "x86_64-linux"; };

      linuxSystems =
        inputs.nixpkgs.lib.unique (inputs.nixpkgs.lib.attrValues linuxHosts);

      forAllSystems = f:
        inputs.nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;

      mapHosts = f: hostsMap: builtins.mapAttrs f hostsMap;

      sharedConfiguration = { config, pkgs, ... }: {
        system.configurationRevision = self.rev or self.dirtyRev or null;

        nix = {
          nixPath = {
            inherit (inputs) nixpkgs;
            inherit (inputs) darwin;
            inherit (inputs) home-manager;
          };

          package = pkgs.nixVersions.git;
          extraOptions = ''
            experimental-features = nix-command flakes
          '';

          settings = {
            trusted-users = [ "@admin" ];
            experimental-features = [ "nix-command" "flakes" ];

            extra-trusted-substituters = [ "https://nix-cache.status.im" ];

            # disabled on Darwin because some buggy behaviour: https://github.com/NixOS/nix/issues/7273
            auto-optimise-store = !pkgs.stdenv.isDarwin;

            substituters = [
              #"https://mirror.sjtu.edu.cn/nix-channels/store"
              #"https://mirrors.ustc.edu.cn/nix-channels/store"
              "https://cache.nixos.org"
              "https://nix-mirror.freetls.fastly.net"
              "https://nix-community.cachix.org"
              "https://nixpkgs.cachix.org"
              "https://srid.cachix.org"
              "https://nix-linter.cachix.org"
              "https://statix.cachix.org"
            ];

            trusted-public-keys = [
              "nix-cache.status.im-1:x/93lOfLU+duPplwMSBR+OlY4+mo+dCN7n0mr4oPwgY="
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
              "srid.cachix.org-1:MTQ6ksbfz3LBMmjyPh0PLmos+1x+CdtJxA/J2W+PQxI="
              "nix-linter.cachix.org-1:BdTne5LEHQfIoJh4RsoVdgvqfObpyHO5L0SCjXFShlE="
              "statix.cachix.org-1:Z9E/g1YjCjU117QOOt07OjhljCoRZddiAm4VVESvais="
            ];
            # Recommended when using `direnv` etc.
            keep-derivations = true;
            keep-outputs = true;
          };

          gc = {
            automatic = true;
            options = "--delete-older-than 10d";
          };

          optimise = {
            # Enable store optimization because we can't set `auto-optimise-store` to true on macOS.
            automatic = pkgs.stdenv.isDarwin;
          };
        };

        fonts = {
          # fontDir.enable = true;
          packages = with pkgs;
            [ ] ++ (lib.optionals pkgs.stdenv.isLinux [
              noto-fonts
              noto-fonts-cjk
              noto-fonts-emoji
              # liberation_ttf
              fira-code
              fira-code-symbols
              mplus-outline-fonts
              dina-font
              proggyfonts
              (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
            ]);
        };

        nixpkgs = {
          config = { allowUnfree = true; };
          overlays = [
            (final: prev: {
              unstable =
                inputs.nixpkgs-unstable.legacyPackages.${prev.system}; # Make available unstable channel.
              # pragmatapro = prev.callPackage ./nix/pkgs/pragmatapro.nix { };
              # zk = prev.callPackage ./nix/pkgs/zk.nix { source = inputs.zk; };
              next-prayer = prev.callPackage
                ./config/tmux/scripts/next-prayer/next-prayer.nix
                { };

              #pure-prompt = prev.pure-prompt.overrideAttrs (old: {
              #patches = (old.patches or [ ]) ++ [ ./nix/hosts/pure-zsh.patch ];
              #});
            })
            # fix for swift 8
            # https://github.com/NixOS/nixpkgs/issues/327836#issuecomment-2292084100
            (final: prev:
              let
                pkgsDarwin =
                  import inputs.darwin-nixpkgs { inherit (prev) system; };
              in
              prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
                inherit (pkgsDarwin) swift;
              })
            # nur.overlay
          ];
        };

        system.stateVersion =
          if pkgs.stdenv.isDarwin then
            4
          else
            "24.11"; # Did you read the comment?

        home-manager.users."${config.my.username}" = {
          home = {
            # Necessary for home-manager to work with flakes, otherwise it will
            # look for a nixpkgs channel.
            stateVersion =
              if pkgs.stdenv.isDarwin then
                "24.11"
              else
                config.system.stateVersion;
          };
        };
      };

      darwinConfigurations = mapHosts
        (host: system:
          (inputs.darwin.lib.darwinSystem {
            # This gets passed to modules as an extra argument
            specialArgs = { inherit inputs; };
            inherit system;
            modules = [
              inputs.home-manager.darwinModules.home-manager
              inputs.nix-homebrew.darwinModules.nix-homebrew
              ./nix/modules/darwin
              ./nix/modules/shared
              sharedConfiguration
              ./nix/hosts/${host}.nix
            ];
          }))
        darwinHosts;

      nixosConfigurations = mapHosts
        (host: system:
          (inputs.nixpkgs.lib.nixosSystem {
            # This gets passed to modules as an extra argument
            specialArgs = { inherit inputs; };
            inherit system;
            modules = [
              inputs.home-manager.nixosModules.home-manager
              ./nix/modules/shared
              sharedConfiguration
              ./nix/hosts/${host}
            ];
          }))
        linuxHosts;

      # @TODO: move the logic inside ./install here
      devShells = forAllSystems (system:
        let pkgs = inputs.nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            name = "dotfiles";
            buildInputs = with pkgs; [
              go
              gopls
              go-tools # goimports, staticcheck, etc...
            ];
            # shellHook = ''echo "hi"'';
          };
        });

    in
    {
      inherit darwinConfigurations nixosConfigurations;
    } // mapHosts
      # for convenience
      # nix build './#darwinConfigurations.pandoras-box.system'
      # vs
      # nix build './#pandoras-box'
      # Move them to `outputs.packages.<system>.name`
      (host: _: self.darwinConfigurations.${host}.system)
      darwinHosts;
}
