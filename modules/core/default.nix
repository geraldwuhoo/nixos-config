{ lib, config, ... }:
{
  imports = [
    # Core
    ./boot.nix
    ./hardening.nix
    ./lan.nix
    ./memory.nix
    ./user.nix

    # System
    ./bluetooth.nix
    ./ceph-client.nix
    ./clevis.nix
    ./ipfs.nix
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
    ./piper.nix
    ./psd.nix
    ./steam.nix
    ./stylix.nix
    ./sunshine.nix

    # Misc
    ./misc.nix
  ];

  oci.enable = lib.mkDefault true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.settings.extra-substituters = [ "https://cuda-maintainers.cachix.org" ];
  nix.settings.extra-trusted-public-keys = [
    "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      # Nvidia
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "libnpp"

      # Steam
      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"

      # Vim
      "vim-trailing-whitespace"
      "vim-windowswap"
    ]
    # CUDA packages
    || lib.hasPrefix "cuda" (lib.getName pkg)
    || lib.hasPrefix "libcu" (lib.getName pkg)
    || lib.hasPrefix "libnv" (lib.getName pkg);

  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    interfaces.${config.lanInterface} = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [
        22000
        21027
      ];
    };
  };
}
