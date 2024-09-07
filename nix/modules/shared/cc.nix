# nix/modules/shared/cc.nix
#
# I like C. I tolerate C++. I like++ C with a few choice C++ features tacked on.
# Liking C/C++ seems to be an unpopular opinion, so it's my guilty secret.
# Don't tell anyone pls.

{ pkgs, lib, config, options, ... }:

let cfg = config.my.modules.cc;

in {
  options = with lib; {
    my.modules.cc = {
      enable = mkEnableOption ''
        Whether to enable cc module
      '';
    };
  };
  #
  # I like C. I tolerate C++. I like++ C with a few choice C++ features tacked on.
  # Liking C/C++ seems to be an unpopular opinion, so it's my guilty secret.
  # Don't tell anyone pls.
  config = with lib;
    mkIf cfg.enable {
      my = {
        user.packages = with pkgs; [
          clang # A C compiler frontend for LLVM.
          #clang-tools
          gcc-unwrapped
          cmake # Yo dawg, I heard you like Make.
          llvmPackages.libcxx # When GCC has become too bloated for someone's taste.

          # Respect XDG, damn it!
          ccls # Language server

          boost
          gnumake

          #lldb
          #gcc # A compiler toolchain.
          #tinycc # A tiny c compiler

        ];
      };
    };
}
