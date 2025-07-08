{ pkgs, ... }:
{
  imports = [ ./x11.nix ];

  # display-manager
  services.displayManager = {
    enable = true;
    # ly.enable = true;
    sddm.enable = true;
  };

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.libsForQt5; [];

  # Relevant plugins and themes
  environment.systemPackages = with pkgs; [
    kdePackages.krohnkite
    nordic
  ];

  # Open KDE connect ports
  programs.kdeconnect.enable = true;

  # Enable kwallet related things
  security.pam.services.jerry.enableKwallet = true;
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
    settings = {
      default-cache-ttl = 2592000;
      max-cache-ttl = 2592000;
    };
  };
}
