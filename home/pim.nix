# The Nextcloud app password lives in KWallet, not in this repo. After a
# reinstall or on a new machine, set it up again after switching:
#
#   1. Create an app password at https://cloud.wuhoo.xyz under
#      Settings > Security > Devices & sessions.
#   2. Store it (prompts without echoing):
#        secret-tool store --label=pimsync service pimsync user jerry
#   3. Check it can be read back:
#        secret-tool lookup service pimsync user jerry >/dev/null && echo ok
#   4. Do the first sync by hand, confirming the plan:
#        pimsync sync -i
#   5. Start the service (it also retries on its own every 60s):
#        systemctl --user restart pimsync
#
# To rotate it, rerun step 2. To remove it:
#   secret-tool clear service pimsync user jerry
{
  config,
  lib,
  pkgs,
  ...
}:
let
  remote = type: {
    inherit type;
    url = "https://cloud.wuhoo.xyz/remote.php/dav";
    userName = "jerry";
    passwordCommand = [
      "${pkgs.libsecret}/bin/secret-tool"
      "lookup"
      "service"
      "pimsync"
      "user"
      "jerry"
    ];
  };

  pimsync = {
    enable = true;
    extraPairDirectives = [
      {
        name = "collections";
        params = [ "all" ];
      }
    ];
  };
in
{
  home.packages = [ pkgs.libsecret ];

  accounts.calendar = {
    basePath = "${config.xdg.dataHome}/calendars";
    accounts.nextcloud = {
      remote = remote "caldav";
      # pimsync wants the extension without the leading dot
      local.fileExt = "ics";
      inherit pimsync;
      khal = {
        enable = true;
        type = "discover";
      };
    };
  };

  accounts.contact = {
    basePath = "${config.xdg.dataHome}/contacts";
    accounts.nextcloud = {
      remote = remote "carddav";
      local.fileExt = "vcf";
      inherit pimsync;
      khard = {
        enable = true;
        type = "discover";
      };
    };
  };

  programs.pimsync.enable = true;
  services.pimsync.enable = true;
  systemd.user.services.pimsync = {
    Unit = {
      # KWallet is only unlocked once the session starts
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Restart = "on-failure";
      RestartSec = 60;
    };
    Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
  };

  programs.khal.enable = true;
  programs.khard.enable = true;
  programs.todoman = {
    enable = true;
    glob = "nextcloud/*";
    # Soonest due first, then highest priority; "-" means ascending
    extraConfig = ''
      default_command = "list --sort -due,-priority"
    '';
  };
}
