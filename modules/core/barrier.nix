{ pkgs, ... }:
{
  # Install input-leap (barrier replacement)
  environment.systemPackages = with pkgs; [ input-leap ];

  # Open port for barrier
  networking.firewall = {
    allowedTCPPorts = [ 24800 ];
  };
}
