{
  pkgs,
  lib,
  config,
  ...
}:
let
  paths = map (x: config.home.homeDirectory + "/" + x) [
    "Documents"
    "Downloads"
    "Pictures"
    "Videos"
  ];
in
{
  systemd.user.services.rsync = {
    Unit = {
      Description = "rsync files to NAS";
      After = [ "network.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.rsync}/bin/rsync --progress --partial --archive --compress --delete-after ${lib.strings.concatStringsSep " " paths} /mnt/cephfs/important/971c4832-45a7-493a-9b87-51cd07551c61/jerry";
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.timers.rsync = {
    Unit.Description = "rsync files to NAS schedule";
    Timer = {
      OnCalendar = "hourly";
      RandomizedDelaySec = 600;
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
