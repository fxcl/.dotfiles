# https://nixcloud.io/ - Nix syntax reference
# https://nix.dev/ - Nix development guide
# https://nixos.org/guides/nix-pills/ - Nix tutorial series
# https://nix-community.github.io/awesome-nix/ - Nix resource collection
# https://discourse.nixos.org/t/home-manager-equivalent-of-apt-upgrade/8424/3 - home-manager usage discussion
# https://www.reddit.com/r/NixOS/comments/jmom4h/new_neofetch_nixos_logo/gayfal2/ - NixOS related discussion
# https://www.youtube.com/user/elitespartan117j27/videos?view=0&sort=da&flow=grid - Nix video tutorials
# https://www.youtube.com/playlist?list=PLRGI9KQ3_HP_OFRG6R-p4iFgMSK1t5BHs - Nix video tutorial playlist
# https://www.reddit.com/r/NixOS/comments/k9xwht/best_resources_for_learning_nixos/ - Best resources for learning NixOS
# https://www.reddit.com/r/NixOS/comments/k8zobm/nixos_preferred_packages_flow/ - NixOS package management flow
# https://www.reddit.com/r/NixOS/comments/j4k2zz/does_anyone_use_flakes_to_manage_their_entire/ - Using flakes for configuration management
# https://serokell.io/blog/practical-nix-flakes - Practical Nix flakes guide
# https://stephank.nl/p/2023-02-28-using-flakes-for-nixos-configs.html - Using flakes for NixOS configuration
# https://zero-to-nix.com/ - Zero to Nix guide
{
  description = "NixOS and Darwin configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager inputs
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure versions are consistent
    };

    # MacOS inputs
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure versions are consistent
    };

    # NUR (Nix User Repository) inputs
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
        "alcantara" = "aarch64-darwin";
        "vvh" = "aarch64-darwin";
      };

      darwinSystems = inputs.nixpkgs.lib.unique (inputs.nixpkgs.lib.attrValues darwinHosts);

      linuxHosts = { "nixos" = "x86_64-linux"; };

      linuxSystems = inputs.nixpkgs.lib.unique (inputs.nixpkgs.lib.attrValues linuxHosts);

      forAllSystems = f: inputs.nixpkgs.lib.genAttrs (linuxSystems ++ darwinSystems) f;

      mapHosts = f: hostsMap: builtins.mapAttrs f hostsMap;

      sharedConfiguration = { config, pkgs, ... }: {
        system.configurationRevision = self.rev or self.dirtyRev or null;

        nix = {
          # @NOTE: for `nix-darwin` this will enable these old options `services.nix-daemon.enable` and `nix.configureBuildUsers'
          enable = true;
          # Disable channels since we are using flakes
          channel.enable = false;
          nixPath = {
            # Inherit input source paths
            inherit (inputs) nixpkgs;
            inherit (inputs) darwin;
            inherit (inputs) home-manager;
          };

          package = pkgs.nixVersions.stable;
          extraOptions = ''
            # Enable experimental features
            experimental-features = nix-command flakes
          '';

          settings = {
            # Set trusted users
            trusted-users = [ "@admin" ];
            # Enable experimental features list
            experimental-features = [ "nix-command" "flakes" ];

            # Additional trusted binary caches
            extra-trusted-substituters = [ "https://nix-cache.status.im" ];

            # Disabled on Darwin because of some buggy behavior: https://github.com/NixOS/nix/issues/7273
            # Auto-optimize store (disabled on Darwin)
            auto-optimise-store = !pkgs.stdenv.isDarwin;

            # Force set binary cache sources
            #substituters = pkgs.lib.mkForce [
            substituters = [
              "https://cache.garnix.io"
              https://mirrors.cernet.edu.cn/nix-channels/store
              #"https://mirror.sjtu.edu.cn/nix-channels/store" # Shanghai Jiao Tong University mirror
              #"https://mirrors.ustc.edu.cn/nix-channels/store" # USTC mirror
              "https://cache.nixos.org"
              #"https://nix-mirror.freetls.fastly.net" # Fastly CDN mirror
              "https://nix-community.cachix.org"
              "https://nixpkgs.cachix.org"
              "https://srid.cachix.org"
              "https://nix-linter.cachix.org"
              "https://statix.cachix.org"
            ];

            trusted-public-keys = [
              "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
              "nix-cache.status.im-1:x/93lOfLU+duPplwMSBR+OlY4+mo+dCN7n0mr4oPwgY="
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
              "srid.cachix.org-1:MTQ6ksbfz3LBMmjyPh0PLmos+1x+CdtJxA/J2W+PQxI="
              "nix-linter.cachix.org-1:BdTne5LEHQfIoJh4RsoVdgvqfObpyHO5L0SCjXFShlE="
              "statix.cachix.org-1:Z9E/g1YjCjU117QOOt07OjhljCoRZddiAm4VVESvais="
            ];
            # Recommended settings when using `direnv` etc.
            # Keep derivations and outputs to speed up environment loading
            keep-derivations = true;
            keep-outputs = true;
          };

          # Garbage collection configuration
          gc = {
            automatic = true; # Automatically run garbage collection
            options = "--delete-older-than 10d"; # Delete files older than 10 days
          };

          # Store optimization configuration
          optimise = {
            # Enable store optimization on macOS because we can't set `auto-optimise-store` to true on macOS
            automatic = pkgs.stdenv.isDarwin;
          };
        };

        fonts = {
          # Font directory configuration
          # fontDir.enable = true;
          # Font packages configuration
          packages = with pkgs;
            [ ] ++ (lib.optionals pkgs.stdenv.isLinux [
              # Only install these fonts on Linux
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
          # Allow unfree software
          config = {
            allowUnfree = true;
            allowUnfreePredicate =
              pkg:
              builtins.elem (pkgs.lib.getName pkg) [
                "broadcom-sta"
                "copilot-language-server"
                "steam"
                "steam-original"
                "steam-run"
                "steam-unwrapped"
              ];
          };
          overlays = [
            (final: prev: {
              # Make unstable version of nixpkgs available
              unstable =
                inputs.nixpkgs-unstable.legacyPackages.${prev.system};
              # Custom package configurations
              # pragmatapro = prev.callPackage ./nix/pkgs/pragmatapro.nix { };
              # zk = prev.callPackage ./nix/pkgs/zk.nix { source = inputs.zk; };
              next-prayer = prev.callPackage
                ./config/tmux/scripts/next-prayer/next-prayer.nix
                { };
              # Modify pure-prompt package, apply custom patch
              pure-prompt = prev.pure-prompt.overrideAttrs (old: {
                patches = (old.patches or [ ]) ++ [ ./nix/hosts/pure-zsh.patch ];
              });
            })
            # Swift 8 fix
            # Reference: https://github.com/NixOS/nixpkgs/issues/327836#issuecomment-2292084100
            (final: prev:
              let
                pkgsDarwin =
                  import inputs.darwin-nixpkgs { inherit (prev) system; };
              in
              prev.lib.optionalAttrs prev.stdenv.hostPlatform.isDarwin {
                inherit (pkgsDarwin) swift;
              })
            # Fish shell configuration modification
            (final: prev: {
              fish = prev.fish.overrideAttrs (old: {
                doCheck = false; # Disable tests
              });
            })
            # re2 regular expression library configuration modification
            (final: prev: {
              re2 = prev.re2.overrideAttrs (old: {
                doCheck = false; # Disable tests, fix build timeout issues
              });
            })
            (final: prev: {
              python3Packages = prev.python3Packages // {
                hypothesis = prev.python3Packages.hypothesis.overrideAttrs (old: {
                  version = "6.111.0";
                });
              };
            })
            # Node.js configuration modification - disable tests to fix build failures
            (final: prev: {
              nodejs_24 = prev.nodejs_24.overrideAttrs (old: {
                doCheck = false; # Disable tests to prevent build failures
              });
              nodejs_22 = prev.nodejs_22.overrideAttrs (old: {
                doCheck = false; # Disable tests to prevent build failures
              });
            })
            (final: prev: {
              zimfw = prev.zimfw.overrideAttrs (oldAttrs: rec {
                version = "1.15.0";
                src = prev.fetchFromGitHub {
                  owner = "zimfw";
                  repo = "zimfw";
                  rev = "v${version}";
                  ## zim only needs this one file to be installed.
                  sparseCheckout = [ "zimfw.zsh" ];
                  sha256 = "sha256-8GnxUhBvMy7fhDILDKYEf/9Mhgzz7suaiZ5elRZmT0o=";
                };
              });
            })
            # nur.overlay
          ];
        };

        system.stateVersion =
          if pkgs.stdenv.isDarwin then
            4
          else
            "25.05"; # Did you read the comment?

        home-manager.users."${config.my.username}" = {
          home = {
            # Necessary for home-manager to work with flakes, otherwise it will
            # look for a nixpkgs channel.
            stateVersion =
              if pkgs.stdenv.isDarwin then
                "25.05"
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
              sharedConfiguration
              inputs.home-manager.darwinModules.home-manager
              ./nix/modules/darwin
              ./nix/modules/shared
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
              sharedConfiguration
              inputs.home-manager.nixosModules.home-manager
              ./nix/modules/shared

            ];
          }))
        linuxHosts;

      formatter = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
        in
        pkgs.alejandra
      );
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
              gomodifytags
              gotools # goimports
              typos
              typos-lsp
              alejandra
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
