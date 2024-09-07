{ pkgs, lib, config, ... }:

let

  cfg = config.my.modules.go;

in {
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
        GOROOT = "${pkgs.go_1_22}/share/go";
        GOPROXY = "https://goproxy.cn,direct";
        GO111MODULE = "on";
        # GOSUMDB = "goproxy.cn/sumdb/sum.golang.org";
        # GOSUMDB = "off";
      };

      # all tools from https://github.com/golang/vscode-go/blob/ed92a0c250e8941abb9adab973c129a263ba1e41/src/goToolsInformation.ts
      my.user = {
        packages = with pkgs;
          [
            # go_1_22
            # godef
            # gopls
            # golint
            # delve # dlv
            # go-outline
            # gopkgs
            # gotools # staticcheck
            # gotools # goimports
            # gotests
            # gomodifytags
            # go-migrate
          ];
      };
    };
}
