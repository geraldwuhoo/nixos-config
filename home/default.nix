{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./direnv.nix
    ./eza.nix
    ./lf.nix
    ./plasma.nix
    ./rofi.nix
    ./thunderbird.nix
    ./tmux.nix
    ./unclutter.nix
    ./vim.nix
    ./vscode.nix
    ./zathura.nix
    ./zsh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "jerry";
    homeDirectory = "/home/jerry";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.

    packages = with pkgs; [
      hyperfine
      jellyfin-mpv-shim
      ntfy-sh
    ];

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. If you don't want to manage your shell through Home
    # Manager then you have to manually source 'hm-session-vars.sh' located at
    # either
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/jerry/etc/profile.d/hm-session-vars.sh
    #
    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
    };
  };

  services.easyeffects = {
    enable = true;
    preset = "HD800S (Oratory1990)";
  };

  programs.k9s.enable = true;
  programs.btop.enable = true;

  programs.obs-studio.enable = true;
}
