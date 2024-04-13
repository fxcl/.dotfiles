{ pkgs, lib, config, options, ... }:

let cfg = config.my.modules.vscode;

in {
  options = with lib; {
    my.modules.vscode = {
      enable = mkEnableOption ''
        Whether to enable vscode module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      my.hm.programs.vscode = {
        enable = true;
        # enableUpdateCheck = false;
        # enableExtensionUpdateCheck = true;
        mutableExtensionsDir = true;
        package = pkgs.vscodium;
        # Notes:
        # - Does not unistall extensions once removed.
        # - Update using the following: export temp=$(mktemp) && curl -s https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/applications/editors/vscode/extensions/update_installed_exts.sh  > $temp && chmod +x $temp && $temp $(whereis codium)
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vscode-extensions/default.nix
        extensions = with pkgs.vscode-extensions;
          let
            lib = pkgs.lib;
            vitesse-theme = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "theme-vitesse";
                publisher = "antfu";
                version = "0.6.4";
                sha256 = "sha256-6nIzHJsLsIG3O6p97Q+YdDKxHj7r+pEwiq0UbJ/vlf4=";
              };
              meta = with pkgs.lib; {
                description = "Vitesse theme for VS Code";
                downloadPage =
                  "https://marketplace.visualstudio.com/items?itemName=antfu.theme-vitesse";
                homepage = "no";
                license = licenses.mit;
              };
            };

            vscode-jest = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "vscode-jest";
                publisher = "orta";
                version = "5.2.3";
                sha256 = "sha256-cPHwBO7dI44BZJwTPtLR7bfdBcLjaEcyLVvl2Qq+BgE=";
              };
              meta = with pkgs.lib; {
                description =
                  "This extension provides an extensible user interface for running your tests in VS Code. It can be used with any testing framework if there is a corresponding Test Adapter extension.";
                downloadPage =
                  "https://marketplace.visualstudio.com/items?itemName=hbenl.vscode-test-explorer";
                homepage = "no";
                license = licenses.mit;
              };
            };
          in
          [
            vitesse-theme
            antfu.icons-carbon
            github.github-vscode-theme
            github.copilot
            github.copilot-chat
            github.vscode-pull-request-github
            bbenoist.nix
            brettm12345.nixfmt-vscode
            arrterian.nix-env-selector

            streetsidesoftware.code-spell-checker

            matklad.rust-analyzer
            a5huynh.vscode-ron
            serayuzgur.crates
            tamasfe.even-better-toml
            # vadimcn.vscode-lldb
            ms-python.python
            redhat.vscode-yaml
            justusadam.language-haskell
            dhall.dhall-lang
            dhall.vscode-dhall-lsp-server
            haskell.haskell
            dbaeumer.vscode-eslint
            timonwong.shellcheck
            christian-kohler.path-intellisense
            # Languages
            #scalameta.metals # Scala Language Server
            #scala-lang.scala # Scala Language
            llvm-vs-code-extensions.vscode-clangd
            arrterian.nix-env-selector
            dracula-theme.theme-dracula
            xaver.clang-format
            foxundermoon.shell-format
            #tomoki1207.pdf
            #file-icons.file-icons
            #b4dm4n.nixpkgs-fmt
            #kamadorueda.alejandra
            #ms-azuretools.vscode-docker
            #ms-kubernetes-tools.vscode-kubernetes-tools
            #ms-python.vscode-pylance
            #foam.foam-vscode
            #formulahendry.auto-close-tag
            #msjsdiag.debugger-for-chrome
            octref.vetur
            shardulm94.trailing-spaces
            golang.go
            editorconfig.editorconfig
            mikestead.dotenv

            yzhang.markdown-all-in-one
            ibm.output-colorizer
            ms-python.vscode-pylance
            humao.rest-client
            #hashicorp.terraform
            #james-yu.latex-workshop
            #nash.awesome-flutter-snippets
            #github.vscode-codeql
            #ms-vscode.cpptools
            #dzhavat.css-initial-value
            #dart-code.dart-code
            #dart-code.flutter
            #icrawl.discord-vscode
            #zignd.html-css-class-completion
            #mathiasfrohlich.kotlin
            #alefragnani.pascal
            #alefragnani.pascal-formatter
            #jeroen-meijer.pubspec-assist
            #msjsdiag.vscode-react-native
            #matklad.rust-analyzer-nightly
            #svelte.svelte-vscode
            #pflannery.vscode-versionlens
            bradlc.vscode-tailwindcss
          ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              # https://www.vsixhub.com/vsix/73731/
              name = "gruvbox-material-icon-theme";
              publisher = "jonathanharty";
              version = "1.1.5";
              sha256 =
                "f3a51652e58a4fa69dc78870e0e270ddc499c5664a2c7e2e2d33be4ac83be606";
            }
            {
              name = "aws-toolkit-vscode";
              publisher = "AmazonWebServices";
              version = "1.36.0";
              sha256 = "sha256-6Ylti3x+XZAzE+sb7s7p+nepvqwer+9qbuHlp+1H+UQ=";
            }
            {
              # https://www.vsixhub.com/vsix/1950/
              name = "liveserver";
              publisher = "ritwickdey";
              version = "5.7.9";
              sha256 =
                "c3409848439d96dc0c1739b96613b14abc6a435cb8fa02df07c2fe105160cc37";
            }
            {
              # https://www.vsixhub.com/vsix/32677/
              name = "tauri-vscode";
              publisher = "tauri-apps";
              version = "0.2.6";
              sha256 =
                "3bd37115e99482df579a12fa067340ae4a9b08db4782e49bbd5398c254f4ce0e";
            }

            {
              name = "gruvbox-themes";
              publisher = "tomphilbin";
              version = "1.0.0";
              sha256 = "0xykf120j27s0bmbqj8grxc79dzkh4aclgrpp1jz5kkm39400z0f";
            }
            {
              # https://www.vsixhub.com/vsix/1963/
              name = "rewrap";
              publisher = "stkb";
              version = "17.8.0";
              sha256 = "1y168ar01zxdd2x73ddsckbzqq0iinax2zv3d95nhwp9asjnbpgn";
            }
            {
              # https://www.vsixhub.com/vsix/82111/
              name = "better-cpp-syntax";
              publisher = "jeff-hykin";
              version = "1.15.10";
              sha256 =
                "ee133551ada2f575d9f9d6ce08b73ab13abdda9f2a67391a3e1031afa70b148c";
            }
            {
              #  https://www.vsixhub.com/vsix/88224/
              name = "remote-containers";
              publisher = "ms-vscode-remote";
              version = "0.232.5";
              sha256 =
                "1e7763b7ad771339ed5ce02e0f1684a8ee98f97b935c3b2b5400d491fdc164db";
            }

            {
              # https://www.vsixhub.com/vsix/84687/
              publisher = "tal7aouy";
              name = "rainbow-bracket";
              version = "1.0.2";
              sha256 =
                "1f427d661cc7a49f7a7d6ec3ad5aa903db6a0202f670598cf56bbd493bb53146";
            }
            {
              # https://www.vsixhub.com/vsix/29718/
              name = "better-toml";
              publisher = "bungcip";
              version = "0.19.2";
              sha256 =
                "24a8fa9e88b67537b4d8fc57fe44b5d7b6615bcbbb0618f8428c1942224a3f61";
            }
            {
              # https://www.vsixhub.com/vsix/31169/
              name = "vscode-gitignore-generator";
              publisher = "piotrpalarz";
              version = "1.0.3";
              sha256 =
                "7aa3639285d791c6ed303af69dd4e1a90daa4453f0d6e7108ba86fd1e081c379";
            }
            {
              # https://www.vsixhub.com/vsix/47/
              name = "prettier-vscode";
              publisher = "esbenp";
              version = "10.1.0";
              sha256 =
                "490b9fd7926af3830a055a8ae94be22b4e2ea3b810c3dcaec3f5840445dc4007";
            }
            {
              # https://www.vsixhub.com/vsix/4151/
              name = "vscode-test-explorer";
              publisher = "hbenl";
              version = "2.21.1";
              sha256 = "022lnkq278ic0h9ggpqcwb3x3ivpcqjimhgirixznq0zvwyrwz3w";
            }
            {
              # https://www.vsixhub.com/vsix/3846/
              name = "restructuredtext";
              publisher = "lextudio";
              version = "190.1.16";
              sha256 =
                "69dfb402e1d99f2f49740af52d32dd38b918a477392cf444835b3d35e5b4c1f4";
            }
            {
              name = "vsls-pomodoro";
              publisher = "lostintangent";
              version = "0.1.0";
              sha256 = "1b73zbkhlhacvi18cx4g3n6randy3hw9cab1gkw5gzb3375w7w3p";
            }
            {
              name = "vsls-whiteboard";
              publisher = "lostintangent";
              version = "0.0.12";
              sha256 = "13xyi2bd4c4jfmad9bzjgvj60mrahdmfs1h2xsgiv286vpq6pk4a";
            }
            {
              # https://www.vsixhub.com/vsix/129709/
              name = "rainbow-csv";
              publisher = "mechatroner";
              version = "3.8.0";
              sha256 =
                "4a9951332452093a711c339be8641dd2a24abe78bb53e45c6ede198241d0232b";
            }
            {
              name = "nunjucks";
              publisher = "ronnidc";
              version = "0.3.1";
              sha256 = "0dlsri0dcligjz3x1ddpjhyvna6dmdswhb86c9k73y22r12fd1zd";
            }
            {
              # https://www.vsixhub.com/vsix/8048/
              name = "vscode-lldb";
              publisher = "vadimcn";
              version = "1.10.0";
              sha256 =
                "4402afec44b0d071bf6af04e3c4d424ebd131ec07b516c7485a25577f0e6f468";
            }
            # {
            #   # https://www.vsixhub.com/vsix/573/
            #   name = "elm-ls-vscode";
            #   publisher = "elmTooling";
            #   version = "2.7.2";
            #   sha256 = "dfc7cb78c466c8ec2f84962881d521fdf89de6a014b5d11760ca662fedb56f46";
            # }
            # {
            #   name = "cmake";
            #   publisher = "twxs";
            #   version = "0.0.17";
            #   sha256 = "11hzjd0gxkq37689rrr2aszxng5l9fwpgs9nnglq3zhfa1msyn08";
            # }
            # {
            #   publisher = "vscodevim";
            #   name = "vim";
            #   version = "1.18.5";
            #   sha256 = "0cbmmhkbr4f1afk443sgdihp2q5zkzchbr2yhp7bm5qnv7xdv5l4";
            # }
            # https://www.vsixhub.com/vsix/30/
            # {
            #   name = "ccls";
            #   publisher = "ccls-project";
            #   version = "0.1.29";
            #   sha256 = "RjMYBLgbi+lgPqaqN7yh8Q8zr9euvQ+YLEoQaV3RDOA=";
            # }
            # {
            #   name = "vscode-direnv";
            #   publisher = "cab404";
            #   version = "1.0.0";
            #   sha256 = "0xikkhbzb5cd0a96smj5mr1sz5zxrmryhw56m0139sbg7zwwfwps";
            # }
            # {
            #   name = "nix-ide";
            #   publisher = "jnoortheen";
            #   version = "0.1.16";
            #   sha256 = "04ky1mzyjjr1mrwv3sxz4mgjcq5ylh6n01lvhb19h3fmwafkdxbp";
            # }
            # {
            #   name = "nix-extension-pack";
            #   publisher = "pinage404";
            #   version = "1.0.0";
            #   sha256 = "10hi9ydx50zd9jhscfjiwlz3k0v4dfi0j8p58x8421rk5dspi98x";
            # }
          ];
      };

    };
}
