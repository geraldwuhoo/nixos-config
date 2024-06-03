{ lib, ... }:
{
  imports = [
    # Core
    ./boot.nix
    ./user.nix

    # System
    ./bluetooth.nix
    ./ceph-client.nix
    ./clevis.nix
    ./nvidia.nix
    ./oci.nix
    ./openssh.nix
    ./pipewire.nix
    ./plasma.nix
    ./tor.nix
    ./virtualisation.nix

    # Niceties
    ./barrier.nix
    ./mullvad.nix
    ./steam.nix
    ./stylix.nix

    # Misc
    ./misc.nix
  ];

  clevis.enable = lib.mkDefault true;
  oci.enable = lib.mkDefault true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      # Nvidia
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "cudatoolkit"

      # Steam
      "steam"
      "steam-original"
      "steam-run"
    ];

  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
}
