{ pkgs, ... }:
{
  # KVM stuff
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
      };
    };
  };
  programs.virt-manager.enable = true;

  # OCI stuff
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    dockerSocket.enable = true;
  };

  hardware.nvidia-container-toolkit.enable = true;
}
