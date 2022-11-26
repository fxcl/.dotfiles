{ pkgs, inputs, system, lib, ... }:

let
  username = "kelvin";
  fullname = "Kelvin Zhao";

in

{

  my = {
    username = "${username}";

    modules = {
      dock = {
        enable = true;

        entries = [
          { path = "/System/Applications/Launchpad.app";  }
          { path = "/Applications/iTerm.app"; }
          { path = "/Applications/Google Chrome.app"; }
          { path = "/System/Applications/Mail.app"; }
          { path = "${pkgs.vscodium}/Applications/Visual Studio Code.app"; }
          {
            path = "/Users/${username}/Downloads/";
            section = "others";
            options = "--sort dateadded --view grid --display folder";
          }
        ];
      };

      finder = {
        enable = true;

        entries = [
          { path = "/Users/${username}"; alias = "Home"; }
          { path = "/Applications"; alias = "Applications"; }
          { path = "/Users/${username}/Desktop"; alias = "Desktop"; }
          { path = "/Users/${username}/Downloads"; alias = "Downloads"; }
          { path = "/Users/${username}/Developer"; alias = "Developer"; }
          { path = "/Users/${username}/ownCloud"; alias = "ownCloud"; }
          { path = "/Users/${username}/workspace"; alias = "workspace"; }
        ];
      };

      rust = {
        enable = true;
      };
    };
  };

  users = {
    users = {
      "${username}" = {
        description = "${fullname}";
        shell = pkgs.zsh;
        home = "/Users/${username}";
      };
    };
  };

  home-manager.users."${username}" = { config, ... }: {
    home = {
      homeDirectory = "/Users/${username}";

      sessionPath = [
        "$HOME/.local/bin"
      ];
    };

    programs = {
      home-manager.enable = true;

      alacritty = import ./programs/alacritty.nix { inherit pkgs; };
      dircolors = import ./programs/dircolors.nix { inherit pkgs; };
      # direnv = import ./programs/direnv.nix { inherit pkgs; };
      # fzf = import ./programs/fzf.nix { inherit pkgs; };
      lsd = import ./programs/lsd.nix { inherit pkgs; };
      octant = import ./programs/octant.nix { inherit pkgs; };
      readline = import ./programs/readline.nix { inherit pkgs; };
      # zsh = import ./programs/zsh.nix { inherit pkgs; };
      zathura = import ./programs/zathura.nix { inherit pkgs; };
    };
  };
}
