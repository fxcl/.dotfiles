{ config, pkgs, lib, inputs, ... }: {

  my = {
    username = "kelvin";
    email = "me@gnux.cn";
    website = "https://miro.com";
    modules = {
      macos.enable = true;
      kotlin.enable = true;
      gpg.enable = true;
    };
  };

  networking = {
    hostName = "vvh";
    computerName = "Lcfijvvh";
  };
  # enable sudo authentication with Touch ID
  # security.pam.enableSudoTouchIdAuth = true;

  nix = {
    gc = { user = config.my.username; };
  };

  my.user = {
    packages = with pkgs; [
      emacs
    ];
  };
  system.stateVersion = 4;
}
