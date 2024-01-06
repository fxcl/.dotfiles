{ pkgs, lib, config, ... }:

let

  cfg = config.my.modules.go;

in
{
  options = with lib; {
    my.modules.go = {
      enable = mkEnableOption ''
        Whether to enable go module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      my.env = rec {
        GOPATH = "$XDG_DATA_HOME/go";
        GOBIN = "${GOPATH}/bin";
        GOCACHE = "${GOPATH}/cache";
        GOROOT = "${pkgs.go_1_20}/share/go";
        GOPROXY = "https://goproxy.cn,direct";
        GO111MODULE = "on";
        # GOSUMDB = "goproxy.cn/sumdb/sum.golang.org";
        # GOSUMDB = "off";
      };

      my.user = {
        packages = with pkgs; [
          go_1_20
          godef
          gopls
          golint
          delve
          # go-outline
          # gopkgs
          # gotools
          # gotests
          # gomodifytags
          # go-migrate
        ];
      };
    };
}
