{ pkgs, ... }:
{
  services.flameshot = {
    enable = true;
    package = pkgs.unstable.flameshot;
    settings.General = {
      contrastOpacity = 188;
      disabledTrayIcon = false;
      drawColor = "#ff0000";
      drawThickness = 4;
      ignoreUpdateToVersion = "12.0.0";
      savePath = "/scratch";
      savePathFixed = false;
      showStartupLaunchMessage = false;
      startupLaunch = false;
      useJpgForClipboard = true;
      # the portal round-trips the whole 7440x3440 desktop through a PNG
      useX11LegacyScreenshot = true;
    };
  };
}
