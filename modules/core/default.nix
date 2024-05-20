{ lib, ... }: {
  imports = [
    ./boot.nix
    ./user.nix
    ./openssh.nix
    ./nvidia.nix
    ./ceph-client.nix
    ./pipewire.nix
    ./bluetooth.nix
    ./stylix.nix
    ./plasma.nix
    ./mullvad.nix
    ./barrier.nix
    ./virtualisation.nix
    ./steam.nix
    ./misc.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
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
