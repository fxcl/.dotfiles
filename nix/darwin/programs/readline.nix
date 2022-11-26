{ pkgs, ... }:

{
  enable = true;
  variables = { editing-mode = "vi"; };

  bindings = {
    "\e[5~" = "history-search-backward";
    "\e[6~" = "history-search-forward";
  };
}
