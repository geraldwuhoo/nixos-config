{ pkgs, lib, ... }:
let
  lanSubnets = [
    "10.10.0.0/24"
    "10.20.0.0/24"
    "10.30.0.0/24"
    "10.40.0.0/24"
    "10.50.0.0/24"
    "10.60.0.0/24"
    "10.70.0.0/24"
    "172.16.16.0/24"
  ];
in
{
  # Get Mullvad browser as well
  environment.systemPackages = with pkgs; [ mullvad-browser ];

  # Enable Mullvad VPN daemon
  services.mullvad-vpn = {
    enable = true;
    # Use full Mullvad GUI in addition to CLI
    package = pkgs.mullvad-vpn;
  };

  # Allow local network to bypass Mullvad
  networking.nftables = {
    enable = true;
    tables = {
      excludeTraffic = {
        family = "inet";
        content = ''
          chain excludeOutgoing {
            type route hook output priority 0; policy accept;
            ${lib.concatMapStringsSep "\n  " (
              subnet: "ip daddr ${subnet} ct mark set 0x00000f41 meta mark set 0x6d6f6c65;"
            ) lanSubnets}
          }
        '';
      };
    };
  };

  # The nft reroute happens after the source address is picked from mullvad's table,
  # leaving LAN connections bound to the tunnel IP; route them via main up front instead
  systemd.services.lan-bypass-mullvad = {
    description = "Route LAN subnets outside Mullvad";
    wantedBy = [ "multi-user.target" ];
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = map (subnet: "${pkgs.iproute2}/bin/ip rule add to ${subnet} lookup main priority 32000") lanSubnets;
      ExecStop = map (subnet: "-${pkgs.iproute2}/bin/ip rule del to ${subnet} lookup main priority 32000") lanSubnets;
    };
  };
}
