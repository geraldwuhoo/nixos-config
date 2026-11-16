{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  host = osConfig.networking.hostName;
  mac = "gwu2-mbp2";
  layoutFile = "${config.xdg.configHome}/Deskflow/deskflow-server.conf";
  settings = {
    core = {
      coreMode = "2"; # server
      computerName = host;
      port = "24800";
    };
    server = {
      externalConfig = "true";
      externalConfigFile = layoutFile;
      enableClipboard = "false";
    };
    security.tlsEnabled = "true";
    gui = {
      autoHide = "true";
      startCoreWithGui = "true";
    };
    # layout file only holds links; computers are declared here
    "computer_${host}".name = host;
    "computer_${mac}".name = mac;
  };
in
{
  xdg.configFile."Deskflow/deskflow-server.conf".text = ''
    section: links
      ${host}:
        left = ${mac}
      ${mac}:
        right = ${host}
    end
  '';

  # not a symlink: the GUI writes state into Deskflow.conf
  home.activation.deskflowSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStrings (
      lib.mapAttrsToList (
        group: keys:
        lib.concatStrings (
          lib.mapAttrsToList (key: value: ''
            run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "${config.xdg.configHome}/Deskflow/Deskflow.conf" \
              --group ${group} --key ${key} ${lib.escapeShellArg value}
          '') keys
        )
      ) settings
    )
  );
}
