{ pkgs, ... }:
let
  # GTK4 treats the first xdg_toplevel.configure_bounds as a hard maximum,
  # and KWin only sends it for the monitor where the window opened. This
  # raises that ceiling in every GTK4 app and leaves other toolkits alone.
  # Patching GTK4 would rebuild everything that links it, and patching
  # KWin needs a session restart to load.
  gtkBoundsHook = pkgs.stdenv.mkDerivation {
    pname = "gtk-configure-bounds-hook";
    version = "2";
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
in
{
  # Plasma starts under systemd, so environment.d reaches every app it launches.
  systemd.user.sessionVariables.LD_PRELOAD = "${gtkBoundsHook}/lib/libgtk-bounds.so";
}
