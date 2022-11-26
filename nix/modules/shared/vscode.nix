{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.vscode;

in

{
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
          mutableExtensionsDir = true;
          package = pkgs.vscodium;
             # Notes:
             # - Does not unistall extensions once removed.
             # - Update using the following: export temp=$(mktemp) && curl -s https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/misc/vscode-extensions/update_installed_exts.sh > $temp && chmod +x $temp && $temp $(whereis codium)
             # https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vscode-extensions/default.nix
               extensions = with pkgs.vscode-extensions;
                 [
                   matklad.rust-analyzer
                   a5huynh.vscode-ron
                   serayuzgur.crates
                   tamasfe.even-better-toml
                   vadimcn.vscode-lldb
                   ms-python.python
                   redhat.vscode-yaml
                   bbenoist.nix
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
                   jnoortheen.nix-ide
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
                   #aaron-bond.better-comments
                   #foam.foam-vscode
                   #formulahendry.auto-close-tag
                   msjsdiag.debugger-for-chrome
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
                 ]
                 ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                   {
                     # https://www.vsixhub.com/vsix/73731/
                     name = "gruvbox-material-icon-theme";
                     publisher = "jonathanharty";
                     version = "1.1.4";
                     sha256 = "2865cc8f59a65e93ad8eefe08e0af7ff666ef5d2fa317494821980ae77bfabf5";
                   }
                   {
                     # https://www.vsixhub.com/vsix/1950/
                     name = "liveserver";
                     publisher = "ritwickdey";
                     version = "5.7.9";
                     sha256 = "c3409848439d96dc0c1739b96613b14abc6a435cb8fa02df07c2fe105160cc37";
                   }
                   {
                     # https://www.vsixhub.com/vsix/32677/
                     name = "tauri-vscode";
                     publisher = "tauri-apps";
                     version = "0.1.6";
                     sha256 = "46ce91c29b9e567282fe0c39dad26cba85b00a0571fc7c8b268726b23d318ba6";
                   }

                   {
                     name = "gruvbox-themes";
                     publisher = "tomphilbin";
                     version = "1.0.0";
                     sha256 = "0xykf120j27s0bmbqj8grxc79dzkh4aclgrpp1jz5kkm39400z0f";
                   }
                   {
                     name = "rewrap";
                     publisher = "stkb";
                     version = "17.8.0";
                     sha256 = "1y168ar01zxdd2x73ddsckbzqq0iinax2zv3d95nhwp9asjnbpgn";
                   }
                   {
                     name = "better-cpp-syntax";
                     publisher = "jeff-hykin";
                     version = "1.15.19";
                     sha256 = "13v1lqqfvgkf5nm89b39hci65fnz4j89ngkg9p103l1p1fhncr41";
                   }
                   {
                     name = "remote-containers";
                     publisher = "ms-vscode-remote";
                     version = "0.248.0";
                     sha256 = "147hcm98bbd5ww1xps9myay6324n4c5mj6f4zpkkb4c93k2ffxj3";
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
                     publisher = "2gua";
                     name = "rainbow-brackets";
                     version = "0.0.6";
                     sha256 = "1m5c7jjxphawh7dmbzmrwf60dz4swn8c31svbzb5nhaazqbnyl2d";
                   }
                   {
                     publisher = "bungcip";
                     name = "better-toml";
                     version = "0.3.2";
                     sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
                   }
                   {
                     name = "gitignore";
                     publisher = "codezombiech";
                     version = "0.9.0";
                     sha256 = "0ww0x28m83fv5zdqkmz108rsxb60fyy5y0ksknb2xchirzwhayi0";
                   }
                   {
                     name = "prettier-vscode";
                     publisher = "esbenp";
                     version = "9.8.0";
                     sha256 = "1rkjzmcvmjzd7l6bi05ymr1sibps3c6lzxhbmjp0zpzv02wl9jgv";
                   }
                   {
                     name = "vscode-test-explorer";
                     publisher = "hbenl";
                     version = "2.21.1";
                     sha256 = "022lnkq278ic0h9ggpqcwb3x3ivpcqjimhgirixznq0zvwyrwz3w";
                   }
                   {
                     name = "restructuredtext";
                     publisher = "lextudio";
                     version = "190.1.4";
                     sha256 = "1y25b2i16xjb1cbmkxd822jh10jdclk3h16hf62s65l00z69gfxv";
                   }
                   {
                     publisher = "lostintangent";
                     name = "vsls-pomodoro";
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
                     name = "rainbow-csv";
                     publisher = "mechatroner";
                     version = "2.4.0";
                     sha256 = "0idl63rfn068zamyx5mw3524k3pb98gv32dfbrszxyrrx4kbh1fd";
                   }
                   {
                     name = "nunjucks";
                     publisher = "ronnidc";
                     version = "0.3.1";
                     sha256 = "0dlsri0dcligjz3x1ddpjhyvna6dmdswhb86c9k73y22r12fd1zd";
                   }
                   {
                     name = "elm-ls-vscode";
                     publisher = "elmTooling";
                     version = "2.4.1";
                     sha256 = "1idhsrl9w8sc0qk58dvmyyjbmfznk3f4gz2zl6s9ksyz9d06vfrd";
                   }
                   # {
                   #   # https://www.vsixhub.com/vsix/8048/
                   #   name = "vscode-lldb";
                   #   publisher = "vadimcn";
                   #   version = "1.7.4";
                   #   sha256 = "5c9c4db3b03cd48612f65d382340f9e5f2506ac3e6b7be65d74ca3de064d9978";
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

               userSettings = {
                 "update.mode" = "none";
                 "http.proxy" = "127.0.0.1:7890";
                 "http.proxySupport" = "on";
                 # appearance

                 "editor.minimap.enabled" = false;
                 "editor.fontLigatures" = true;
                 "editor.fontFamily" = "Mensch, Menlo, Consolas, Monaco, 'Courier New', monospace";
                 "editor.tabSize" = 2; # Because I prefer smaller tab sizes.
                 "editor.formatOnPaste" = false; # Do not mess with my code by default. Will trust automatic rules language by language.
                 "editor.formatOnSave" = false; # Do not mess with my code by default. Will trust automatic rules language by language.
                 "editor.acceptSuggestionOnEnter" = "off";
                 "editor.fontSize" = 18;
                 "editor.letterSpacing" = 1.0;
                 "editor.lineHeight" = 22;
                 "editor.renderWhitespace" = "all";
                 "editor.suggestSelection" = "first";
                 "editor.tabCompletion" = "onlySnippets";
                 "editor.accessibilitySupport" = "0ff";
                 "editor.quickSuggestions" = {
                   "strings" = true;
                 };
                 "editor.inlineSuggest.enabled" = true;
                 "editor.stickyScroll.enabled" = true;
                 "editor.bracketPairColorization.enabled" = true;
                 "editor.guides.bracketPairs" = "active";
                 "editor.maxTokenizationLineLength" = 10000;
                 "editor.unicodeHighlight.ambiguousCharacters" = false;
                 "editor.wordWrap" = "on";
                 "editor.useTabStops" = false;
                 "editor.rulers" = [ 80 120 ];
                 # scroll with an animation
                 "editor.smoothScrolling" = true;

                 "workbench.fontAliasing" = "antialiased";
                 "workbench.editor.highlightModifiedTabs" = true; # Better highlight on modified tabs.
                 "workbench.editor.enablePreview" = false; # I often prefer small files therefore I thank the extra space.
                 "workbench.statusBar.feedback.visible" = false;
                 "workbench.activityBar.visible" = true;
                 "workbench.tree.indent" = 8;
                 #"workbench.colorTheme" = "Gruvbox Light (Medium)";
                 "workbench.colorTheme" = "Gruvbox Dark Hard";
                 #"workbench.iconTheme" = "Gruvbox Light";
                 "workbench.iconTheme" = "gruvbox-material-icon-theme";
                 "workbench.editor.wrapTabs" = true;
                 "workbench.editor.tabSizing" = "fit";
                 "workbench.editor.decorations.colors" = true;
                 "workbench.editor.decorations.badges" = true;
                 "workbench.editor.enablePreviewFromCodeNavigation" = true;
                 "workbench.startupEditor" = "newUntitledFile";
                 "workbench.settings.editor" = "json";
                 "workbench.editor.untitled.experimentalLanguageDetection" = true;
                 "workbench.sideBar.location" = "left";
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
                 "terminal.integrated.drawBoldTextInBrightColors" = false;
                 "terminal.integrated.defaultProfile.linux" = "zsh";
                 "terminal.integrated.defaultProfile.osx" = "zsh";
                 "terminal.integrated.fontSize" = 12;
                 "terminal.integrated.fontFamily" = "PragmataPro Liga";
                 "terminal.integrated.cursorStyle" = "line";
                 "terminal.integrated.cursorBlinking" = true;
                 "terminal.integrated.letterSpacing" = 1.0;
                 "terminal.integrated.lineHeight" = 1.2;
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

                 "diffEditor.maxComputationTime" = 0;
                 "diffEditor.wordWrap" = "off";
                 "eslint.format.enable" = true;
                 "eslint.lintTask.enable" = true;
                 "explorer.confirmDelete" = false;
                 "explorer.confirmDragAndDrop" = false; # Don't bother me when I want to drag-and-drop files.

                 "git.confirmSync" = false;
                 "git.enableSmartCommit" = true;
                 "git.autofetch" = true;

                 "redhat.telemetry.enabled" = false;
                 "security.workspace.trust.untrustedFiles" = "open";
                 "typescript.updateImportsOnFileMove.enabled" = "always";
                 "telemetry.enableTelemetry" = false;
                 "telemetry.enableCrashReporter" = false;
                 "telemetry.telemetryLevel" = "off";

                 "debug.console.fontFamily" = "PragmataPro Liga";
                 "debug.console.fontSize" = 16;
                 "debug.allowBreakpointsEverywhere" = true;
                 "debug.javascript.autoAttachFilter" = "smart";

                 "breadcrumbs.enabled" = false;
                 "liveServer.settings.donotShowInfoMsg" = true;

                 # copilot
                 # "enable-proposed-api" = ["github.copilot"];
                 # "github.copilot.enable" = {
                 #   "*" = true;
                 #   "yaml" = false;
                 #   "plaintext" = false;
                 #   "markdown" = false;
                 # };

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
                 "files.trimTrailingWhitespace" = true;
                 "files.associations" = {
                   "*.config" = "makefile";
                 };

                 "files.trimFinalNewlines" = true; # Keep files trimmed.
                 "files.insertFinalNewline" = true; # Because POSIX compliance (todo: read why is that really important, maybe to identify the last line?)
                 #"files.autoSave" = "onFocusChange"; # Because I am lazy and I often source control the files.
                 "files.autoSave" = "onWindowChange";

                 "window.menuBarVisibility" = "toggle";
                 #"window.menuBarVisibility" = "default";
                 "window.titleBarStyle" = "custom";
                 "window.zoomLevel" = -1;

                 "extensions.ignoreRecommendations" = true;
                 "npm.fetchOnlinePackageInfo" = false;

                 "css.validate" = false;
                 "tailwindCSS.includeLanguages" = {
                   "astro" = "html";
                 };

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

                 "scm.diffDecorations" = "all";
                 "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";

                 # Markdown
                 "markdown.preview.scrollEditorWithPreview" = true; # Syncronize editor with preview.
                 "markdown.preview.scrollPreviewWithEditor" = true; # Syncronize preview with editor.editor with preview.

                 ## Language Servers ##
                 "perl.pls" = "${pkgs.perlPackages.PLS}/bin/pls";

                 "nix.enableLanguageServer" = true;
                 #"nix.serverPath" = "${pkgs.lsp-nil}/bin/nil";
                 "nix.formatterPath" = pkgs.nixpkgs-fmt + "/bin/nixpkgs-fmt";
                 "nix.serverPath" = pkgs.rnix-lsp + "/bin/rnix-lsp";

                 "rust-analyzer.cargo.allFeatures" = true;
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
                 # "rust-analyzer.lens.references" = true;
                 "rust-analyzer.lens.references.adt.enable" = true;
                 "rust-analyzer.lens.references.enumVariant.enable" = true;
                 "rust-analyzer.lens.references.method.enable" = true;
                 "rust-analyzer.lens.references.trait.enable" = true;
                 "rust-analyzer.lens.methodReferences" = true;

                 # enforce consistent imports everywhere
                 "rust-analyzer.imports.granularity.enforce" = true;
                 "rust-analyzer.imports.granularity.group" = "module";
                 "rust-analyzer.imports.prefix" = "self";

                 # show hints for elided lifetimes
                 "rust-analyzer.inlayHints.lifetimeElisionHints.enable" = "always"; # or 'skip_trivial'
                 # "rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames" = true;

                 "go.toolsManagement.autoUpdate" = true;
                 "go.docsTool" = "godoc";
                 "go.formatTool" = "goimports";
                 "go.useLanguageServer" = true;

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
                 "deno.path" = "${pkgs.deno}/bin/deno";
                 "deno.suggest.imports.hosts" = {
                   "https://deno.land" = false;
                 };
                 #"alejandra.program" = "alejandra";
                 "purescript.formatter" = "purs-tidy";
                 "settingsSync.keybindingsPerPlatform" = false;

                 "yaml.schemaStore.enable" = true;
                 "yaml.schemas" = {
                   "https://json.schemastore.org/github-workflow.json" = ".github/workflows/*.yaml";
                 };

                 "[css]" = {
                   "editor.defaultFormatter" = "esbenp.prettier-vscode";
                 };
                 "[html]" = {
                   "editor.defaultFormatter" = "esbenp.prettier-vscode";
                 };

                 "[typescriptreact]" = {
                   "editor.defaultFormatter" = "esbenp.prettier-vscode";
                 };

                 "[typescript]" = {
                   "editor.defaultFormatter" = "denoland.vscode-deno";
                   "editor.formatOnSave" = true;
                 };

                 "[javascript]" = {
                   "editor.defaultFormatter" = "dbaeumer.vscode-eslint";
                 };

                 "[json]" = {
                   "editor.defaultFormatter" = "vscode.json-language-features";
                 };
                 "[jsonc]" = {
                   "editor.defaultFormatter" = "vscode.json-language-features";
                 };

                 "[properties]" = {
                   "editor.defaultFormatter" = "foxundermoon.shell-format";
                 };

                 "[go]" = {
                   "editor.defaultFormatter" = "golang.go";
                 };
                 "[rust]" = {
                   "editor.fontLigatures" = true;
                   "editor.formatOnSave" = true;
                 };

                 "[c]" = {
                   "editor.defaultFormatter" = "ms-vscode.cpptools";
                 };
                 "[cpp]" = {
                   "editor.defaultFormatter" = "ccls-project.ccls";
                 };

                 "[markdown]" = {
                   "editor.defaultFormatter" = "esbenp.prettier-vscode";
                 };

                 "[python]" = {
                   "editor.renderFinalNewline" = true;
                   "editor.rulers" = [ 88 ];
                   "editor.trimAutoWhitespace" = true;
                   "files.trimFinalNewlines" = true;
                   "files.trimTrailingWhitespace" = true;
                   "files.insertFinalNewline" = true;
                 };

                 "[rust]" = {
                   "editor.defaultFormatter" = "matklad.rust-analyzer";
                   "editor.renderFinalNewline" = true;
                   "editor.rulers" = [ 99 ];
                   "editor.trimAutoWhitespace" = true;
                   "files.trimFinalNewlines" = true;
                   "files.trimTrailingWhitespace" = true;
                   "files.insertFinalNewline" = true;
                 };

                 "[nix]" = {
                   "editor.defaultFormatter" = "jnoortheen.nix-ide";
                   #"editor.defaultFormatter" = "kamadorueda.alejandra";
                 };

                 "[shellscript]" = {
                   "editor.defaultFormatter" = "foxundermoon.shell-format";
                   "editor.tabSize" = 2;
                   "files.eol" = "\n";
                 };
                 "[yaml]" = {
                   "editor.wordBasedSuggestionsMode" = "currentDocument";
                 };

                 "[elixir]" = {
                   "editor.defaultFormatter" = "JakeBecker.elixir-ls";
                 };

                 "[haskell]" = {
                   "editor.defaultFormatter" = "haskell.haskell";
                 };
                 "[ignore]" = {
                   "editor.defaultFormatter" = "foxundermoon.shell-format";
                 };
                 "[csharp]" = {
                   "editor.defaultFormatter" = "csharpier.csharpier-vscode";
                   "editor.formatOnSave" = true;
                 };
               };

               keybindings = [
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
