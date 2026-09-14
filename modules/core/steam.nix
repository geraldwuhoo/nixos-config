{ config, ... }:
{
  programs.steam.enable = true;

  # Upstream remotePlay.openFirewall ports, scoped to the LAN
  networking.firewall.interfaces.${config.lanInterface} = {
    allowedTCPPorts = [
      27036
      27037
    ];
    allowedUDPPorts = [
      27036
      10400
      10401
    ];
    allowedUDPPortRanges = [
      {
        from = 27031;
        to = 27035;
      }
    ];
  };
}
