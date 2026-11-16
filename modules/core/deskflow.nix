{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [ deskflow ];

  networking.firewall.interfaces.${config.lanInterface} = {
    allowedTCPPorts = [ 24800 ];
  };
}
