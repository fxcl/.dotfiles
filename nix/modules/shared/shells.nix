{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.shells;
  inherit (config.my.user) home;
  inherit (config.my) hm;
  inherit (config.my) hostConfigHome;

  local_zshrc = "${hostConfigHome}/zshrc";

  darwinPackages = with pkgs; [ openssl gawk gnused coreutils findutils ];
  nixosPackages = with pkgs; [ dwm dmenu xclip ];

in
{
  options = with lib; {
    my.modules.shells = {
      enable = mkEnableOption ''
        Whether to enable shells module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable (mkMerge [
      (if (builtins.hasAttr "launchd" options) then {
        launchd.user.agents."ui-mode-notify" = {
          serviceConfig = {
            ProgramArguments = [
              "${home}/.config/zsh/bin/ui-mode-notify"
              "${pkgs.zsh}/bin/zsh"
              "-c"
              "change-background"
            ];
            KeepAlive = true;
            StandardOutPath = "${home}/Library/Logs/ui-mode-notify-output.log";
            StandardErrorPath = "${home}/Library/Logs/ui-mode-notify-error.log";
          };
        };
      } else
        {
          # systemd
        })
      {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment = {
          shells = [ pkgs.bashInteractive pkgs.zsh ];
          variables = {
            # NOTE: Darwin doesn't set them by default, unlike NixOS. So we have to set them.
            # This is just using what's inside home-manager. Defaults are here
            # https://github.com/nix-community/home-manager/blob/a4b0a3faa4055521f2a20cfafe26eb85e6954751/modules/misc/xdg.nix#L14-L17
            XDG_CACHE_HOME = hm.cacheHome;
            XDG_CONFIG_HOME = hm.configHome;
            XDG_DATA_HOME = hm.dataHome;
            XDG_STATE_HOME = hm.stateHome;
            XDG_BIN_HOME = hm.binHome;

            #XDG_RUNTIME_DIR = "${home}/.local/run";
            PYTHON_BUILD_MIRROR_URL =
              "https://pyenv-mirror.vercel.app/api/pythons/";

            M2_HOME = "$XDG_CACHE_HOME/maven";
            NIX_PAGER = "less --RAW-CONTROL-CHARS --quit-if-one-screen";

            HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.ustc.edu.cn/brew.git";
            HOMEBREW_CORE_GIT_REMOTE =
              "https://mirrors.ustc.edu.cn/homebrew-core.git";
            HOMEBREW_BOTTLE_DOMAIN =
              "https://mirrors.ustc.edu.cn/homebrew-bottles";
            HOMEBREW_INSTALL_CLEANUP = "1";
            HOMEBREW_NO_INSECURE_REDIRECT = "1";
            HOMEBREW_NO_ANALYTICS = "1";
            # HOMEBREW_CASK_OPTS=--require-sha
            # HOMEBREW_CASK_OPTS = "";
            # HOMEBREW_INSTALL_BADGE = "🍵";

            HOST_CONFIGS = "${hostConfigHome}";

            # https://github.blog/2022-04-12-git-security-vulnerability-announced/
            GIT_CEILING_DIRECTORIES = builtins.dirOf home;

          };
          systemPackages = with pkgs;
            (if stdenv.isDarwin then darwinPackages else nixosPackages) ++ [
              curl
              wget
              cachix
              htop
              fzf
              direnv
              nix-zsh-completions
              zsh
              zoxide
              # rsync
            ];
        };

        my = {
          user = {
            shell = pkgs.zsh;
            packages = with pkgs; [
              nixfmt-classic
              tealdeer # rust implementation of `tldr`
              bat
              fd
              ripgrep
              pastel
              vivid
              hyperfine
              jq
              #grc
              pure-prompt
              lsd
              shellcheck
              shfmt # Doesn't work with zsh, only sh & bash
              #lnav # System Log file navigator
              pandoc
              scc
              tokei
              #_1password # CLI
              # docker
              rename
              glow
              # buku
              graph-easy
              graphviz
              difftastic
              vale
              entr
              ffmpeg
              # ttfautohint
            ];
          };

          hm.file = with config.my;
            let

              glow_config = ''
                # ${nix_managed}
                # style name or JSON path (default "auto")
                style: "auto"
                # show local files only; no network (TUI-mode only)
                local: true
                # mouse support (TUI-mode only)
                mouse: false
                # use pager to display markdown
                pager: true
                # word-wrap at width
                width: 80'';

            in
            lib.mkMerge [
              (if pkgs.stdenv.isDarwin then {
                "Library/Preferences/glow/glow.yml".text = glow_config;
              } else {
                ".config/glow/glow.yml".text = glow_config;
              })

              {
                ".ssh/config" = { source = ../../../config/ssh/config; };
                ".config/zsh" = {
                  recursive = true;
                  source = ../../../config/zsh.d/zsh;
                };
                ".terminfo" = {
                  recursive = true;
                  source = ../../../config/.terminfo;
                };
                ".config/vale" = {
                  recursive = true;
                  source = ../../../config/vale;
                };
                ".vale.ini" = { source = ../../../config/.vale.ini; };
                ".config/VSCodium" = {
                  recursive = true;
                  source = ../../../config/VSCodium;
                };
                ".config/goneovim/settings.toml" = {
                  source = ../../../config/goneovim/settings.toml;
                };
                ".config/mods/mods.yml" = {
                  source = ../../../config/mods/mods.yml;
                };
                ".config/zsh/.zimrc" = { source = ../../../config/.zimrc; };
              }
            ];

          env =
            # ====================================================
            # This list gets set in alphabetical order.
            # So care needs to be taken if two env vars depend on each other
            # ====================================================
            rec {
              BROWSER = if pkgs.stdenv.isDarwin then "open" else "xdg-open";
              GITHUB_USER = config.my.github_username;

              VIM_FZF_LOG = ''
                "$(${pkgs.git}/bin/git config --get alias.l 2>/dev/null | awk '{$1=""; print $0;}' | tr -d '\r')"'';

              FZF_DEFAULT_COMMAND = "${FZF_CTRL_T_COMMAND} --type f";
              # https://github.com/sharkdp/bat/issues/634#issuecomment-524525661
              FZF_PREVIEW_COMMAND =
                "COLORTERM=truecolor ${pkgs.bat}/bin/bat --style=changes --wrap never --color always {} || cat {} || (${pkgs.lsd}/bin/lsd --tree --group-directories-first {} || ${pkgs.tree}/bin/tree -C {})";
              FZF_CTRL_T_COMMAND =
                "${pkgs.fd}/bin/fd --hidden --follow --no-ignore-vcs";
              FZF_ALT_C_COMMAND = "${FZF_CTRL_T_COMMAND} --type d .";
              FZF_DEFAULT_OPTS =
                "--border --prompt='» ' --pointer='▶' --marker='✓ ' --reverse --tabstop 2 --multi --color=bg+:-1,marker:010 --separator='' --bind '?:toggle-preview'";
              FZF_CTRL_T_OPTS =
                "--preview '(${FZF_PREVIEW_COMMAND}) 2> /dev/null' --preview-window down:60%";
              FZF_CTRL_R_OPTS =
                "--preview 'echo {}' --preview-window down:3:wrap:hidden --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard'";
              FZF_ALT_C_OPTS =
                "--preview '(${pkgs.lsd}/bin/lsd --tree --group-directories-first {} || ${pkgs.tree}/bin/tree -C {}) 2> /dev/null'";
            };

        };

        # TODO: look at this later, because it's ugly
        system.activationScripts.postUserActivation.text = ''
          echo ":: -> Running shell activationScript..."
          # Creating needed folders
         if [ ! -e "${local_zshrc}" ]; then
          mkdir -p "$(dirname "${local_zshrc}")"
          {
              echo '# vim:ft=zsh:'
              echo "[[ -z \"\$GITHUB_TOKEN\" ]] && echo \"⚠ GITHUB_TOKEN is not set\""
              echo "[[ -z \"\$HOMEBREW_GITHUB_API_TOKEN\" ]] && echo \"⚠ HOMEBREW_GITHUB_API_TOKEN is not set\""
              echo "[[ -z \"\$WEECHAT_PASSPHRASE\" ]] && echo \"⚠ WEECHAT_PASSPHRASE is not set\""
              echo "[[ -z \"\$NPM_REGISTRY_TOKEN\" ]] && echo \"⚠ NPM_REGISTRY_TOKEN is not set\""
              echo "[[ -z \"\$GITHUB_REGISTRY_TOKEN\" ]] && echo \"⚠ GITHUB_REGISTRY_TOKEN is not set\""
              echo "[[ -z \"\$GH_PASS\" ]] && echo \"⚠ GH_PASS is not set\""
          } > "${local_zshrc}"
        fi



        '';

        programs.zsh = {
          enable = true;
          enableCompletion = true;

          ########################################################################
          # Instead of sourcing, I can read the files & save startiup time instead
          ########################################################################

          # zshenv
          shellInit = lib.concatStringsSep "\n"
            (map builtins.readFile [ ../../../config/zsh.d/.zshenv ]);

          # zshrc
          interactiveShellInit = lib.concatStringsSep "\n" [
            (lib.concatStringsSep "\n" (map builtins.readFile [
              ../../../config/zsh.d/zsh/config/options.zsh
              ../../../config/zsh.d/zsh/config/input.zsh
              ../../../config/zsh.d/zsh/config/completion.zsh
              ../../../config/zsh.d/zsh/config/fzf-preview.zsh
              ../../../config/zsh.d/zsh/config/utility.zsh
              ../../../config/zsh.d/zsh/config/aliases.zsh
              #"${pkgs.grc}/etc/grc.zsh"
              "${pkgs.fzf}/share/fzf/completion.zsh"
              "${pkgs.fzf}/share/fzf/key-bindings.zsh"
              ../../../config/zsh.d/.zshrc
            ]))
            "fpath+=${pkgs.pure-prompt}/share/zsh/site-functions"
          ];

          promptInit = "autoload -U promptinit; promptinit; prompt pure";
        };
      }
    ]);
}
