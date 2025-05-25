{ pkgs, lib, config, options, ... }:

{
  # nix-daemon and build users are now managed unconditionally when nix.enable is on
  # services.nix-daemon.enable and nix.configureBuildUsers options have been removed

  homebrew.enable = true;
  #homebrew.autoUpdate = true;
  #homebrew.cleanup = "zap"; # "none" "uninstall" "zap"
  homebrew.global.brewfile = true; # Run brew bundle from anywhere
  homebrew.global.lockfiles = false; # Don't save lockfile (since running from anywhere)
  homebrew.onActivation.cleanup = "zap"; # Uninstall all programs not declared
  homebrew.onActivation.autoUpdate = false; # Don't update during rebuild
  homebrew.onActivation.upgrade = true;

  imports = [
    ./macos.nix
    ./dock.nix
    ./finder.nix
  ];

  my.modules = {
    macos.enable = lib.mkDefault true;
    dock.enable = lib.mkDefault false;
    finder.enable = lib.mkDefault false;
  };
}
