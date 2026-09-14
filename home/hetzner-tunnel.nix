{
  osConfig,
  pkgs,
  ...
}:
{
  systemd.user.services.hetzner-ssh = {
    Unit = {
      Description = "SSH SOCKS tunnel to hetzner";
      StopWhenUnneeded = true;
    };
    Service = {
      ExecStart = "${pkgs.openssh}/bin/ssh -N -D 127.0.0.1:1081 -o BatchMode=yes -o ControlMaster=no -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o ServerAliveCountMax=3 hetzner";
      # proxyd connects immediately, so hold off until ssh is actually listening
      ExecStartPost = "${pkgs.bash}/bin/bash -c 'until (exec 3<>/dev/tcp/127.0.0.1/1081) 2>/dev/null; do sleep 0.2; done'";
      TimeoutStartSec = 30;
    };
  };

  systemd.user.services.hetzner-tunnel = {
    Unit = {
      Description = "Forward SOCKS connections to the hetzner SSH tunnel";
      BindsTo = [ "hetzner-ssh.service" ];
      After = [ "hetzner-ssh.service" ];
    };
    Service.ExecStart = "${osConfig.systemd.package}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:1081";
  };

  systemd.user.sockets.hetzner-tunnel = {
    Unit.Description = "On-demand SOCKS proxy to hetzner over SSH";
    Socket.ListenStream = "127.0.0.1:1080";
    Install.WantedBy = [ "sockets.target" ];
  };
}
