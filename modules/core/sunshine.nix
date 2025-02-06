{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    sunshine.enable = lib.mkEnableOption "enables sunshine";
  };

  config = lib.mkIf config.sunshine.enable {
    services.sunshine = {
      enable = true;
      #package = pkgs.sunshine.override { cudaSupport = config.nvidia.enable; };
      openFirewall = true;
      capSysAdmin = true;

      settings = {
        amd_rc = "auto";
        min_log_level = "2";
        resolutions = ''
          [
              352x240,
              480x360,
              858x480,
              1280x720,
              1920x1080,
              2560x1080,
              3440x1440,
              1920x1200,
              3860x2160,
              3840x1600,
              3840x2160
          ]
        '';
        gamepad = "x360";
        hevc_mode = "0";
        encoder = "nvenc";
        amd_quality = "default";
        av1_mode = "1";
      };

      applications = {
        env = {
          PATH = "$(PATH)=$(HOME)/.local/bin";
        };
        apps = [
          {
            name = "Low Res Desktop";
            prep-cmd = [
              {
                do = "${pkgs.xorg.xrandr} --output HDMI-1 --mode 1920x1080";
                undo = "${pkgs.xorg.xrandr} --output HDMI-1 --mode 1920x1200";
              }
            ];
          }
          {
            name = "Steam BigPicture";

            output = "steam.txt";
            detached = [ "${pkgs.util-linux}/bin/setsid steam steam=//open/bigpicture" ];
            image-path = "./assets/steam.png";
          }
        ];
      };
    };
  };
}
