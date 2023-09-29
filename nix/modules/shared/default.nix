{ pkgs, lib, config, options, ... }:

{

  imports = [
    ./settings.nix
    ./nix.nix
    ./shells.nix
    ./sudoers.nix
    ./lf.nix
     ./starship.nix
    # ./fonts.nix
    ./gui.nix
    ./git.nix
    ./gpg.nix
    ./vim.nix
    ./java.nix
    ./node.nix
    ./go.nix
    ./cc.nix
    ./kube.nix
    ./python.nix
    ./vscode.nix
    ./zk.nix
    ./emacs.nix
    ./rust.nix

  ];

  my.modules = {
    nix.enable = lib.mkDefault true;
    shells.enable = lib.mkDefault true;
    sudoers.enable = lib.mkDefault true;
    lf.enable = lib.mkDefault true;
    starship.enable = lib.mkDefault true;
    # fonts.enable = lib.mkDefault true;
    gui.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    gpg.enable = lib.mkDefault true;
    vim.enable = lib.mkDefault true;
    java.enable = lib.mkDefault true;
    node.enable = lib.mkDefault false;
    go.enable = lib.mkDefault true;
    cc.enable = lib.mkDefault true;
    kube.enable = lib.mkDefault false;
    python.enable = lib.mkDefault false;
    vscode.enable = lib.mkDefault true;
    zk.enable = lib.mkDefault true;
    emacs.enable = lib.mkDefault true;
    rust.enable = lib.mkDefault true;
  };
}
