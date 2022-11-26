{ pkgs, ... }:
let
  light = {
    bg = "#F5F5F9";
    bg-alt = "#E9E9F2";
    base0 = "#D0D0E3";
    base1 = "#D0D0E3";
    base2 = "#C0CCD0";
    base3 = "#9EA6B0";
    base4 = "#585C6C";
    base5 = "#4E4E4E";
    base6 = "#3A3A3A";
    base7 = "#303030";
    base8 = "#1E1E33";
    fg = "#0F1019";
    fg-alt = "#0D0E16";
    grey = "#4E4E4E";
    red = "#D70000";
    orange = "#D75F00";
    green = "#005F00";
    teal = "#009B7C";
    yellow = "#AF8700";
    blue = "#1F55A0";
    dark-blue = "#DEEAF8";
    magenta = "#AF005F";
    violet = "#8700AF";
    cyan = "#007687";
    dark-cyan = "#D5FAFF";
  };
  dark = {
    bg = "#0D0E16";
    bg-alt = "#040408";
    base0 = "#0F1019";
    base1 = "#121212";
    base2 = "#1E1E33";
    base3 = "#464A56";
    base4 = "#585C6C";
    base5 = "#767676";
    base6 = "#959EA5";
    base7 = "#B2B2B2";
    base8 = "#D0D0D0";
    fg = "#CEDBE5";
    fg-alt = "#E5F4FF";
    grey = "#767676";
    red = "#D83441";
    orange = "#D85F00";
    green = "#79D836";
    teal = "#2D9574";
    yellow = "#D8B941";
    blue = "#3679D8";
    dark-blue = "#0C213E";
    magenta = "#8041D8";
    violet = "#AB11D8";
    cyan = "#36D8BD";
    dark-cyan = "#092D27";
  };
in
{
  enable = false;
  options = {
    default-bg = light.bg;
    default-fg = light.fg;

    statusbar-bg = light.bg-alt;
    statusbar-fg = light.fg-alt;

    inputbar-bg = light.bg-alt;
    inputbar-fg = light.fg-alt;

    notification-bg = light.teal;
    notification-fg = light.fg-alt;

    notification-error-bg = light.red;
    notification-error-fg = light.fg-alt;

    notification-warning-bg = light.yellow;
    notification-warning-fg = light.fg-alt;

    highlight-color = light.blue;
    highlight-active-color = light.yellow;

    completion-bg = light.bg-alt;
    completion-fg = light.fg-alt;

    completion-highlight-bg = light.base8;
    completion-highlight-fg = light.cyan;

    recolor-lightcolor = light.base8;
    recolor-darkcolor = light.base0;
    recolor = true;
    recolor-keephue = true;
  };
}
