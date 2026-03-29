{ osConfig, pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [ sponsorblock ];
    config = {
      input-ipc-server = "/tmp/mpvsocket";
      hwdec = if osConfig.nvidia.enable then "nvdec" else "auto";
      hwdec-codecs = "all";
      vo = "gpu-next";
      hr-seek-framedrop = "no";
      no-resume-playback = "";
      ytdl-format = "bestvideo[height<=?1440][fps<=?60]+bestaudio/best";
      cache = "yes";
      demuxer-max-bytes = "1024MiB";
      demuxer-readahead-secs = "30";
    };
    bindings = {
      "Alt+-" = "add video-zoom -0.43";
      "Alt+=" = "add video-zoom 0.43";
    };
  };
}
