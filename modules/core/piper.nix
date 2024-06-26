{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    piper.enable = lib.mkEnableOption "enables piper";
  };

  config = lib.mkIf config.piper.enable {
    services.ratbagd.enable = true;

    environment.systemPackages = with pkgs; [ piper ];
  };
}
