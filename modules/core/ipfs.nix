{ config, lib, ... }:
{
  options = {
    ipfs.enable = lib.mkEnableOption "enables ipfs";
  };

  config = lib.mkIf config.ipfs.enable {
    services.kubo = {
      enable = true;
      defaultMode = "online";
      autoMigrate = true;
      startWhenNeeded = true;
    };
  };
}
