{ pkgs, ... }:
let
  gruvbox-theme = pkgs.fetchFromGitHub {
    owner = "austinwagner";
    repo = "gruvbox-sublime";
    rev = "0fe9cb7208c17ef318b573ba9ab44e0becc59a71";
    sha256 = "1l9gnpry0ijmlkdh6qr5njyn1yd96ahlhhgvh8kb7cmmz5kymyd0";
  };
in
{
  enable = true;
  config = { theme = "gruvbox"; };

  themes = {
    gruvbox = builtins.readFile "${gruvbox-theme}/gruvbox.tmTheme";
  };
}
