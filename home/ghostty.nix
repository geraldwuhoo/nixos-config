{ config, pkgs, ... }:
let
  # GTK4 treats the first xdg_toplevel.configure_bounds as a hard maximum,
  # and KWin only sends it for the monitor where the window opened. This
  # raises that ceiling for Ghostty. Other GTK4 apps are unchanged.
  # Building KWin just to resend the event takes a long time, and the
  # running compositor cannot load a new binary without ending the session.
  gtkBoundsHook = pkgs.stdenv.mkDerivation {
    pname = "gtk-configure-bounds-hook";
    version = "1";
    dontUnpack = true;
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.wayland ];
    buildPhase = ''
      $CC -shared -fPIC -O2 -o libgtk-bounds.so ${./gtk-bounds-hook.c} \
        $(${pkgs.pkg-config}/bin/pkg-config --cflags --libs wayland-client)
    '';
    installPhase = ''
      mkdir -p $out/lib
      cp libgtk-bounds.so $out/lib/
    '';
  };
  ghosttyPkg = pkgs.symlinkJoin {
    name = "ghostty-gtk-bounds";
    paths = [ pkgs.ghostty ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    meta = pkgs.ghostty.meta // {
      mainProgram = "ghostty";
    };
    postBuild = ''
      wrapProgram $out/bin/ghostty \
        --prefix LD_PRELOAD : ${gtkBoundsHook}/lib/libgtk-bounds.so
    '';
  };
  ghostty = "${config.programs.ghostty.package}/bin/ghostty";
  launch = pkgs.writeShellScript "ghostty-launch" ''
    ${ghostty} +new-window || exec ${ghostty} --gtk-single-instance=true
  '';
in
{
  programs.ghostty = {
    enable = true;
    package = ghosttyPkg;

    # alacritty's defaults, where ghostty's differ.
    settings = {
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
