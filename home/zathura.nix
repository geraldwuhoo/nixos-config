{ ... }:
{
  programs.zathura = {
    enable = true;
    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      D = "toggle_page_mode";
      r = "reload";
      R = "rotate";
      i = "recolor";
      p = "print";
    };
    options = {
      selection-clipboard = "clipboard";
      statusbar-h-padding = "0";
      statusbar-v-padding = "0";
      page-padding = "1";
    };
  };
}
