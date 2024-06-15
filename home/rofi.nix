{ pkgs, ... }:
{
  home.packages = with pkgs; [ rofi-rbw ];

  programs.rbw = {
    enable = true;
    settings = {
      email = "gerald@geraldwu.com";
      base_url = "https://vaultwarden.wuhoo.xyz";
      lock_timeout = 86400;
      pinentry = pkgs.pinentry-qt;
    };
  };

  programs.rofi = {
    enable = true;
    plugins = with pkgs; [ rofi-calc ];
  };
}
