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
      settings.Addresses.Gateway = "/ip4/127.0.0.1/tcp/8081";
    };
  };
}
