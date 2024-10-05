{ lib, config, ... }:

let

  cfg = config.my.modules.rust;

in
{
  options = with lib; {
    my.modules.rust = {
      enable = mkEnableOption ''
        Whether to enable rust module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      my.env = {
        # RUST_SRC_PATH = "$(rustc --print sysroot) /lib/rustlib/src/rust/library";
        RUSTUP_DIST_SERVER = "https://rsproxy.cn";
        RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
        RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
        CARGO_HOME = "$XDG_DATA_HOME/cargo";
        CARGO_TARGET_DIR = "$XDG_DATA_HOME/cargo/cache";
      };
    };
}
