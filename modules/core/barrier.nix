{ pkgs, ... }:
{
  # Install barrier
  environment.systemPackages = with pkgs; [ barrier ];

  # Open port for barrier
  networking.firewall = {
    allowedTCPPorts = [ 24800 ];
  };
}
