{ pkgs, ... }:
{
  # display-manager
  services.displayManager = {
    enable = true;
    # ly.enable = true;
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "plasma";
  };

  # Electron/Chromium apps otherwise run blurry under XWayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # for rofi-rbw typing; wtype doesn't work on kwin
  programs.ydotool.enable = true;

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.libsForQt5; [ ];

  # Relevant plugins and themes
  environment.systemPackages = with pkgs; [
    # Wayland ignores a frameGeometry write while the window is on another
    # desktop, so a terminal sent there keeps its old size. The patch
    # arranges again once that desktop is showing, and retries a rejected size.
    (kdePackages.krohnkite.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./krohnkite-wayland-size.patch ];
    }))
    nordic
  ];

  # Open KDE connect ports
  programs.kdeconnect.enable = true;

  # Enable kwallet related things
  security.pam.services.jerry.enableKwallet = true;
  services.pcscd.enable = true;
}
