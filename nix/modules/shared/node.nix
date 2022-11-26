{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.node;

in

{
  options = with lib; {
    my.modules.node = {
      enable = mkEnableOption ''
        Whether to enable nodejs module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      # workaround for now see https://github.com/NixOS/nixpkgs/issues/145634

      my = {
        env = with config.my; {
          NODE_HOME = "${pkgs.nodejs-18_x}";
          NODE_REPL_HISTORY = "$XDG_CACHE_HOME/node_repl_history";
          NPM_CONFIG_EDITOR = "$EDITOR";
          NPM_CONFIG_INIT_AUTHOR_NAME = github_username;
          NPM_CONFIG_INIT_AUTHOR_EMAIL = email;
          NPM_CONFIG_INIT_AUTHOR_URL = website;
          NPM_CONFIG_INIT_LICENSE = "MIT";
          NPM_CONFIG_INIT_VERSION = "0.0.0";
        };

        # TODO gatsby-cli
        # TODO prettier-eslint-cli
        user = {
          packages = with pkgs; [
            nodejs-18_x
            nodePackages.npm-check-updates
            nodePackages.create-react-app
            nodePackages.eslint
            nodePackages.eslint_d
            nodePackages.javascript-typescript-langserver
            nodePackages.webpack-cli
            nodePackages."@vue/cli"
            nodePackages.js-beautify
            nodePackages."@prisma/language-server"
            # nodePackages.bash-language-server
            # nodePackages.dockerfile-language-server-nodejs
            # nodePackages.yaml-language-server
            # nodePackages.vls
            # nodePackages.vim-language-server
            # nodePackages.pyright
            # nodePackages.svelte-language-server
            # haskellPackages.dhall-lsp-server
            # sumneko-lua-language-server
            # nodePackages.lerna
            # nodePackages.prisma
            # yarn
          ];
        };

        hm.file."npmrc".text = "
          registry=https://registry.npmmirror.com
          ELECTRON_MIRROR=https://npm.taobao.org/mirrors/electron/
          ELECTRON_CUSTOM_DIR=16.0.5
          disturl=https://npmmirror.com/dist/
        ";
      };

    };
}
