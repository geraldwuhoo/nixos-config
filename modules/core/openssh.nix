{ lib, config, ... }:
{
  options = {
    openssh.enable = lib.mkEnableOption "enables OpenSSH";
  };
  config = lib.mkIf config.openssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        passwordAuthentication = true;
      };
    };
  };
}
