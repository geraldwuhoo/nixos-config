{ pkgs, ... }:
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
            ip daddr 10.10.0.0/24 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            ip daddr 10.20.0.0/24 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            ip daddr 10.30.0.0/24 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            ip daddr 10.40.0.0/24 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            ip daddr 10.50.0.0/24 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            ip daddr 10.60.0.0/24 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            ip daddr 10.70.0.0/24 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
            ip daddr 172.16.16.0/24 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
          }
        '';
      };
    };
  };
}
