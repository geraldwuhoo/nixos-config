{ lib, config, ... }:
{
  options = {
    bluetooth.enable = lib.mkEnableOption "enables bluetooth";
  };

  config = lib.mkIf config.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
