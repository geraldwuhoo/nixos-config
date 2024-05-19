{ ... }: {
  imports = [ ./x11.nix ];

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "jerry";
  };
  services.xserver.desktopManager.plasma5.enable = true;
  security.pam.services.jerry.enableKwallet = true;
}
