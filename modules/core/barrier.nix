{ pkgs, config, ... }:
{
  # Install input-leap (barrier replacement)
  environment.systemPackages = with pkgs; [ input-leap ];

  # Open port for barrier
  networking.firewall.interfaces.${config.lanInterface} = {
    allowedTCPPorts = [ 24800 ];
  };
}
