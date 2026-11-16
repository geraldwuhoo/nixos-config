{ config, pkgs, ... }:
let
  ghostty = "${config.programs.ghostty.package}/bin/ghostty";
  launch = pkgs.writeShellScript "ghostty-launch" ''
    ${ghostty} +new-window || exec ${ghostty} --gtk-single-instance=true
  '';
in
{
  programs.ghostty = {
    enable = true;

    settings = {
      theme = "light:Nord Day,dark:Nord";
      font-family = "DejaVuSansM Nerd Font";
      font-size = 9;
      background-opacity = 0.95;

      # alacritty's defaults, where ghostty's differ.
      window-padding-x = 0;
      window-padding-y = 0;
      cursor-style-blink = false;
      confirm-close-surface = false;
      resize-overlay = "never";
      link-previews = false;
      scrollbar = "never";

      # KWin draws the titlebar instead of ghostty drawing a GTK headerbar.
      window-decoration = "server";

      # no-cursor keeps the block cursor at the prompt.
      shell-integration-features = "no-cursor,no-sudo,title,no-ssh-env,no-ssh-terminfo,path";

      # ghostty ships these binds at 1pt.
      keybind = [
        "ctrl+equal=increase_font_size:0.5"
        "ctrl+plus=increase_font_size:0.5"
        "ctrl+minus=decrease_font_size:0.5"
      ];
    };

    # Nord's hues darkened to 4.5:1 on nord4
    themes."Nord Day" = {
      background = "#d8dee9";
      foreground = "#2e3440";
      cursor-color = "#2e3440";
      cursor-text = "#d8dee9";
      selection-background = "#b8c2d3";
      selection-foreground = "#2e3440";
      palette = [
        "0=#3b4252"
        "1=#a73e48"
        "2=#4f6939"
        "3=#7f5b11"
        "4=#44648b"
        "5=#815379"
        "6=#2c687a"
        "7=#c2cad8"
        "8=#616e88"
        "9=#a73e48"
        "10=#4f6939"
        "11=#7f5b11"
        "12=#44648b"
        "13=#815379"
        "14=#3c6968"
        "15=#eceff4"
      ];
    };
  };

  # Launched by Meta+Return, see plasma.nix.
  xdg.desktopEntries."ghostty-launch" = {
    name = "ghostty +new-window";
    exec = "${launch}";
    noDisplay = true;
    startupNotify = false;
    settings."X-KDE-GlobalAccel-CommandShortcut" = "true";
  };
}
