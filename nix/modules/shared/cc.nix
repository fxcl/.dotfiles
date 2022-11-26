{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.cc;

in

{
  options = with lib; {
    my.modules.cc = {
      enable = mkEnableOption ''
        Whether to enable cc module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      my = {
        user.packages = with pkgs; [
          gdb # GNU Debugger.
          ccls # Language server
          cmake # Yo dawg, I heard you like Make.
          boost
          gnumake
          gcc-unwrapped
          #clang # A C compiler frontend for LLVM.
          #clang-tools
          #lldb
          #gcc # A compiler toolchain.
          #tinycc # A tiny c compiler
          #llvmPackages.libcxx # When GCC has become too bloated for someone's taste.
        ];
      };
    };
}
