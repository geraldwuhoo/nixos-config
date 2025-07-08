{ pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./direnv.nix
    ./easyeffects.nix
    ./eza.nix
    ./joplin.nix
    ./lf.nix
    ./mpv.nix
    ./plasma.nix
    ./rofi.nix
    ./rsync.nix
    ./thunderbird.nix
    ./tmux.nix
    ./unclutter.nix
    ./vim.nix
    ./vscode.nix
    ./zathura.nix
    ./zsh.nix
  ];

  easyeffects.enable = lib.mkDefault true;
  eza.enable = lib.mkDefault true;
  thunderbird.enable = lib.mkDefault true;

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

    packages =
      with pkgs;
      [
        hyperfine
        jellyfin-mpv-shim
        kopia
        ntfy-sh
        hydrus
      ]
      ++ (with unstable; []);

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

  gtk = {
    enable = true;
    theme = lib.mkForce {
      name = "Nordic";
      package = pkgs.nordic;
    };
    font = {
      name = "DejaVu Sans";
      size = 9;
    };
    cursorTheme = {
      name = "Nordic-cursors";
      size = 24;
      package = pkgs.nordic;
    };
  };

  xdg.configFile."k9s/skins/nord.yaml".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/derailed/k9s/master/skins/nord.yaml";
    sha256 = "1qbmfxjjaa0xzj2p5x0yb60pdn3yzrx8dsrpmrfzz2h8kmj8ipll";
  };
  stylix.targets.k9s.enable = false;
  programs.k9s = {
    enable = true;
    package = pkgs.unstable.k9s;
    settings.k9s.ui.skin = "nord";
  };

  programs.obs-studio.enable = true;
}
