{ lib, config, ... }:
{
  options = {
    psd = with lib; {
      enable = mkEnableOption "enables profile-sync-daemon";
      resyncTimer = mkOption {
        type = types.str;
        description = "The amount of time to wait before syncing browser profiles back to the disk";
        default = "15min";
      };
    };
  };

  config = lib.mkIf config.psd.enable {
    services.psd = {
      enable = true;
      resyncTimer = config.psd.resyncTimer;
    };
  };
}
