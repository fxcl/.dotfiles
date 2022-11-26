{ pkgs, lib, config, options, ... }:

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
        RUSTUP_DIST_SERVER = "https://rsproxy.cn";
        RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup";
        RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
        CARGO_HOME = "$XDG_DATA_HOME/cargo";
      };
      my.user = {
        packages = with pkgs; [
          (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
          # rls
          # rust-analyzer
          # rust-bin.nightly.latest."rust-analyzer-preview"
          # cargo-bloat
          # cargo-watch
          # evcxr
          # cargo-msrv
          # cargo-deny
          # cargo-expand
          # cargo-bloat
          # cargo-fuzz
          # gitlint

          # rustup rustc cargo
          # rust-analyzer-unwrapped
          (writeScriptBin "rust-doc" ''
            #! ${stdenv.shell} -e
            exec ${pkgs.firefox-mac}/Applications/Firefox.app/Contents/MacOS/firefox "${rustc.doc}/share/doc/rust/html/index.html"
          '')
        ];
      };

      my.hm.file = {
        ".cargo/config" = {
          text = ''
            [alias]
            i = "init"
            nb = "new --bin"
            nl = "new --lib"

            r = "run"
            rr = "run --release"
            re = "run --example"
            rer = "run --release --example"

            b = "build"
            br = "build --release"
            be = "build --example"
            ber = "build --release --example"

            c = "check"
            cl = "clean"
            clp = "clippy --manifest-path=Cargo.toml --all-targets -- -D warnings"
            d = "doc"
            do = "doc --open"
            t = "test"
            ben = "bench"
            u = "update"
            s = "search"
            p = "publish"
            in = "install"
            un = "uninstall"
            h = "--help"
            f = "fmt"
            ls = "--list"
          '';
        };
      };
    };
}
