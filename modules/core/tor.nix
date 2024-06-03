{ lib, config, ... }:
{
  options = {
    tor.enable = lib.mkEnableOption "enables tor client";
  };

  config = lib.mkIf config.tor.enable {
    services.tor = {
      enable = true;
      relay.enable = false;
      client.enable = true;
    };
  };
}
