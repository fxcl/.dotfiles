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
        # - Update using the following: export temp=$(mktemp) && curl -s https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/misc/vscode-extensions/update_installed_exts.sh > $temp && chmod +x $temp && $temp $(whereis codium)
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
          in [
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
            # {
            #   # https://www.vsixhub.com/vsix/573/
            #   name = "elm-ls-vscode";
            #   publisher = "elmTooling";
            #   version = "2.7.2";
            #   sha256 = "dfc7cb78c466c8ec2f84962881d521fdf89de6a014b5d11760ca662fedb56f46";
            # }
            {
              # https://www.vsixhub.com/vsix/8048/
              name = "vscode-lldb";
              publisher = "vadimcn";
              version = "1.10.0";
              sha256 =
                "4402afec44b0d071bf6af04e3c4d424ebd131ec07b516c7485a25577f0e6f468";
            }
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

        userSettings = {
          "update.mode" = "none";
          "http.proxy" = "127.0.0.1:7890";
          "http.proxySupport" = "on";
          # appearance

          "editor.minimap.enabled" = false;
          "editor.codeLensFontFamily" = ''
            'Zed Mono', "FiraCode Nerd Font Mono"; "Noto Sans Mono CJK JP"; monospace'';
          "editor.fontFamily" = ''
            'Zed Mono', Mensch, Menlo, Consolas, Monaco, 'Courier New',"FiraCode Nerd Font Mono"; "Noto Sans Mono CJK JP"; monospace'';
          "editor.fontLigatures" = "'ss01', 'ss02', 'ss03', 'ss06', 'zero'";
          "editor.tabSize" = 2; # Because I prefer smaller tab sizes.
          "editor.formatOnPaste" =
            false; # Do not mess with my code by default. Will trust automatic rules language by language.
          "editor.formatOnSave" =
            false; # Do not mess with my code by default. Will trust automatic rules language by language.
          "editor.formatOnType" = true;
          "editor.acceptSuggestionOnEnter" = "off";
          "editor.fontSize" = 18;
          "editor.letterSpacing" = 1.0;
          "editor.lineHeight" = 22;
          "editor.renderWhitespace" = "boundary";
          "editor.suggestSelection" = "first";
          #"editor.tabCompletion" = "onlySnippets";
          "editor.tabCompletion" = "on";
          "editor.accessibilitySupport" = "0ff";
          "editor.quickSuggestions" = { "strings" = true; };
          "editor.inlineSuggest.enabled" = true;
          "editor.stickyScroll.enabled" = true;
          "editor.bracketPairColorization.enabled" = true;
          "editor.guides.bracketPairs" = "active";
          "editor.maxTokenizationLineLength" = 10000;
          "editor.unicodeHighlight.ambiguousCharacters" = false;
          "editor.wordWrap" = "on";
          "editor.useTabStops" = false;
          "editor.rulers" = [ 72 80 100 120 ];
          # scroll with an animation
          "editor.smoothScrolling" = true;

          "editor.autoClosingBrackets" = "always";
          "editor.autoClosingDelete" = "always";
          "editor.autoClosingOvertype" = "always";
          "editor.autoClosingQuotes" = "always";
          "editor.definitionLinkOpensInPeek" = true;
          "editor.experimental.pasteActions.enabled" = true;
          "editor.foldingImportsByDefault" = true;
          "editor.linkedEditing" = true;
          "editor.stickyTabStops" = true;

          "editor.wordWrapColumn" = 120;
          "editor.cursorSmoothCaretAnimation" = "on";
          "editor.cursorSurroundingLines" = 5;
          "editor.find.autoFindInSelection" = "multiline";

          "diffEditor.codeLens" = true;
          "diffEditor.diffAlgorithm" = "experimental";
          "editor.suggest.preview" = true;
          "editor.suggest.shareSuggestSelections" = true;

          "editor.find.addExtraSpaceOnTop" = false;
          "editor.lineNumbers" = "relative";
          # "editor.multiCursorModifier" = "ctrlCmd";
          "editor.unicodeHighlight.invisibleCharacters" = false;
          "editor.hover.sticky" = true;
          "editor.codeActionsOnSave" = {
            "source.fixAll" = false;
            "source.fixAll.eslint" = true;
            "source.organizeImports" = false;
          };
          "editor.wordSeparators" = ''`~!@#%^&*()=+[{]}\|;:'";.<>/?'';

          "files.trimFinalNewlines" = true; # Keep files trimmed.
          "files.insertFinalNewline" =
            true; # Because POSIX compliance (todo: read why is that really important, maybe to identify the last line?)
          #"files.autoSave" = "onFocusChange"; # Because I am lazy and I often source control the files.
          "files.autoSave" = "onWindowChange";

          "files.enableTrash" = false;
          "files.eol" = "\n";
          "files.trimTrailingWhitespace" = true;
          "workbench.editor.tabCloseButton" = "left";
          "workbench.fontAliasing" = "antialiased";
          "workbench.iconTheme" = "file-icons";
          "workbench.list.smoothScrolling" = true;
          "workbench.preferredDarkColorTheme" = "Vitesse Dark";
          "workbench.preferredLightColorTheme" = "Vitesse Light";
          "workbench.productIconTheme" = "icons-carbon";
          "workbench.sideBar.location" = "left";
          "workbench.startupEditor" = "newUntitledFile";
          "workbench.tree.expandMode" = "singleClick";
          "workbench.tree.indent" = 10;

          "workbench.editor.highlightModifiedTabs" =
            true; # Better highlight on modified tabs.
          "workbench.editor.enablePreview" =
            false; # I often prefer small files therefore I thank the extra space.
          "workbench.statusBar.feedback.visible" = false;
          "workbench.activityBar.visible" = true;
          #"workbench.colorTheme" = "Gruvbox Light (Medium)";
          #"workbench.colorTheme" = "Vitesse Light";
          "workbench.colorTheme" = "Gruvbox Light";
          "workbench.editor.wrapTabs" = true;
          "workbench.editor.tabSizing" = "fit";
          "workbench.editor.decorations.colors" = true;
          "workbench.editor.decorations.badges" = true;
          "workbench.editor.enablePreviewFromCodeNavigation" = true;

          "workbench.settings.editor" = "json";
          "workbench.editor.untitled.experimentalLanguageDetection" = true;
          "workbench.colorCustomizations" = {
            "editorBracketHighlight.foreground1" = "#FFD700";
            "editorBracketHighlight.foreground2" = "#DA70D6";
            "editorBracketHighlight.foreground3" = "#87CEFA";
            "editorBracketHighlight.foreground4" = "#FA8072";
            "editorBracketHighlight.foreground5" = "#7CFC00";
            "editorBracketHighlight.foreground6" = "#FF8C00";
          };
          "workbench.editorAssociations" = {
            "*.ipynb" = "jupyter.notebook.ipynb";
          };
          "explorer.excludeGitIgnore" = true;
          "explorer.fileNesting.enabled" = true;
          "explorer.fileNesting.expand" = false;
          "explorer.fileNesting.patterns" = {
            "tsconfig.json" = "tsconfig.*.json";
            "*.asax" = "$(capture).*.cs, $(capture).*.vb";
            "*.ascx" = "$(capture).*.cs, $(capture).*.vb";
            "*.ashx" = "$(capture).*.cs, $(capture).*.vb";
            "*.aspx" = "$(capture).*.cs, $(capture).*.vb";
            "*.bloc.dart" = "$(capture).event.dart, $(capture).state.dart";
            "*.c" = "$(capture).h";
            "*.cc" = "$(capture).hpp, $(capture).h, $(capture).hxx";
            "*.cjs" = "$(capture).cjs.map, $(capture).*.cjs, $(capture)_*.cjs";
            "*.component.ts" =
              "$(capture).component.html, $(capture).component.spec.ts, $(capture).component.css, $(capture).component.scss, $(capture).component.sass, $(capture).component.less";
            "*.cpp" = "$(capture).hpp, $(capture).h, $(capture).hxx";
            "*.cs" = "$(capture).*.cs";
            "*.cshtml" = "$(capture).cshtml.cs";
            "*.csproj" =
              "*.config, *proj.user, appsettings.*, bundleconfig.json";
            "*.css" = "$(capture).css.map, $(capture).*.css";
            "*.cxx" = "$(capture).hpp, $(capture).h, $(capture).hxx";
            "*.dart" = "$(capture).freezed.dart, $(capture).g.dart";
            "*.ex" =
              "$(capture).html.eex, $(capture).html.heex, $(capture).html.leex";
            "*.go" = "$(capture)_test.go";
            "*.java" = "$(capture).class";
            "*.js" = "$(capture).js.map, $(capture).*.js, $(capture)_*.js";
            "*.jsx" =
              "$(capture).js, $(capture).*.jsx, $(capture)_*.js, $(capture)_*.jsx";
            "*.master" = "$(capture).*.cs, $(capture).*.vb";
            "*.mjs" = "$(capture).mjs.map, $(capture).*.mjs, $(capture)_*.mjs";
            "*.module.ts" =
              "$(capture).resolver.ts, $(capture).controller.ts, $(capture).service.ts";
            "*.pubxml" = "$(capture).pubxml.user";
            "*.resx" =
              "$(capture).*.resx, $(capture).designer.cs, $(capture).designer.vb";
            "*.tex" =
              "$(capture).acn, $(capture).acr, $(capture).alg, $(capture).aux, $(capture).bbl, $(capture).blg, $(capture).fdb_latexmk, $(capture).fls, $(capture).glg, $(capture).glo, $(capture).gls, $(capture).idx, $(capture).ind, $(capture).ist, $(capture).lof, $(capture).log, $(capture).lot, $(capture).out, $(capture).pdf, $(capture).synctex.gz, $(capture).toc, $(capture).xdv";
            "*.ts" =
              "$(capture).js, $(capture).d.ts.map, $(capture).*.ts, $(capture)_*.js, $(capture)_*.ts";
            "*.tsx" =
              "$(capture).ts, $(capture).*.tsx, $(capture)_*.ts, $(capture)_*.tsx";
            "*.vbproj" =
              "*.config, *proj.user, appsettings.*, bundleconfig.json";
            "*.vue" = "$(capture).*.ts, $(capture).*.js, $(capture).story.vue";
            "*.xaml" = "$(capture).xaml.cs";
            "+layout.svelte" =
              "+layout.ts,+layout.ts,+layout.js,+layout.server.ts,+layout.server.js,+layout.gql";
            "+page.svelte" =
              "+page.server.ts,+page.server.js,+page.ts,+page.js,+page.gql";
            ".clang-tidy" = ".clang-format, .clangd, compile_commands.json";
            ".env" = "*.env, .env.*, .envrc, env.d.ts";
            ".gitignore" =
              ".gitattributes, .gitmodules, .gitmessage, .mailmap, .git-blame*";
            ".project" = ".classpath";
            "//" = "Last update at 4/29/2023, 2:04:58 PM";
            "BUILD.bazel" =
              "*.bzl, *.bazel, *.bazelrc, bazel.rc, .bazelignore, .bazelproject, WORKSPACE";
            "CMakeLists.txt" =
              "*.cmake, *.cmake.in, .cmake-format.yaml, CMakePresets.json";
            "I*.cs" = "$(capture).cs";
            "artisan" =
              "*.env, .babelrc*, .codecov, .cssnanorc*, .env.*, .envrc, .htmlnanorc*, .lighthouserc.*, .mocha*, .postcssrc*, .terserrc*, api-extractor.json, ava.config.*, babel.config.*, contentlayer.config.*, cssnano.config.*, cypress.*, env.d.ts, formkit.config.*, formulate.config.*, histoire.config.*, htmlnanorc.*, jasmine.*, jest.config.*, jsconfig.*, karma*, lighthouserc.*, playwright.config.*, postcss.config.*, puppeteer.config.*, rspack.config.*, server.php, svgo.config.*, tailwind.config.*, tsconfig.*, tsdoc.*, uno.config.*, unocss.config.*, vitest.config.*, webpack.config.*, webpack.mix.js, windi.config.*";
            "astro.config.*" =
              "*.env, .babelrc*, .codecov, .cssnanorc*, .env.*, .envrc, .htmlnanorc*, .lighthouserc.*, .mocha*, .postcssrc*, .terserrc*, api-extractor.json, ava.config.*, babel.config.*, contentlayer.config.*, cssnano.config.*, cypress.*, env.d.ts, formkit.config.*, formulate.config.*, histoire.config.*, htmlnanorc.*, jasmine.*, jest.config.*, jsconfig.*, karma*, lighthouserc.*, playwright.config.*, postcss.config.*, puppeteer.config.*, rspack.config.*, svgo.config.*, tailwind.config.*, tsconfig.*, tsdoc.*, uno.config.*, unocss.config.*, vitest.config.*, webpack.config.*, windi.config.*";
            "cargo.toml" =
              ".clippy.toml, .rustfmt.toml, cargo.lock, clippy.toml, cross.toml, rust-toolchain.toml, rustfmt.toml";
            "composer.json" =
              ".php*.cache, composer.lock, phpunit.xml*, psalm*.xml";
            "default.nix" = "shell.nix";
            "deno.json*" =
              "*.env, .env.*, .envrc, api-extractor.json, deno.lock, env.d.ts, import-map.json, import_map.json, jsconfig.*, tsconfig.*, tsdoc.*";
            "dockerfile" = ".dockerignore, docker-compose.*, dockerfile*";
            "flake.nix" = "flake.lock";
            "gatsby-config.*" =
              "*.env, .babelrc*, .codecov, .cssnanorc*, .env.*, .envrc, .htmlnanorc*, .lighthouserc.*, .mocha*, .postcssrc*, .terserrc*, api-extractor.json, ava.config.*, babel.config.*, contentlayer.config.*, cssnano.config.*, cypress.*, env.d.ts, formkit.config.*, formulate.config.*, gatsby-browser.*, gatsby-node.*, gatsby-ssr.*, gatsby-transformer.*, histoire.config.*, htmlnanorc.*, jasmine.*, jest.config.*, jsconfig.*, karma*, lighthouserc.*, playwright.config.*, postcss.config.*, puppeteer.config.*, rspack.config.*, svgo.config.*, tailwind.config.*, tsconfig.*, tsdoc.*, uno.config.*, unocss.config.*, vitest.config.*, webpack.config.*, windi.config.*";
            "gemfile" = ".ruby-version, gemfile.lock";
            "go.mod" = ".air*, go.sum";
            "go.work" = "go.work.sum";
            "mix.exs" =
              ".credo.exs, .dialyzer_ignore.exs, .formatter.exs, .iex.exs, .tool-versions, mix.lock";
            "next.config.*" =
              "*.env, .babelrc*, .codecov, .cssnanorc*, .env.*, .envrc, .htmlnanorc*, .lighthouserc.*, .mocha*, .postcssrc*, .terserrc*, api-extractor.json, ava.config.*, babel.config.*, contentlayer.config.*, cssnano.config.*, cypress.*, env.d.ts, formkit.config.*, formulate.config.*, histoire.config.*, htmlnanorc.*, jasmine.*, jest.config.*, jsconfig.*, karma*, lighthouserc.*, next-env.d.ts, playwright.config.*, postcss.config.*, puppeteer.config.*, rspack.config.*, svgo.config.*, tailwind.config.*, tsconfig.*, tsdoc.*, uno.config.*, unocss.config.*, vitest.config.*, webpack.config.*, windi.config.*";
            "nuxt.config.*" =
              "*.env, .babelrc*, .codecov, .cssnanorc*, .env.*, .envrc, .htmlnanorc*, .lighthouserc.*, .mocha*, .postcssrc*, .terserrc*, api-extractor.json, ava.config.*, babel.config.*, contentlayer.config.*, cssnano.config.*, cypress.*, env.d.ts, formkit.config.*, formulate.config.*, histoire.config.*, htmlnanorc.*, jasmine.*, jest.config.*, jsconfig.*, karma*, lighthouserc.*, playwright.config.*, postcss.config.*, puppeteer.config.*, rspack.config.*, svgo.config.*, tailwind.config.*, tsconfig.*, tsdoc.*, uno.config.*, unocss.config.*, vitest.config.*, webpack.config.*, windi.config.*";
            "package.json" =
              ".browserslist*, .circleci*, .commitlint*, .cz-config.js, .czrc, .dlint.json, .dprint.json, .editorconfig, .eslint*, .firebase*, .flowconfig, .github*, .gitlab*, .gitpod*, .huskyrc*, .jslint*, .lintstagedrc*, .markdownlint*, .node-version, .nodemon*, .npm*, .nvmrc, .pm2*, .pnp.*, .pnpm*, .prettier*, .releaserc*, .sentry*, .simple-git-hooks*, .stackblitz*, .styleci*, .stylelint*, .tazerc*, .textlint*, .tool-versions, .travis*, .versionrc*, .vscode*, .watchman*, .xo-config*, .yamllint*, .yarnrc*, Procfile, apollo.config.*, appveyor*, azure-pipelines*, bower.json, build.config.*, commitlint*, crowdin*, dangerfile*, dlint.json, dprint.json, eslint*, firebase.json, grunt*, gulp*, jenkins*, lerna*, lint-staged*, nest-cli.*, netlify*, nodemon*, npm-shrinkwrap.json, nx.*, package-lock.json, package.nls*.json, phpcs.xml, pm2.*, pnpm*, prettier*, pullapprove*, pyrightconfig.json, release-tasks.sh, release.config.*, renovate*, rollup.config.*, rspack*, simple-git-hooks*, stylelint*, tslint*, tsup.config.*, turbo*, typedoc*, unlighthouse*, vercel*, vetur.config.*, webpack*, workspace.json, xo.config.*, yarn*";
            "pubspec.yaml" =
              ".metadata, .packages, all_lint_rules.yaml, analysis_options.yaml, build.yaml, pubspec.lock, pubspec_overrides.yaml";
            "pyproject.toml" = ".pdm.toml, pdm.lock, pyproject.toml";
            "quasar.conf.js" =
              "*.env, .babelrc*, .codecov, .cssnanorc*, .env.*, .envrc, .htmlnanorc*, .lighthouserc.*, .mocha*, .postcssrc*, .terserrc*, api-extractor.json, ava.config.*, babel.config.*, contentlayer.config.*, cssnano.config.*, cypress.*, env.d.ts, formkit.config.*, formulate.config.*, histoire.config.*, htmlnanorc.*, jasmine.*, jest.config.*, jsconfig.*, karma*, lighthouserc.*, playwright.config.*, postcss.config.*, puppeteer.config.*, quasar.extensions.json, rspack.config.*, svgo.config.*, tailwind.config.*, tsconfig.*, tsdoc.*, uno.config.*, unocss.config.*, vitest.config.*, webpack.config.*, windi.config.*";
            "readme*" =
              "authors, backers*, changelog*, citation*, code_of_conduct*, codeowners, contributing*, contributors, copying, credits, governance.md, history.md, license*, maintainers, readme*, security.md, sponsors*";
            "remix.config.*" =
              "*.env, .babelrc*, .codecov, .cssnanorc*, .env.*, .envrc, .htmlnanorc*, .lighthouserc.*, .mocha*, .postcssrc*, .terserrc*, api-extractor.json, ava.config.*, babel.config.*, contentlayer.config.*, cssnano.config.*, cypress.*, env.d.ts, formkit.config.*, formulate.config.*, histoire.config.*, htmlnanorc.*, jasmine.*, jest.config.*, jsconfig.*, karma*, lighthouserc.*, playwright.config.*, postcss.config.*, puppeteer.config.*, remix.*, rspack.config.*, svgo.config.*, tailwind.config.*, tsconfig.*, tsdoc.*, uno.config.*, unocss.config.*, vitest.config.*, webpack.config.*, windi.config.*";
            "rush.json" =
              ".browserslist*, .circleci*, .commitlint*, .cz-config.js, .czrc, .dlint.json, .dprint.json, .editorconfig, .eslint*, .firebase*, .flowconfig, .github*, .gitlab*, .gitpod*, .huskyrc*, .jslint*, .lintstagedrc*, .markdownlint*, .node-version, .nodemon*, .npm*, .nvmrc, .pm2*, .pnp.*, .pnpm*, .prettier*, .releaserc*, .sentry*, .simple-git-hooks*, .stackblitz*, .styleci*, .stylelint*, .tazerc*, .textlint*, .tool-versions, .travis*, .versionrc*, .vscode*, .watchman*, .xo-config*, .yamllint*, .yarnrc*, Procfile, apollo.config.*, appveyor*, azure-pipelines*, bower.json, build.config.*, commitlint*, crowdin*, dangerfile*, dlint.json, dprint.json, eslint*, firebase.json, grunt*, gulp*, jenkins*, lerna*, lint-staged*, nest-cli.*, netlify*, nodemon*, npm-shrinkwrap.json, nx.*, package-lock.json, package.nls*.json, phpcs.xml, pm2.*, pnpm*, prettier*, pullapprove*, pyrightconfig.json, release-tasks.sh, release.config.*, renovate*, rollup.config.*, rspack*, simple-git-hooks*, stylelint*, tslint*, tsup.config.*, turbo*, typedoc*, unlighthouse*, vercel*, vetur.config.*, webpack*, workspace.json, xo.config.*, yarn*";
            "shims.d.ts" = "*.d.ts";
            "svelte.config.*" =
              "*.env, .babelrc*, .codecov, .cssnanorc*, .env.*, .envrc, .htmlnanorc*, .lighthouserc.*, .mocha*, .postcssrc*, .terserrc*, api-extractor.json, ava.config.*, babel.config.*, contentlayer.config.*, cssnano.config.*, cypress.*, env.d.ts, formkit.config.*, formulate.config.*, histoire.config.*, houdini.config.*, htmlnanorc.*, jasmine.*, jest.config.*, jsconfig.*, karma*, lighthouserc.*, mdsvex.config.js, playwright.config.*, postcss.config.*, puppeteer.config.*, rspack.config.*, svgo.config.*, tailwind.config.*, tsconfig.*, tsdoc.*, uno.config.*, unocss.config.*, vite.config.*, vitest.config.*, webpack.config.*, windi.config.*";
            "vite.config.*" =
              "*.env, .babelrc*, .codecov, .cssnanorc*, .env.*, .envrc, .htmlnanorc*, .lighthouserc.*, .mocha*, .postcssrc*, .terserrc*, api-extractor.json, ava.config.*, babel.config.*, contentlayer.config.*, cssnano.config.*, cypress.*, env.d.ts, formkit.config.*, formulate.config.*, histoire.config.*, htmlnanorc.*, jasmine.*, jest.config.*, jsconfig.*, karma*, lighthouserc.*, playwright.config.*, postcss.config.*, puppeteer.config.*, rspack.config.*, svgo.config.*, tailwind.config.*, tsconfig.*, tsdoc.*, uno.config.*, unocss.config.*, vitest.config.*, webpack.config.*, windi.config.*";
            "vue.config.*" =
              "*.env, .babelrc*, .codecov, .cssnanorc*, .env.*, .envrc, .htmlnanorc*, .lighthouserc.*, .mocha*, .postcssrc*, .terserrc*, api-extractor.json, ava.config.*, babel.config.*, contentlayer.config.*, cssnano.config.*, cypress.*, env.d.ts, formkit.config.*, formulate.config.*, histoire.config.*, htmlnanorc.*, jasmine.*, jest.config.*, jsconfig.*, karma*, lighthouserc.*, playwright.config.*, postcss.config.*, puppeteer.config.*, rspack.config.*, svgo.config.*, tailwind.config.*, tsconfig.*, tsdoc.*, uno.config.*, unocss.config.*, vitest.config.*, webpack.config.*, windi.config.*";
          };

          "search.quickOpen.includeSymbols" = true;
          "search.smartCase" = true;
          "search.showLineNumbers" = true;
          "search.seedOnFocus" = true;
          "search.seedWithNearestWord" = true;
          "search.useGlobalIgnoreFiles" = true;
          "search.useParentIgnoreFiles" = true;
          "debug.allowBreakpointsEverywhere" = true;
          "debug.autoExpandLazyVariables" = true;
          "debug.console.fontSize" = 16;
          "debug.javascript.autoAttachFilter" = "smart";
          "debug.onTaskErrors" = "debugAnyway";

          "testing.alwaysRevealTestOnStateChange" = true;
          "merge-conflict.autoNavigateNextConflict.enabled" = true;
          "better-comments.highlightPlainText" = true;

          "security.workspace.trust.untrustedFiles" = "open";
          "terminal.integrated.drawBoldTextInBrightColors" = false;
          "terminal.integrated.defaultProfile.linux" = "zsh";
          "terminal.integrated.defaultProfile.osx" = "zsh";
          "terminal.integrated.fontSize" = 12;
          "terminal.integrated.cursorStyle" = "line";
          "terminal.integrated.cursorBlinking" = true;
          "terminal.integrated.letterSpacing" = 1.0;
          "terminal.integrated.lineHeight" = 1.3;
          "terminal.integrated.shell.linux" = "/bin/zsh";
          "terminal.integrated.profiles.windows" = {
            "PowerShell" = {
              "source" = "PowerShell";
              "icon" = "terminal-powershell";
              "args" = [ "-NoLogo" ];
            };
          };
          "terminal.integrated.experimentalUseTitleEvent" = true;
          "terminal.integrated.shellIntegration.decorationsEnabled" = "never";
          #"terminal.external.linuxExec" = "konsole";
          #"terminal.external.linuxExec" = "${alacritty}/bin/alacritty";

          # @jasonekratz added
          # This fixed the glyph issues I was having with Inconsolata Nerd Font.
          "terminal.integrated.gpuAcceleration" = "canvas";

          # @dalekurt added (belows which gives me the the fonts for the terminal and the icons from Nerd Font.)
          "terminal.integrated.fontFamily" =
            "'Hack Nerd Font','Source Code Pro for Powerline','MesloLGS NF','Source Code Pro for Powerline','Hack Nerd Font'";

          # @kaustuv added
          # after the changing the font, still had some issues with the glyph spacing in the integrated terminal - fixed it with
          # @ar2zee : fixed the problem for me.
          # (deprecated)
          "terminal.integrated.rendererType" = "canvas";

          "diffEditor.maxComputationTime" = 0;
          "diffEditor.wordWrap" = "off";
          "eslint.format.enable" = true;
          "eslint.lintTask.enable" = true;
          "explorer.confirmDelete" = false;
          "explorer.confirmDragAndDrop" =
            false; # Don't bother me when I want to drag-and-drop files.

          "git.confirmSync" = false;
          "git.enableSmartCommit" = true;
          "git.autofetch" = true;

          "redhat.telemetry.enabled" = false;

          "typescript.updateImportsOnFileMove.enabled" = "always";
          "telemetry.enableTelemetry" = false;
          "telemetry.enableCrashReporter" = false;
          "telemetry.telemetryLevel" = "off";
          "vetur.format.defaultFormatterOptions" = {
            "js-beautify-html" = { "wrap_attributes" = "aligned-multiple"; };
            "prettyhtml" = {
              "printWidth" = 400;
              "wrapAttributes" = false;
            };
          };

          "breadcrumbs.enabled" = false;
          "liveServer.settings.donotShowInfoMsg" = true;
          "conventionalCommits.emojiFormat" = "emoji";
          "conventionalCommits.showEditor" = true;

          # copilot
          "enable-proposed-api" = [ "github.copilot" ];
          "github.copilot.enable" = {
            "*" = true;
            "yaml" = false;
            "plaintext" = false;
            "markdown" = true;
          };

          "search.exclude" = {
            "**/.git" = true;
            "**/.github" = true;
            "**/.nuxt" = true;
            "**/.output" = true;
            "**/.pnpm" = true;
            "**/.vscode" = true;
            "**/.yarn" = true;
            "**/bower_components" = true;
            "**/dist/**" = true;
            "**/logs" = true;
            "**/node_modules" = true;
            "**/out/**" = true;
            "**/package-lock.json" = true;
            "**/pnpm-lock.yaml" = true;
            "**/tmp" = true;
            "**/yarn.lock" = true;
          };

          "files.exclude" = {
            "**/result" = true;
            "**/.git" = true;
            "**/.svn" = true;
            "**/.hg" = true;
            "**/CVS" = true;
            "**/.DS_Store" = true;
            "**/node_modules" = true;
            "**/shims-tsx.d.ts" = true;
            "**/shims-vue.d.ts" = true;
            "**/.browserslistrc" = true;
            "**/.eslintrc.js" = true;
            "**/.gitignore" = true;
            "**/babel.config.js" = true;
            "**/package-lock.json" = true;
            "**/README.md" = true;
            "**/tsconfig.json" = true;
            "**/.github" = true;
            "**/.classpath" = true;
            "**/.factorypath" = true;
            "**/.project" = true;
            "**/.settings" = true;
            "**/*.exe" = true;
            "**/*.o" = true;
          };
          "files.associations" = { "*.config" = "makefile"; };
          "files.watcherExclude" = {
            "**/.bloop" = true;
            "**/.metals" = true;
            "**/.ammonite" = true;
          };

          "window.menuBarVisibility" = "toggle";
          #"window.menuBarVisibility" = "default";
          "window.titleBarStyle" = "custom";
          "window.zoomLevel" = -1;

          "extensions.ignoreRecommendations" = true;
          "npm.fetchOnlinePackageInfo" = false;

          "css.validate" = false;
          "tailwindCSS.includeLanguages" = { "astro" = "html"; };

          "discord.workspaceExcludePatterns" = [ "nixpkgs" ];

          "bracket-pair-colorizer-2.colorMode" = "Consecutive";
          "bracket-pair-colorizer-2.forceIterationColorCycle" = true;
          "bracket-pair-colorizer-2.showBracketsInGutter" = true;

          "evenBetterToml.formatter.alignEntries" = true;
          "evenBetterToml.formatter.compactArrays" = false;
          "evenBetterToml.formatter.compactInlineTables" = false;
          "evenBetterToml.formatter.indentTables" = true;
          "evenBetterToml.formatter.reorderKeys" = false;

          "gitlens.defaultDateStyle" = "absolute";
          "gitlens.views.fileHistory.location" = "explorer";
          "gitlens.defaultDateFormat" = "H:mm:ss dd.MM.yy";
          "gitlens.hovers.currentLine.over" = "line";
          "gitlens.statusBar.alignment" = "left";
          "gitlens.codeLens.authors.enabled" = false;
          "gitlens.codeLens.enabled" = false;
          "gitlens.codeLens.recentChange.enabled" = false;
          "gitlens.menus" = {
            "editor" = {
              "blame" = false;
              "clipboard" = true;
              "compare" = true;
              "history" = false;
              "remote" = false;
            };
            "editorGroup" = {
              "blame" = true;
              "compare" = false;
            };
            "editorTab" = {
              "clipboard" = true;
              "compare" = true;
              "history" = true;
              "remote" = true;
            };
            "explorer" = {
              "clipboard" = true;
              "compare" = true;
              "history" = true;
              "remote" = true;
            };
            "scm" = { "authors" = true; };
            "scmGroup" = {
              "compare" = true;
              "openClose" = true;
              "stash" = true;
            };
            "scmGroupInline" = { "stash" = true; };
            "scmItem" = {
              "clipboard" = true;
              "compare" = true;
              "history" = true;
              "remote" = false;
              "stash" = true;
            };
          };
          "scm.diffDecorations" = "all";
          "vsintellicode.modify.editor.suggestSelection" =
            "automaticallyOverrodeDefaultValue";

          # Markdown
          "markdown.preview.scrollEditorWithPreview" =
            true; # Syncronize editor with preview.
          "markdown.preview.scrollPreviewWithEditor" =
            true; # Syncronize preview with editor.editor with preview.

          ## Language Servers ##
          "perl.pls" = "${pkgs.perlPackages.PLS}/bin/pls";

          "nix.enableLanguageServer" = true;
          #"nix.serverPath" = "${pkgs.lsp-nil}/bin/nil";
          "nix.formatterPath" = pkgs.nixpkgs-fmt + "/bin/nixpkgs-fmt";
          "nix.serverPath" = pkgs.rnix-lsp + "/bin/rnix-lsp";

          "rust-analyzer.debug.engine" = "vadimcn.vscode-lldb";
          "rust-analyzer.updates.channel" = "stable";
          "rust-analyzer.trace.extension" = true;
          "rust-analyzer.procMacro.enable" = true;
          #"rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          "rust-analyzer.server.path" = "rust-analyzer";

          # use clippy over cargo check
          "rust-analyzer.checkOnSave.command" = "clippy";
          # use nightly range formatting, should be faster
          "rust-analyzer.rustfmt.rangeFormatting.enable" = true;
          # show references for everything
          "rust-analyzer.hover.actions.references.enable" = true;
          "rust-analyzer.lens.references" = true;
          #"rust-analyzer.lens.references.adt.enable" = true;
          #"rust-analyzer.lens.references.enumVariant.enable" = true;
          #"rust-analyzer.lens.references.method.enable" = true;
          #"rust-analyzer.lens.references.trait.enable" = true;
          "rust-analyzer.lens.methodReferences" = true;
          "rust-analyzer.lens.enumVariantReferences" = true;

          # enforce consistent imports everywhere
          "rust-analyzer.imports.granularity.enforce" = true;
          "rust-analyzer.imports.granularity.group" = "module";
          "rust-analyzer.imports.prefix" = "self";

          "rust-analyzer.assist.emitMustUse" = true;
          "rust-analyzer.diagnostics.experimental.enable" = true;

          # show hints for elided lifetimes
          "rust-analyzer.inlayHints.lifetimeElisionHints.enable" =
            "always"; # or 'skip_trivial'
          # "rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames" = true;
          "rust-analyzer.hoverActions.references" = true;
          "rust-analyzer.workspace.symbol.search.scope" =
            "workspace_and_dependencies";
          "rust-analyzer.workspace.symbol.search.kind" = "all_symbols";

          "rust-analyzer.cargo.allFeatures" = true;
          "rust-analyzer.cargo.unsetTest" = [ ];

          "rust-analyzer.checkOnSave.extraArgs" = [
            "--"
            "-Wabsolute_paths_not_starting_with_crate"
            "-Welided_lifetimes_in_paths"
            "-Wexplicit_outlives_requirements"
            "-Wkeyword_idents"
            "-Wmacro_use_extern_crate"
            "-Wmeta_variable_misuse"
            "-Wmissing_abi"
            "-Wmissing_copy_implementations"
            "-Wmissing_debug_implementations"
            "-Wmissing_docs"
            "-Wnon_ascii_idents"
            "-Wnoop_method_call"
            "-Wpointer_structural_match"
            "-Wsingle_use_lifetimes"
            "-Wtrivial_casts"
            "-Wtrivial_numeric_casts"
            "-Wunreachable_pub"
            "-Wunused_extern_crates"
            "-Wunused_import_braces"
            "-Wunused_lifetimes"
            "-Wunused_qualifications"
            "-Wvariant_size_differences"
            "-Wclippy::pedantic"
            "-Wclippy::nursery"
            "-Wclippy::all"
          ];

          "go.toolsManagement.autoUpdate" = true;
          "go.docsTool" = "godoc";
          "go.formatTool" = "goimports";
          "go.lintFlags" =
            [ "--disable-all" "--enable=golint" "--config=~/.gometalinter" ];

          "go.useLanguageServer" = true;
          "go.coverOnSave" = true;
          "go.coverageDecorator" = {
            "type" = "gutter";
            "coveredHighlightColor" = "rgba(64,128,128,0.5)";
            "uncoveredHighlightColor" = "rgba(128,64,64,0.25)";
            "coveredGutterStyle" = "blockgreen";
            "uncoveredGutterStyle" = "blockred";
          };
          "go.coverOnSingleTest" = true;

          "javascript.validate.enable" = false;
          "javascript.updateImportsOnFileMove.enabled" = "always";

          "python.languageServer" = "Default";
          "python.showStartPage" = false;
          "python.insidersChannel" = "off";
          "[python].editor.rulers" = [ 72 78 ];

          "[markdown].editor.trimTrailingWhitespace" = false;

          "pascal.format.indent" = 4;
          "pascal.formatter.engine" = "ptop";
          "snapcode.transparentBackground" = true;
          "dart.previewFlutterUiGuidesCustomTracking" = true;
          "dart.warnWhenEditingFilesOutsideWorkspace" = false;
          "dart.previewLsp" = true;
          "dart.flutterCreateAndroidLanguage" = "kotlin";
          "dart.flutterCreateIOSLanguage" = "swift";
          "dart.previewFlutterUiGuides" = true;

          "deno.enable" = true;
          "deno.lint" = true;
          "deno.unstable" = true;
          #"deno.path" = "${pkgs.deno}/bin/deno";
          #"deno.path" = "~/.asdf/shims/deno";
          "deno.suggest.imports.hosts" = { "https://deno.land" = false; };
          #"alejandra.program" = "alejandra";
          "purescript.formatter" = "purs-tidy";
          "settingsSync.keybindingsPerPlatform" = false;

          "yaml.schemaStore.enable" = true;
          "yaml.schemas" = {
            "https://json.schemastore.org/github-workflow.json" =
              ".github/workflows/*.yaml";
          };

          "prettier.enable" = false;
          "prettier.printWidth" = 200;
          "prettier.semi" = false;
          "prettier.singleQuote" = true;

          "[css]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };
          "[html]" = { "editor.defaultFormatter" = "esbenp.prettier-vscode"; };

          "[typescriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };

          "[typescript]" = {
            #"editor.defaultFormatter" = "denoland.vscode-deno";
            "editor.defaultFormatter" = "vscode.typescript-language-features";
            "editor.formatOnSave" = true;
          };

          "[javascript]" = {
            "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
          };

          "[json]" = {
            "editor.defaultFormatter" = "vscode.json-language-features";
          };
          "[jsonc]" = {
            #"editor.defaultFormatter" = "vscode.json-language-features";
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };

          "[properties]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
          };

          "[go]" = {
            "editor.defaultFormatter" = "golang.go";
            "editor.tabSize" = 2;
          };
          "[c]" = {
            "editor.defaultFormatter" = "ms-vscode.cpptools";
            #"editor.defaultFormatter" = "xaver.clang-format";

          };
          "[cpp]" = { "editor.defaultFormatter" = "ccls-project.ccls"; };

          "[markdown]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };

          "[python]" = {
            "editor.renderFinalNewline" = "on";
            "editor.rulers" = [ 88 ];
            "editor.trimAutoWhitespace" = true;
            "files.trimFinalNewlines" = true;
            "files.trimTrailingWhitespace" = true;
            "files.insertFinalNewline" = true;
          };

          "[rust]" = {
            "editor.defaultFormatter" = "matklad.rust-analyzer";
            "editor.renderFinalNewline" = "on";
            "editor.rulers" = [ 99 ];
            "editor.fontLigatures" = true;
            "editor.formatOnSave" = true;
            "editor.trimAutoWhitespace" = true;
            "files.trimFinalNewlines" = true;
            "files.trimTrailingWhitespace" = true;
            "files.insertFinalNewline" = true;
          };

          "[nix]" = {
            "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
            "editor.tabSize" = 2;
            #"editor.defaultFormatter" = "kamadorueda.alejandra";
          };

          "[shellscript]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
            "editor.tabSize" = 2;
            "files.eol" = "\n";
          };
          "[yaml]" = { "editor.wordBasedSuggestionsMode" = "currentDocument"; };

          "[elixir]" = { "editor.defaultFormatter" = "JakeBecker.elixir-ls"; };

          "[haskell]" = { "editor.defaultFormatter" = "haskell.haskell"; };
          "[ignore]" = {
            "editor.defaultFormatter" = "foxundermoon.shell-format";
          };
          "[csharp]" = {
            "editor.defaultFormatter" = "csharpier.csharpier-vscode";
            "editor.formatOnSave" = true;
          };
          "yaml.customTags" = [
            "!And"
            "!And sequence"
            "!If"
            "!If sequence"
            "!Not"
            "!Not sequence"
            "!Equals"
            "!Equals sequence"
            "!Or"
            "!Or sequence"
            "!FindInMap"
            "!FindInMap sequence"
            "!Base64"
            "!Join"
            "!Join sequence"
            "!Cidr"
            "!Ref"
            "!Sub"
            "!Sub sequence"
            "!GetAtt"
            "!GetAZs"
            "!ImportValue"
            "!ImportValue sequence"
            "!Select"
            "!Select sequence"
            "!Split"
            "!Split sequence"
          ];
          "aws.profile" = "profile:default";
          "aws.telemetry" = false;
          "CodeGPT.apiKey" = "Google";
          #"CodeGPT.apiKey" = "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";
          #"CodeGPT.apiKey" = "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"
          "CodeGPT.model" = "chat-bison-001";
          "CodeGPT.query.language" = "Chinese";
          "github.copilot.advanced" = {
            "debug.overrideChatEngine" = "gpt-4";
            "authProvider" = "github-enterprise";
          };
          "github-enterprise.uri" = "https://cocopilot.org";

          "RainbowBrackets.depreciation-notice" = false;
        };

        keybindings = [
          {
            key = "cmd+k";
            command = "selectPrevSuggestion";
            when =
              "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
          }
          {
            key = "cmd+j";
            command = "selectNextSuggestion";
            when =
              "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
          }
          {
            key = "cmd+h";
            command = "workbench.action.navigateLeft";
            when = "!suggestWidgetVisible";
          }
          {
            key = "cmd+l";
            command = "workbench.action.navigateRight";
            when = "!suggestWidgetVisible";
          }
          {
            key = "cmd+k";
            command = "workbench.action.navigateUp";
            when = "!suggestWidgetVisible";
          }
          {
            key = "cmd+j";
            command = "workbench.action.navigateDown";
            when = "!suggestWidgetVisible";
          }
          {
            key = "cmd+g";
            command = "workbench.scm.focus";
          }
          {
            key = "cmd+b";
            command = "workbench.files.action.focusFilesExplorer";
          }
          {
            key = "cmd+escape";
            command = "workbench.action.closeSidebar";
          }
          {
            key = "f13";
            command = "workbench.action.showCommands";
          }
          {
            key = "f14";
            command = "workbench.action.quickOpen";
          }
          {
            key = "alt+left";
            command = "workbench.action.navigateBack";
          }
          {
            key = "alt+right";
            command = "workbench.action.navigateForward";
          }
          {
            key = "shift+cmd+d";
            command = "editor.action.copyLinesDownAction";
            when = "editorTextFocus && !editorReadonly";
          }
          #{ key = "Enter"; command = "rust-analyzer.onEnter"; when = "editorTextFocus && !suggestWidgetVisible && editorLangId == rust"; }
        ];
      };

    };
}
