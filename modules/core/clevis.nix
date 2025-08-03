{
  pkgs,
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

    # Manually set up Clevis auto-unlock with TPM+Tang because the clevis module broke
    boot.initrd.secrets = {
      "/etc/clevis/zroot.jwe" = config.clevis.jweFile;
    };
    boot.initrd.network =
      let
        root = config.clevis.zfsEncryptionroot;
      in
      {
        enable = true;
        udhcpc.enable = true;
        postCommands = ''
          export PATH="${pkgs.curl}/bin:${pkgs.clevis}/bin:$PATH"
          zpool import ${root}
          echo "running clevis to unlock ${root}"
          clevis decrypt < /etc/clevis/zroot.jwe | zfs load-key ${root}
        '';
      };
  };
}
