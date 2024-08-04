# https://nix-community.github.io/home-manager/options.html#opt-programs.starship.enable
{ pkgs, lib, config, options, ... }:

let cfg = config.my.modules.starship;

in {
  options = with lib; {
    my.modules.starship = {
      enable = mkEnableOption ''
        Whether to enable starship module
      '';
    };
  };

  config = with lib;
    mkIf cfg.enable {
      my.hm.programs.starship = {
        enable = true;
        enableZshIntegration = true;

        settings = {
          format = lib.concatStrings [
            "$character"
            # "$username"
            # "$hostname"
            "$shlvl"
            "$directory"
          ];
          # right_format = "$all";
          right_format = lib.concatStrings [
            "$status"
            "$cmd_duration"
            "$sudo"
            "$package"
            "$c"
            "$cmake"
            "$cobol"
            "$daml"
            "$dart"
            "$deno"
            "$dotnet"
            "$elixir"
            "$elm"
            "$erlang"
            "$fennel"
            "$golang"
            "$guix_shell"
            "$haskell"
            "$haxe"
            "$helm"
            "$java"
            "$julia"
            "$kotlin"
            "$gradle"
            "$lua"
            "$nim"
            "$nodejs"
            "$ocaml"
            "$opa"
            "$perl"
            "$php"
            "$pulumi"
            "$purescript"
            "$python"
            "$raku"
            "$rlang"
            "$red"
            "$ruby"
            "$rust"
            "$scala"
            "$swift"
            "$terraform"
            "$vlang"
            "$vagrant"
            "$zig"
            "$buf"
            "$nix_shell"
            "$conda"
            "$meson"
            "$spack"
            "$memory_usage"
            "$aws"
            "$gcloud"
            "$openstack"
            "$azure"
            "$env_var"
            "$crystal"
            "$git_branch"
            "$git_commit"
            "$git_state"
            "$git_metrics"
            "$git_status"
            "$kubernetes"
            "$time"
            "$battery"
          ];
          add_newline = false;
          command_timeout = 3600000;
          scan_timeout = 500;
          palette = "custom";
          palettes.custom = {
            blue = "#9db8e9";
            green = "#98C379";
            red = "#BF616A";
            orange = "#FFCC80";
            yellow = "#FFEB3B";
          };

          character = {
            success_symbol = "[➜](bold purple)";
            error_symbol = "[✖](bold red)";
            vicmd_symbol = "[◀◀ ](bold green)";
          };
          hostname = {
            ssh_symbol = "󰌘";
            format = "[$ssh_symbol$hostname ]($style)";
            style = "bold orange";
          };
          shlvl = {
            disabled = false;
            symbol = "";
            style = "dimmed blue";
          };
          directory = {
            style = "bold blue";
            truncate_to_repo = false;
            before_repo_root_style = "dimmed";
            repo_root_style = "bold bright-blue";
            truncation_length = 100;
            truncation_symbol = "…/";
          };

          status = {
            disabled = false;
            format =
              "[$symbol$common_meaning$maybe_int$signal_name$signal_number]($style) ";
          };
          cmd_duration = {
            format = "[$duration]($style) ";
            style = "dimmed";
          };

          package.format = "[$symbol($version)]($style) ";

          crystal.format = "[$symbol($version)]($style) ";
          elixir.format = "[$symbol($version)]($style) ";
          erlang.format = "[$symbol($version)]($style) ";
          golang.format = "[$symbol($version)]($style) ";
          haskell.format = "[$symbol($version)]($style) ";
          lua.format = "[$symbol($version)]($style) ";
          python.format = "[$symbol($version)]($style) ";
          rust.format = "[$symbol($version)]($style) ";

          golang.symbol = " ";
          elixir.symbol = " ";

          elixir.detect_extensions = [ "ex" "exs" ];
          erlang.detect_extensions = [ "erl" ];
          nodejs.detect_extensions = [ "cjs" "cts" ];

          nix_shell.disabled = true;

          git_branch = {
            style = "dimmed green";
            symbol = "";
            format = "[$symbol](dimmed)[$branch(:$remote_branch)]($style) ";
          };
          git_commit = { };
          git_state = { };
          git_metrics = { disabled = false; };
          git_status = {
            format =
              "(\\[$staged$conflicted$deleted$renamed$modified$ahead_behind$untracked$stashed\\] )";

            conflicted = "[󰘕$count](bright-red)";
            ahead = "[⇡$count](dimmed green)";
            behind = "[⇣$count](dimmed red)";
            diverged = "[⇕⇡$ahead_count⇣$behind_count](red)";
            untracked = "[󱀶$count](dimmed red)";
            stashed = "[$count](dimmed yellow)";
            modified = "[$count](orange)";
            staged = "[$count](green)";
            renamed = "[»$count](orange)";
            deleted = "[✘$count](red)";
          };

          kubernetes = {
            disabled = false;
            symbol = "󱃾";
            format =
              "[$symbol](bold blue)\\([$context](blue)(:[$namespace](dimmed blue))\\) ";
            contexts = [{
              context_pattern = "nucles";
              context_alias = "";
            }];
            detect_extensions = [ "yaml" "cue" ];
            # detect_folders = ["homelab"];
          };

          time = {
            disabled = false;
            format = "[$time]($style) ";
            style = "dimmed";
          };
          battery = {
            charging_symbol = "󰂄 "; # nf-md-battery_charging
            discharging_symbol = "󰂃 "; # nf-md-battery_alert
          };
        };
      };
    };
}
