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
      # Krohnkite's size is not an xdg tiled state, so the default rescales
      # the picture to the window width. A wide tile then draws past the frame.
      keepaspect-window = "no";
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
    # match yt-dlp's default "Title [id].ext" filenames
    scriptOpts.sponsorblock.local_pattern = "%[([%w-_]+)%]%.%w+$";
  };
}
