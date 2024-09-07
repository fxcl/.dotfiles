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
                version = "0.7.8";
                sha256 = "1k0dxrybqjvlqy5x1i176g2q1x6lykviq1z4vc192kdzfp1p4v30";
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
            # vadimcn.vscode-lldb
            timonwong.shellcheck
            # Languages
            #scalameta.metals # Scala Language Server
            #scala-lang.scala # Scala Language
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
          ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "vscode-ron";
              publisher = "a5huynh";
              version = "0.11.0";
              sha256 = "03r9rm6hnphb5z8r9sbh3jlwz73k39i01728y0kdqwg4my08x0f4";
            }
            {
              name = "aws-toolkit-vscode";
              publisher = "amazonwebservices";
              version = "2.18.0";
              sha256 = "0nvr78sbpnqgjkr747j7hrkznm3ix49jqfi27q8h285qqjzf33jn";
            }
            {
              name = "icons-carbon";
              publisher = "antfu";
              version = "0.2.6";
              sha256 = "05rv2piclq0sa2mxa7xfbfvfh9k3k8b2ikyi5bd02zlvwwp8gis7";
            }
            {
              name = "nix-env-selector";
              publisher = "arrterian";
              version = "1.0.11";
              sha256 = "113zx78c3219knw4qa04242404n32vnk9rb6a3ynz41dgwh1mbbl";
            }
            {
              name = "Nix";
              publisher = "bbenoist";
              version = "1.0.1";
              sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
            }
            {
              name = "vscode-tailwindcss";
              publisher = "bradlc";
              version = "0.11.61";
              sha256 = "0i3fqzjgn5hdiflgjayx3v5s4h9kdcws6n7ck0ii921klnzvfxda";
            }
            {
              name = "nixfmt-classic-vscode";
              publisher = "brettm12345";
              version = "0.0.1";
              sha256 = "07w35c69vk1l6vipnq3qfack36qcszqxn8j3v332bl0w6m02aa7k";
            }
            {
              name = "path-intellisense";
              publisher = "christian-kohler";
              version = "2.8.5";
              sha256 = "1ndffv1m4ayiija1l42m28si44vx9y6x47zpxzqv2j4jj7ga1n5z";
            }
            {
              name = "vscode-eslint";
              publisher = "dbaeumer";
              version = "3.0.5";
              sha256 = "1cmkgi1i5c7qkrr8cif36i803yl6mrv87y9gmzfb701pcfg8yxx9";
            }
            {
              name = "dhall-lang";
              publisher = "dhall";
              version = "0.0.4";
              sha256 = "0sa04srhqmngmw71slnrapi2xay0arj42j4gkan8i11n7bfi1xpf";
            }
            {
              name = "vscode-dhall-lsp-server";
              publisher = "dhall";
              version = "0.0.4";
              sha256 = "1zin7s827bpf9yvzpxpr5n6mv0b5rhh3civsqzmj52mdq365d2js";
            }
            {
              name = "theme-dracula";
              publisher = "dracula-theme";
              version = "2.24.3";
              sha256 = "1gg9wrjz6w2khr1h449fwap34w1ydkndyi97r5bpbbdw9fa7q7fw";
            }
            {
              name = "EditorConfig";
              publisher = "EditorConfig";
              version = "0.16.4";
              sha256 = "0fa4h9hk1xq6j3zfxvf483sbb4bd17fjl5cdm3rll7z9kaigdqwg";
            }
            {
              name = "prettier-vscode";
              publisher = "esbenp";
              version = "10.4.0";
              sha256 = "1iy7i0yxnhizz40llnc1dk9q8kk98rz6ki830sq7zj3ak9qp9vzk";
            }
            {
              name = "shell-format";
              publisher = "foxundermoon";
              version = "7.2.5";
              sha256 = "0a874423xw7z6zjj7gzzl39jahrrqcf2r16zbcvncw23483m3yli";
            }
            {
              name = "copilot";
              publisher = "GitHub";
              version = "1.180.0";
              sha256 = "0izxzja04bd3kzg87415ii22khspjgp9r8yf9cj697pjjz6906jg";
            }
            {
              name = "copilot-chat";
              publisher = "GitHub";
              version = "0.15.2024041202";
              sha256 = "18dz59kjl9d0z91vzah7gi3vah2pn2qsi3c7dfnjppxi0inv8k0s";
            }
            {
              name = "github-vscode-theme";
              publisher = "GitHub";
              version = "6.3.4";
              sha256 = "0csh0fai28jx32zdhlfvf9ml34760hq35q8g6slzvdzip03k9ci5";
            }
            {
              name = "vscode-pull-request-github";
              publisher = "GitHub";
              version = "0.87.2024041104";
              sha256 = "1zlls474fcdfn36nbpa1s0942qwp8lap24kaxbs54splr9r07sp4";
            }
            {
              name = "go";
              publisher = "golang";
              version = "0.41.2";
              sha256 = "13fdnwgci87x1rdz1hwq52ling81c3l67cqvmckcjzri2r8gsgvq";
            }
            {
              name = "haskell";
              publisher = "haskell";
              version = "2.5.2";
              sha256 = "09pr3ya77ryj5n80k5srwaxmr0j77f6xp67w0kz324i6fhjd12bq";
            }
            {
              name = "vscode-test-explorer";
              publisher = "hbenl";
              version = "2.21.1";
              sha256 = "022lnkq278ic0h9ggpqcwb3x3ivpcqjimhgirixznq0zvwyrwz3w";
            }
            {
              name = "rest-client";
              publisher = "humao";
              version = "0.25.1";
              sha256 = "19yc3hvhyr2na741z6ajgigxckagvfrcq3h6y958bl4107vxjb0d";
            }
            {
              name = "output-colorizer";
              publisher = "IBM";
              version = "0.1.2";
              sha256 = "0i9kpnlk3naycc7k8gmcxas3s06d67wxr3nnyv5hxmsnsx5sfvb7";
            }
            {
              name = "better-cpp-syntax";
              publisher = "jeff-hykin";
              version = "1.21.1";
              sha256 = "13k0jj4jasq6z4ip9rvzx0g5rkg2fx5p3vl1vnfy3b0v1lz6pryb";
            }
            {
              name = "gruvbox-material-icon-theme";
              publisher = "JonathanHarty";
              version = "1.1.5";
              sha256 = "01p67g44mgik5lp7wb2acv2rki6xf3if0w48qyfsckwawm91d9gk";
            }
            {
              name = "language-haskell";
              publisher = "justusadam";
              version = "3.6.0";
              sha256 = "115y86w6n2bi33g1xh6ipz92jz5797d3d00mr4k8dv5fz76d35dd";
            }
            {
              name = "restructuredtext";
              publisher = "lextudio";
              version = "190.1.20";
              sha256 = "13zqpkd0gk1xh1vpc5x3zzy4nlkyzr9ap7a95in9z2y5pk6hp8px";
            }
            {
              name = "vscode-clangd";
              publisher = "llvm-vs-code-extensions";
              version = "0.1.28";
              sha256 = "1kys452zd99519jwvw5yqil0lm8wjvfaczsb555l0lk9lligbn35";
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
              name = "rainbow-csv";
              publisher = "mechatroner";
              version = "3.11.0";
              sha256 = "1qwjvrrvvfirli76km5ddsl3v45xxr5rnm30h1cfmysj88x3rp7d";
            }
            {
              name = "dotenv";
              publisher = "mikestead";
              version = "1.0.1";
              sha256 = "0rs57csczwx6wrs99c442qpf6vllv2fby37f3a9rhwc8sg6849vn";
            }
            {
              name = "python";
              publisher = "ms-python";
              version = "2024.5.11021008";
              sha256 = "11mnnbdl7cqr18s2cvv2132rrq1f5zslnihp5i2jpa2awjak8wjj";
            }
            {
              name = "vscode-pylance";
              publisher = "ms-python";
              version = "2024.4.101";
              sha256 = "13yi6v1l7k1g0r7fhw3gasv7drn03slh0lxp6pcmqlrajkp0cn1n";
            }
            {
              name = "remote-containers";
              publisher = "ms-vscode-remote";
              version = "0.357.0";
              sha256 = "1vlynddqsma2m11s47xh8ykhvv915j6l7hdfqas1vdarr5cqk54l";
            }
            {
              name = "test-adapter-converter";
              publisher = "ms-vscode";
              version = "0.1.9";
              sha256 = "0av9h6pnq9vb5c13ilywn32pfasjmd2jxaz416r4vhjs0n2f779k";
            }
            {
              name = "vetur";
              publisher = "octref";
              version = "0.37.3";
              sha256 = "110wn2cfmdd64ry34234d3z27ph2chlgd0c9d8c918vdwqnba66y";
            }
            {
              name = "vscode-gitignore-generator";
              publisher = "piotrpalarz";
              version = "1.0.3";
              sha256 = "0yf3h7hd2vx8ic8fgmphad2al3d9w7a9vxis63nwd4fphn9678vs";
            }
            {
              name = "vscode-yaml";
              publisher = "redhat";
              version = "1.14.0";
              sha256 = "0pww9qndd2vsizsibjsvscz9fbfx8srrj67x4vhmwr581q674944";
            }
            {
              name = "LiveServer";
              publisher = "ritwickdey";
              version = "5.7.9";
              sha256 = "0dycc18i1zn20zgh5ymqbi1nmg2an49ndf9r2w6dr5lx8d49hh63";
            }
            {
              name = "nunjucks";
              publisher = "ronnidc";
              version = "0.3.1";
              sha256 = "0dlsri0dcligjz3x1ddpjhyvna6dmdswhb86c9k73y22r12fd1zd";
            }
            {
              name = "crates";
              publisher = "serayuzgur";
              version = "0.6.6";
              sha256 = "1w9vpr0c1aj6m61dmfwwnix2nvna4xmv6iscsam7hbhci3a0fyhx";
            }
            {
              name = "trailing-spaces";
              publisher = "shardulm94";
              version = "0.4.1";
              sha256 = "15i1xcd7p6xfb8kj90irznf4xw48mmwzc528zrk3kiniy9nkbcd4";
            }
            {
              name = "rewrap";
              publisher = "stkb";
              version = "17.8.0";
              sha256 = "1y168ar01zxdd2x73ddsckbzqq0iinax2zv3d95nhwp9asjnbpgn";
            }
            {
              name = "code-spell-checker";
              publisher = "streetsidesoftware";
              version = "3.0.1";
              sha256 = "0i76gf7zr0j4dr02zmxwfphk6yy8rvlj9rzq3k8pvnlfzkmh9ri9";
            }
            {
              name = "rainbow-bracket";
              publisher = "tal7aouy";
              version = "1.0.2";
              sha256 = "0iiinlxlkgbbyn65jw7n0816mnq3m5davhvfgmx9z9673ik7shhz";
            }
            {
              name = "even-better-toml";
              publisher = "tamasfe";
              version = "0.19.2";
              sha256 = "0q9z98i446cc8bw1h1mvrddn3dnpnm2gwmzwv2s3fxdni2ggma14";
            }
            {
              name = "tauri-vscode";
              publisher = "tauri-apps";
              version = "0.2.6";
              sha256 = "03nfyiac562kpndy90j7vc49njmf81rhdyhjk9bxz0llx4ap3lrv";
            }
            {
              name = "gruvbox-themes";
              publisher = "tomphilbin";
              version = "1.0.0";
              sha256 = "0xykf120j27s0bmbqj8grxc79dzkh4aclgrpp1jz5kkm39400z0f";
            }
            {
              name = "vscode-lldb";
              publisher = "vadimcn";
              version = "1.10.0";
              sha256 = "0s7lwvq7fmd2hms6qlbvq0g17gaf896kqkphdazp3l5h8knay0j4";
            }
            {
              name = "clang-format";
              publisher = "xaver";
              version = "1.9.0";
              sha256 = "0bwc4lpcjq1x73kwd6kxr674v3rb0d2cjj65g3r69y7gfs8yzl5b";
            }
            {
              name = "markdown-all-in-one";
              publisher = "yzhang";
              version = "3.6.2";
              sha256 = "1n9d3qh7vypcsfygfr5rif9krhykbmbcgf41mcjwgjrf899f11h4";
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
