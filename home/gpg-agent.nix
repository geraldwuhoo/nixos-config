{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 60480000;
    maxCacheTtl = 60480000;
    # Module defaults to grab, gpg-agent doesn't
    grabKeyboardAndMouse = false;
    pinentry.package = pkgs.pinentry-qt;
  };
}
