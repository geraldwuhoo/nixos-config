{ pkgs, ... }:
{
  imports = [ ./x11.nix ];

  # display-manager
  #services.displayManager.sddm.enable = true;
  services.displayManager = {
    enable = true;
    ly.enable = true;
  };

  # Enable Plasma 5 because Plasma 6 extension compatibility
  services.xserver.desktopManager.plasma5.enable = true;
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    konsole # I don't need it since I have other terminal emulators
  ];

  # Relevant plugins and themes
  environment.systemPackages = with pkgs; [
    libsForQt5.bismuth
    nordic
  ];

  # Open KDE connect ports
  programs.kdeconnect.enable = true;

  # Enable kwallet related things
  security.pam.services.jerry.enableKwallet = false;
  # services.pcscd.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = false;
  #   settings = {
  #     default-cache-ttl = 2592000;
  #     max-cache-ttl = 2592000;
  #   };
  # };
}
