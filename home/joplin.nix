{ ... }:
{
  programs.joplin-desktop = {
    enable = true;
    sync = {
      interval = "5m";
      target = "nextcloud";
    };
    extraConfig = {
      "sync.5.path" = "https://cloud.wuhoo.xyz/remote.php/webdav/Joplin";
      "sync.5.username" = "jerry";
      "locale" = "en_US";
      "theme" = 6; # Nord theme
      "themeAutoDetect" = false;
      "editor.codeView" = true;
      "editor.keyboardMode" = "vim";
    };
  };
}
