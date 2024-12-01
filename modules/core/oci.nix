{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    oci.enable = lib.mkEnableOption "enables OCI containers";
  };

  config = lib.mkIf config.oci.enable {
    # OCI stuff
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerSocket.enable = true;
    };
    systemd.services."user@".serviceConfig.Delegate = "cpuset cpu io memory pids";

    hardware.nvidia-container-toolkit.enable = config.nvidia.enable;

    #systemd.sockets.netavark-dhcp-proxy = {
    #  description = "Netavark DHCP proxy socket";
    #  socketConfig = {

    #    SocketGroup = "podman";
    #    ListenStream = "%t/podman/nv-proxy.sock";
    #    SocketMode = "0660";
    #  };

    #  wantedBy = [ "sockets.target" ];
    #};

    #systemd.services.netavark-dhcp-proxy = {
    #  description = "Netavark DHCP proxy service";

    #  serviceConfig = {
    #    Type = "exec";
    #    ExecStart = "${pkgs.netavark}/bin/netavark dhcp-proxy -a 30";
    #  };

    #  after = [ "netavark-dhcp-proxy.socket" ];
    #  requires = [ "netavark-dhcp-proxy.socket" ];
    #  startLimitIntervalSec = 0;

    #  wantedBy = [ "default.target" ];
    #};
  };
}
