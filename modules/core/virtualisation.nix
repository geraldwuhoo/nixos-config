{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    virtual.enable = lib.mkEnableOption "enables virtualisation";
  };

  config = lib.mkIf config.virtual.enable {
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
  };
}
