{
  lib,
  config,
  ...
}:
{
  options = {
    clevis = with lib; {
      enable = mkEnableOption "enables clevis auto-unlock";
      jweFile = mkOption {
        type = types.path;
        description = "Path to JWE Clevis file";
      };
      zfsEncryptionroot = mkOption {
        type = types.str;
        description = "The ZFS encryptionroot dataset/pool to decrypt";
        default = "zroot";
      };
      useTpm = mkOption {
        type = types.bool;
        description = "Use the TPM as part of Clevis";
        default = false;
      };
    };
  };

  config = lib.mkIf config.clevis.enable {
    # TPM2 and Network modules for TPM+Tang
    boot.initrd.kernelModules = [
      "xhci_pci"
      "igb"
      "iwlwifi"
    ]
    ++ (
      if config.clevis.useTpm then
        [
          "tpm_crb"
          "tpm_tis"
        ]
      else
        [ ]
    );

    boot.initrd.clevis = {
      enable = true;
      useTang = true;
      devices.${config.clevis.zfsEncryptionroot}.secretFile = config.clevis.jweFile;
    };

    boot.initrd.systemd.enable = true;
    boot.initrd.network.enable = true;
    # NetworkManager forces networking.useDHCP off, so the initrd needs its own.
    boot.initrd.systemd.network.networks."99-ethernet-default-dhcp" = {
      matchConfig = {
        Type = "ether";
        Kind = "!*";
      };
      networkConfig.DHCP = "yes";
    };

    # Defaults to false under systemd initrd, but stage 2 is NetworkManager.
    boot.initrd.network.flushBeforeStage2 = true;

    # Fall back to the passphrase prompt quickly when the network is down.
    boot.initrd.systemd.network.wait-online.timeout = 20;
  };
}
