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

    # alacritty's defaults, where ghostty's differ.
    settings = {
      window-padding-x = 0;
      window-padding-y = 0;
      cursor-style-blink = false;
      confirm-close-surface = false;
      resize-overlay = "never";
      link-previews = false;

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
