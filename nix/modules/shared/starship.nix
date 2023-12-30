# https://nix-community.github.io/home-manager/options.html#opt-programs.starship.enable
{ pkgs, lib, config, options, ... }:

let
  cfg = config.my.modules.starship;

in

{
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
          format = "$character $directory$git_branch$git_commit$git_status$rust$nodejs$deno";
          right_format = "$cmd_duration";
          continuation_prompt = "[∙](bright-white) ";
          add_newline = true;
          line_break.disabled = true;
          scan_timeout = 10;

          cmd_duration = {
            min_time = 5000;
            format = "[\\(](bold)⏱  [$duration](bold yellow)[\\)](bold) ";
            show_milliseconds = false;
          };
          character = {
            format = "$symbol";
            # ▶ ᗌ ᗎ 🧨 💥
            success_symbol = "[➜](bold green)";
            error_symbol = "[✶](bold red)";
            vicmd_symbol = "[⌘](bold #ff33b8)";
          };
          nix_shell = {
            format = "via [$symbol( $name)$state]($style) ";
            impure_msg = " ";
            pure_msg = "";
            symbol = "❄ ";
          };

          # directory = {
          #   format = "[\\[](bold)[$path](bold 226)[$read_only](bold)[\\]](bold) ";
          #   truncation_length = 2;
          #   truncate_to_repo = false;
          #   truncation_symbol = "…/";
          # };
          git_branch = {
            symbol = "";
            # format = "[\\(](bold)[$branch](bold 206) [:](bold) ";
            format = "[\\($symbol](bold)[$branch](bold 206) ";
            truncation_length = 15;
            truncation_symbol = "…";
            always_show_remote = true;
          };
          git_status = {
            # format = '([$all_status](bold red)\) )';
            format = "[:](bold) ([$all_status](bold red))[\\)](bold) ";
            ahead = "⇡\${count}";
            diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
            behind = "⇣\${count}";
          };
          git_commit = {
            commit_hash_length = 7;
            # ⤠
            format = "[ﰖ](bold) [$hash$tag](bold yellow underline) ";
            tag_disabled = false;
            tag_symbol = "🔖 ";
          };
          git_metrics = {
            disabled = false;
            only_nonzero_diffs = true;
            added_style = "bold green";
            deleted_style = "bold red";
            format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
            # format = "[+$added]($added_style)/[-$deleted]($deleted_style) ";
          };
          rust = {
            format = "\\([$symbol$version](bold 208)\\) ";
          };
          nodejs = {
            symbol = "⬢";
            format = "[\\(](bold)[$symbol ($version )](bold 063)[\\)](bold) ";
          };
          battery = {
            disabled = true;
          };

        };
      };
    };
}
