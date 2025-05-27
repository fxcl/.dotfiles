{ pkgs, lib, config, inputs, ... }:

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
          NODE_HOME = "${pkgs.nodejs_22}";
          NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
          # NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
          NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
          NPM_CONFIG_PREFIX = "$XDG_CACHE_HOME/npm";
          NODE_REPL_HISTORY = "$XDG_CACHE_HOME/node_repl_history";
          NODE_OPTIONS = "--dns-result-order=ipv4first --max-old-space-size=4096";
          # Allow 32³ entries; the default is 1000.
          NODE_REPL_HISTORY_SIZE = "32768";
          # Use sloppy mode by default, matching web browsers.
          NODE_REPL_MODE = "sloppy";

          NPM_CONFIG_EDITOR = "$EDITOR";
          NPM_CONFIG_INIT_AUTHOR_NAME = github_username;
          NPM_CONFIG_INIT_AUTHOR_EMAIL = email;
          NPM_CONFIG_INIT_AUTHOR_URL = website;
          NPM_CONFIG_INIT_LICENSE = "MIT";
          NPM_CONFIG_INIT_VERSION = "0.0.0";
          NPX_PROXY="http://127.0.0.1:2333";
        };

        # TODO gatsby-cli
        # TODO prettier-eslint-cli
        user = {
          packages = with pkgs; [
            nodejs_22
            nodePackages.npm
            nodePackages.bash-language-server
            nodePackages.dockerfile-language-server-nodejs
            nodePackages.javascript-typescript-langserver
            nodePackages.typescript-language-server
            # nodePackages.vue-language-server # Deprecated - use Volar instead
            nodePackages.yaml-language-server
            nodePackages.prettier
            nodePackages.typescript
            nodePackages.npm-check-updates
            # nodePackages.create-react-app # Deprecated - use a framework for React instead
            nodePackages.eslint
            nodePackages.eslint_d
            nodePackages.js-beautify
            nodePackages.mermaid-cli
            nodePackages.jsonlint
            nodePackages.yarn
            nodePackages.vscode-langservers-extracted # html, css, json, eslint

            # Task Runners
            nodePackages.grunt-cli
            nodePackages.gulp
            nodePackages.jake

            # Bundlers
            nodePackages.webpack
            nodePackages.browserify
            # nodePackages.rollup # Removed because it was broken
            # nodePackages.parcel-bundler # Removed because it was broken
          ];
        };

        hm.file."npmrc".text =
          "\n          registry=https://registry.npmjs.org\n          ELECTRON_MIRROR=https://npm.taobao.org/mirrors/electron/\n          ELECTRON_CUSTOM_DIR=16.0.5\n          disturl=https://npmmirror.com/dist/\n          sharp_binary_host=https://npmmirror.com/mirrors/sharp\n          sharp_libvips_binary_host=https://npmmirror.com/mirrors/sharp-libvips\n          profiler_binary_host_mirror=https://npmmirror.com/mirrors/node-inspector/\n          fse_binary_host_mirror=https://npmmirror.com/mirrors/fsevents\n          node_sqlite3_binary_host_mirror=https://npmmirror.com/mirrors\n          sqlite3_binary_host_mirror=https://npmmirror.com/mirrors\n          sqlite3_binary_site=https://npmmirror.com/mirrors/sqlite3\n          electron_mirror=https://npmmirror.com/mirrors/electron/\n          puppeteer_download_host=https://npmmirror.com/mirrors\n          chromedriver_cdnurl=https://npmmirror.com/mirrors/chromedriver\n          operadriver_cdnurl=https://npmmirror.com/mirrors/operadriver\n          phantomjs_cdnurl=https://npmmirror.com/mirrors/phantomjs\n          python_mirror=https://npmmirror.com/mirrors/python\n          sass_binary_site=https://npmmirror.com/mirrors/node-sass\n        ";
      };
    };
}
