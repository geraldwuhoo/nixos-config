{ config, lib, pkgs, ... }:
let
  utterly-nord = pkgs.fetchFromGitHub {
    owner = "HimDek";
    repo = "Utterly-Nord-Plasma";
    rev = "ae0de9d555b518226627b2d10ee5df4a18073c60";
    hash = "sha256-lXX7Gk2QYyMP96qbYdHtommW0DM1DUK03cti1gAeBBc=";
  };

  # Plasma's auto switcher applies whole global themes. These only carry colours
  # and the Plasma style, so icons, cursor and decoration stay put.
  mkLookAndFeel =
    { id, name, colorScheme, plasmaTheme }:
    pkgs.runCommand id { } ''
      dir=$out/share/plasma/look-and-feel/${id}
      mkdir -p $dir/contents
      cat > $dir/metadata.json <<'EOF'
      ${builtins.toJSON {
        KPackageStructure = "Plasma/LookAndFeel";
        KPlugin = {
          Id = id;
          Name = name;
          License = "GPL-2.0+";
        };
      }}
      EOF
      cat > $dir/contents/defaults <<'EOF'
      [kdeglobals][General]
      ColorScheme=${colorScheme}

      [plasmarc][Theme]
      name=${plasmaTheme}
      EOF
    '';

  # https://www.nordtheme.com/docs/colors-and-palettes
  nord = {
    nord0 = "#2e3440";
    nord1 = "#3b4252";
    nord2 = "#434c5e";
    nord3 = "#4c566a";
    nord4 = "#d8dee9";
    nord5 = "#e5e9f0";
    nord6 = "#eceff4";
    nord7 = "#8fbcbb";
    nord9 = "#81a1c1";
    nord10 = "#5e81ac";
    nord11 = "#bf616a";
  };

  palettes = with nord; {
    dark = {
      rofi = {
        background = nord0;
        lightbg = nord1;
        foreground = nord5;
        lightfg = nord6;
        blue = nord9;
        red = nord11;
      };
      zathura = {
        default-bg = nord0;
        default-fg = nord1;
        statusbar-bg = nord2;
        statusbar-fg = nord4;
        inputbar-bg = nord0;
        inputbar-fg = nord7;
        notification-bg = nord0;
        notification-fg = nord7;
        notification-error-bg = nord0;
        notification-error-fg = nord11;
        notification-warning-bg = nord0;
        notification-warning-fg = nord11;
        completion-bg = nord1;
        completion-fg = nord9;
        completion-highlight-bg = nord9;
        completion-highlight-fg = nord7;
        highlight-color = "rgba(235,203,139,0.5)";
        highlight-active-color = "rgba(129,161,193,0.5)";
        recolor-lightcolor = nord0;
        recolor-darkcolor = nord6;
      };
    };
    light = {
      rofi = {
        background = nord6;
        lightbg = nord5;
        foreground = nord0;
        lightfg = nord1;
        blue = nord10;
        red = nord11;
      };
      zathura = {
        default-bg = nord6;
        default-fg = nord1;
        statusbar-bg = nord4;
        statusbar-fg = nord1;
        inputbar-bg = nord6;
        inputbar-fg = nord10;
        notification-bg = nord6;
        notification-fg = nord10;
        notification-error-bg = nord6;
        notification-error-fg = nord11;
        notification-warning-bg = nord6;
        notification-warning-fg = nord11;
        completion-bg = nord5;
        completion-fg = nord10;
        completion-highlight-bg = nord10;
        completion-highlight-fg = nord6;
        highlight-color = "rgba(235,203,139,0.5)";
        highlight-active-color = "rgba(94,129,172,0.5)";
        recolor-lightcolor = nord6;
        recolor-darkcolor = nord0;
      };
    };
  };

  # rofi and zathura read their colours from here on every launch; the follower
  # points it at the dark or light set.
  current = "${config.xdg.stateHome}/day-night/current";

  k9sNord = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/derailed/k9s/master/skins/nord.yaml";
    sha256 = "1qbmfxjjaa0xzj2p5x0yb60pdn3yzrx8dsrpmrfzz2h8kmj8ipll";
  };
  k9sNordDay = pkgs.writeText "k9s-nord-day.yaml" (
    builtins.replaceStrings
      [ "#DADEE8" "#30343F" "#383D4A" "#D9DEE8" "#8891A7" "#88C0D0" "#A3BE8C" "#D08770" "#81A1C1" "#B48EAD" "#BF616A" "#EBCB8B" ]
      [ "#2E3440" "#E5E9F0" "#C2CAD8" "#4C566A" "#616E88" "#2C687A" "#4F6939" "#9D492E" "#44648B" "#815379" "#A73E48" "#7F5B11" ]
      (builtins.readFile k9sNord)
  );

  nordTmux = "${pkgs.tmuxPlugins.nord}/share/tmux-plugins/nord/src";
  prefixHighlight = "${pkgs.tmuxPlugins.prefix-highlight}/share/tmux-plugins/prefix-highlight/prefix_highlight.tmux";
  tmuxNord = pkgs.runCommand "tmux-nord.conf" { } ''
    cat ${nordTmux}/nord.conf ${nordTmux}/nord-status-content.conf |
      sed -e 's/''${NORD_TMUX_STATUS_DATE_FORMAT}/%Y-%m-%d/' \
          -e 's/''${NORD_TMUX_STATUS_TIME_FORMAT}/%I:%M %p/' > $out
  '';
  tmuxNordDay = pkgs.runCommand "tmux-nord-day.conf" { } ''
    sed -e 's/\bbrightblack\b/@7@/g' -e 's/\bblack\b/brightwhite/g' \
        -e 's/\bwhite\b/black/g' -e 's/@7@/white/g' ${tmuxNord} > $out
    echo 'set -g pane-border-style bg=default,fg=brightblack' >> $out
  '';
  # prefix-highlight fills #{prefix_highlight} into status-right once, so rerun it
  # after status-right is set.
  tmuxConf = nord: pkgs.writeText "tmux-colours.conf" ''
    source-file ${nord}
    run-shell ${prefixHighlight}
  '';

  schemeFiles = lib.mapAttrs (
    mode: p:
    pkgs.linkFarm "day-night-${mode}" {
      "mode" = pkgs.writeText "mode" mode;
      "fzfrc" = pkgs.writeText "fzfrc-${mode}" "--color=${mode}\n";
      "k9s.yaml" = if mode == "light" then k9sNordDay else k9sNord;
      "tmux.conf" = tmuxConf (if mode == "light" then tmuxNordDay else tmuxNord);
      "rofi.rasi" = pkgs.writeText "rofi-${mode}.rasi" ''
        * {
        ${lib.concatStrings (lib.mapAttrsToList (n: v: "  ${n}: ${v};\n") p.rofi)}}
      '';
      "zathurarc" = pkgs.writeText "zathurarc-${mode}" (
        lib.concatStrings (lib.mapAttrsToList (n: v: ''set ${n} "${v}"'' + "\n") p.zathura)
      );
    }
  ) palettes;

  # GTK3 has no light/dark switch of its own; it only knows theme names.
  follow = pkgs.writeShellScript "follow-color-scheme" ''
    apply() {
      # 1 is dark; fall back to it when the portal isn't up yet
      scheme=$(${pkgs.systemd}/bin/busctl --user call org.freedesktop.portal.Desktop \
        /org/freedesktop/portal/desktop org.freedesktop.portal.Settings \
        ReadOne ss org.freedesktop.appearance color-scheme) || scheme=1
      if [ "''${scheme##* }" = 1 ]; then
        theme=Nordic pref=prefer-dark claude=dark-ansi files=${schemeFiles.dark}
      else
        theme=Nordic-Polar pref=default claude=light-ansi files=${schemeFiles.light}
      fi
      mkdir -p ${dirOf current}
      ln -sfn "$files" ${current}
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'$theme'" || true
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'$pref'" || true
      ${config.programs.tmux.package}/bin/tmux source-file ${current}/tmux.conf 2>/dev/null || true

      # Claude Code has no automatic theme; this applies when settings.json sets none
      cfg=$HOME/.claude.json
      if [ -f "$cfg" ] && [ "$(${pkgs.jq}/bin/jq -r .theme "$cfg")" != "$claude" ]; then
        ${pkgs.jq}/bin/jq --arg t "$claude" '.theme = $t' "$cfg" > "$cfg.day-night" &&
          chmod --reference="$cfg" "$cfg.day-night" &&
          mv "$cfg.day-night" "$cfg"
      fi
    }

    apply
    [ "''${1:-}" = watch ] || exit 0
    ${pkgs.dbus}/bin/dbus-monitor --session \
      "type='signal',interface='org.freedesktop.portal.Settings',member='SettingChanged',arg0='org.freedesktop.appearance',arg1='color-scheme'" |
      while read -r line; do
        case $line in *member=SettingChanged*) apply ;; esac
      done
  '';
in
{
  home.packages = [
    (pkgs.runCommand "utterly-nord-light-colors" { } ''
      install -Dm644 ${utterly-nord}/UtterlyNordLight.colors -t $out/share/color-schemes
    '')
    (mkLookAndFeel {
      id = "nordic-night";
      name = "Nordic Night";
      colorScheme = "Nordic";
      plasmaTheme = "Nordic";
    })
    # Breeze's Plasma style takes its colours from the colour scheme.
    (mkLookAndFeel {
      id = "nordic-day";
      name = "Nordic Day";
      colorScheme = "UtterlyNordLight";
      plasmaTheme = "default";
    })
  ];

  programs.plasma.configFile.kdeglobals.KDE = {
    AutomaticLookAndFeel = true;
    DefaultLightLookAndFeel = "nordic-day";
    DefaultDarkLookAndFeel = "nordic-night";
  };

  programs.rofi.theme = "${pkgs.writeText "nord.rasi" ''
    @import "${current}/rofi.rasi"
    ${builtins.readFile ./files/rofi-nord.rasi}
  ''}";

  programs.zathura.extraConfig = "include ${current}/zathurarc";

  programs.tmux.extraConfig = "source-file -q ${current}/tmux.conf";

  home.sessionVariables.FZF_DEFAULT_OPTS_FILE = "${current}/fzfrc";

  xdg.configFile."k9s/skins/day-night.yaml".source =
    config.lib.file.mkOutOfStoreSymlink "${current}/k9s.yaml";
  programs.k9s.settings.k9s.ui.skin = "day-night";

  # Sunrise and sunset for the switch above and for Night Light.
  sops.secrets.knighttime-latitude = { };
  sops.secrets.knighttime-longitude = { };

  systemd.user.services.knighttime-location = {
    Unit = {
      Description = "Set the day/night location from sops";
      After = [ "sops-nix.service" ];
      Requires = [ "sops-nix.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "knighttime-location" ''
        set -eu
        kwc() {
          ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file knighttimerc --group Location "$@"
        }
        kwc --key Automatic false
        kwc --key Latitude "$(cat ${config.sops.secrets.knighttime-latitude.path})"
        kwc --key Longitude "$(cat ${config.sops.secrets.knighttime-longitude.path})"
        ${pkgs.systemd}/bin/systemctl --user try-restart plasma-knighttimed.service
      '';
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.follow-color-scheme = {
    Unit = {
      Description = "Switch GTK3, rofi and zathura colours with the system colour scheme";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${follow} watch";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # dconfSettings writes the gtk module's dark Nordic back on every switch.
  home.activation.followColorScheme = lib.hm.dag.entryAfter [ "dconfSettings" ] ''
    bus=/run/user/$(id -u)/bus
    if [ -S "$bus" ]; then
      export DBUS_SESSION_BUS_ADDRESS=''${DBUS_SESSION_BUS_ADDRESS:-unix:path=$bus}
    fi
    run ${follow}
  '';
}
