{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ceph-client.enable = lib.mkEnableOption "enables ceph-client";
  };

  config = lib.mkIf config.ceph-client.enable {
    # Explicitly get ceph-client package
    environment.systemPackages = with pkgs; [ ceph-client ];

    # Filesystem mount points
    fileSystems."/mnt/cephfs" = {
      device = "nix-desktop@.cephfs=/volumes/nas";
      fsType = "ceph";
      noCheck = true;
      options = [
        "noatime"
        "_netdev"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=60"
        "x-systemd.mount-timeout=60"
        "x-systemd.device-timeout=60"
      ];
    };

    # Ceph client config
    services.ceph = {
      enable = true;
      global = {
        fsid = "9e4c7478-c21a-45af-9b37-f82ba4cea186";
        monHost = "10.40.0.30, 10.40.0.31, 10.40.0.32";
      };
      client = {
        enable = true;
        extraConfig = {
          "client" = {
            "client_mount_uid" = "1000";
            "client_mount_gid" = "1000";
            "keyring" = "${config.sops.templates.ceph-keyring.path}";
          };
        };
      };
    };

    # Client keyring via sops secret
    sops.secrets.ceph-key = { };
    sops.templates."ceph-keyring" = {
      content = ''
        [client.nix-desktop]
        key = ${config.sops.placeholder.ceph-key}
      '';
    };
  };
}
