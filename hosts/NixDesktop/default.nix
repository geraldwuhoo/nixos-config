{ inputs, ... }:
{
  imports = [
    ../../modules/core

    inputs.sops-nix.nixosModules.sops

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "NixDesktop"; # Define your hostname.
  networking.hostId = "86474ef9";

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure sops location
  sops.defaultSopsFile = ../../secrets/secrets.sops.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/var/lib/sops/age/keys.txt";

  # Set up Clevis auto-unlock
  # boot.initrd.kernelModules = [ "xhci_pci" "tpm_crb" "tpm_tis" "igb" "iwlwifi" ];
  # boot.initrd.network = {
  #   enable = true;
  #   udhcpc.enable = true;
  # };
  # boot.initrd.clevis = {
  #   enable = true;
  #   useTang = true;
  #   devices."zroot/ROOT/nix".secretFile = ./zroot.jwe;
  # };

  stylix.image = ./wallpaper.jpg;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
