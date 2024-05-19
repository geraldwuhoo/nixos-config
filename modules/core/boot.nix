{ ... }: {
  # GRUB config for ZFS
  boot.loader.timeout = 1;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    timeoutStyle = "countdown";
    mirroredBoots = [{
      devices = [ "nodev" ];
      path = "/boot";
    }];
  };

  # Clean /tmp on every boot
  boot.tmp = { cleanOnBoot = true; };
}
