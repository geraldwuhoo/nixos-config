{ lib, config, ... }:
{
  options = {
    tor.enable = lib.mkEnableOption "enables tor client";
  };

  config = lib.mkIf config.tor.enable {
    services.tor = {
      enable = true;
      relay.enable = false;
      client = {
        enable = true;
        socksListenAddress = {
          addr = "127.0.0.1";
          port = 9050;
          IsolateDestAddr = true;
        };
      };
    };
  };
}
