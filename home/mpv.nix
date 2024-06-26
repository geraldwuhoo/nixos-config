{ ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      input-ipc-server = "/tmp/mpvsocket";
      hwdec = "auto-copy";
      hwdec-codecs = "all";
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
