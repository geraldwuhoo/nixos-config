{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [ pkgs.ntfy-sh ];

  sops.secrets.ntfy-user = { };
  sops.secrets.ntfy-password = { };
  sops.templates."ntfy-client.yml".content = ''
    default-host: https://ntfy.wuhoo.xyz

    subscribe:
  ''
  + lib.concatMapStrings (topic: ''
    - topic: ${topic}
      command: '${lib.getExe pkgs.libnotify} "$m"'
      user: ${config.sops.placeholder.ntfy-user}
      password: ${config.sops.placeholder.ntfy-password}
  '') [
    "Downtime"
    "kured"
    "Media"
  ];

  systemd.user.services.ntfy-client = {
    Unit = {
      Description = "ntfy client";
      # notify-send needs the session's DISPLAY and D-Bus environment
      After = [
        "graphical-session.target"
        "sops-nix.service"
      ];
      Requires = [ "sops-nix.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.ntfy-sh} subscribe --config ${
        config.sops.templates."ntfy-client.yml".path
      } --from-config";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
