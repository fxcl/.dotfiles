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
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin"; # Default to stable for most things.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Unstable for some packages.

    # Home inputs
    homemanager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure versions are consistent.

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

    emacs.url = "github:cmacrae/emacs";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";

    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zk = {
      url = "github:mickael-menu/zk";
      flake = false;
    };

  };

  outputs = { self, ... }@inputs:
    let
      sharedHostsConfig = { config, pkgs, ... }: {
        nix = {
          package = pkgs.nixFlakes;

          extraOptions = ''
            experimental-features = nix-command flakes
          '';

          settings = {
            extra-trusted-substituters = [
              "https://nix-cache.status.im"
            ];

            substituters = [
              "https://mirror.sjtu.edu.cn/nix-channels/store"
              "https://mirrors.ustc.edu.cn/nix-channels/store"
              "https://cache.nixos.org"
              "https://nix-community.cachix.org"
              "https://nixpkgs.cachix.org"
              "https://statix.cachix.org"
              "https://cache.nixos.org"
              "https://nixpkgs.cachix.org"
            ];

            trusted-public-keys = [
              "nix-cache.status.im-1:x/93lOfLU+duPplwMSBR+OlY4+mo+dCN7n0mr4oPwgY="
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
          };


          gc = {
            automatic = true;
            options = "--delete-older-than 10d";
          };
        };

        nixpkgs = {
          config = { allowUnfree = true; };
          overlays = [
            (
              final: prev: {
                unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system}; # Make available unstable channel.
                # zk = prev.callPackage ./nix/pkgs/zk.nix { source = inputs.zk; };
              }
            )
            # nur.overlay
            inputs.rust-overlay.overlays.default
          ];
        };
      };

    in
    {

      darwinConfigurations = {
        tony = inputs.darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          inherit inputs;

          modules = [
            inputs.homemanager.darwinModules.home-manager
            inputs.agenix.nixosModules.age
            sharedHostsConfig
            ./nix/modules/shared
            ./nix/modules/darwin
            ./nix/hosts/tony
          ];
        };
        vvh = inputs.darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          inherit inputs;

          modules = [
            inputs.homemanager.darwinModules.home-manager
            inputs.agenix.nixosModules.age
            sharedHostsConfig
            ./nix/modules/shared
            ./nix/modules/darwin
            ./nix/hosts/vvh.nix

            ({ ... }: {
              # 使用 nixos-cn flake 提供的包
              # environment.systemPackages =
              #   [ nixos-cn.legacyPackages.x86_64-linux.netease-cloud-music ];
              # 使用 nixos-cn 的 binary cache
              nix.binaryCaches = [
                "https://nixos-cn.cachix.org"
                "https://hydra.iohk.io"
                "https://cachix.org/api/v1/cache/emacs"
              ];
              nix.binaryCachePublicKeys = [
                "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
                "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
                "emacs.cachix.org-1:b1SMJNLY/mZF6GxQE+eDBeps7WnkT0Po55TAyzwOxTY="
              ];
              nixpkgs.overlays = [
                inputs.emacs.overlay
              ];
              # imports = [
              #   # 将nixos-cn flake提供的registry添加到全局registry列表中
              #   # 可在`nixos-rebuild switch`之后通过`nix registry list`查看
              #   nixos-cn.nixosModules.nixos-cn-registries
              #   # 引入nixos-cn flake提供的NixOS模块
              #   nixos-cn.nixosModules.nixos-cn
              # ];
            })
          ];
        };
      };

      tony = self.darwinConfigurations.tony.system;
      vvh = self.darwinConfigurations.vvh.system;

      nixosConfigurations = {
        "nixos" = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            inputs.home-manager.nixosModules.home-manager
            ./nix/modules/shared
            sharedHostsConfig
            ./nix/hosts/nixos
          ];
        };
      };
    };
}
