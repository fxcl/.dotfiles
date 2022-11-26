{ pkgs, ... }:
let
  username = "kelvin";

in
{
  enable = true;
  enableZshIntegration = true;

  defaultCommand = ''rg --files --no-ignore --hidden --follow -g \"!{.git,node_modules}/*\" 2> /dev/null'';
  defaultOptions = [
    "--ansi"
    "--layout=default"
    "--info=inline"
    "--height=50%"
    "--multi"
    "--preview-window=right:50%"
    "--preview-window=sharp"
    "--preview-window=cycle"
    "--prompt='λ -> '"
    "--pointer='|>'"
    "--marker='✓'"
    "--bind 'ctrl-e:execute(vim {} < /dev/tty > /dev/tty 2>&1)' > selected"
    "--bind 'ctrl-v:execute(code {+})'"
  ];
  fileWidgetCommand = ''rg --files --no-ignore --hidden --follow -g \"!{.git,node_modules}/*\" 2> /dev/null'';

  changeDirWidgetCommand = "fd --type d";
  changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];

}
