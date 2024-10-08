{ pkgs, config, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [
      # Nix
      home-manager
      nil
      nixfmt-rfc-style

      # Standard utils but better
      bat
      (btop.override { cudaSupport = config.nvidia.enable; })
      du-dust
      eza
      fd
      file
      htop-vim
      lsof
      ncdu
      openssl
      ripgrep
      tree

      # Networking tools
      awscli2
      curlie
      dig
      httpie
      inetutils
      s3cmd
      wget

      # Development tools
      docker-compose
      gitlab-ci-local
      pre-commit
      qmk
      qmk-udev-rules

      # IaC tools
      ansible
      gron
      jq
      opentofu
      yj
      yq

      # X11 utilities
      xclip
      xdo
      xdotool

      # Browsers
      brave
      firefox
      tor-browser
      ungoogled-chromium

      # GUI applications
      bottles
      element-desktop
      gimp
      libreoffice
      libsForQt5.bismuth
      redshift
      signal-desktop
      sxhkd
      webcord

      # Media tools
      exiftool
      ffmpeg-full
      flameshot
      imagemagick
      jpegoptim
      libwebp
      mediainfo
      mpv
      oxipng
      perl536Packages.FileMimeInfo
      pngquant
      sxiv

      # Archive/compression/encryption tools
      age
      atool
      gnupg
      gocryptfs
      ouch
      p7zip
      pbzip2
      pigz
      sops
      unzip
      unrar-wrapper

      # CLI tools
      appimage-run
      cht-sh
      clevis
      devour
      efibootmgr
      ffsend
      fzf
      gallery-dl
      glow
      lf
      libnotify
      neofetch
      pwgen
      rhash
      tealdeer
      tmux
      tmuxinator
      udiskie
      vim

      # Very important
      kdePackages.kolf
    ]
    ++ (with unstable; [
      # Apps that should track close to upstream due to server-side dependencies
      feishin
      finamp
      planify
      yt-dlp

      # Kubernetes tooling
      fluxcd
      kubectl
      kubectl-klock
      kubectl-ktop
      kubectl-neat
      kubectl-tree
      kubernetes-helm
      kubie
      kustomize
      velero
    ]);

  # Programs
  programs.dconf.enable = true;

  # Disable system zsh stuff to avoid cache invalidation with zinit in home-manager
  # Fixes slow zsh interactive shell start up time
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestions.enable = false;
    syntaxHighlighting.enable = false;
  };

  programs.java.enable = true;
  programs.gnupg.agent.enable = true;
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  hardware.keyboard.qmk.enable = true;

  # Get nerdfonts patched DejaVuSans package
  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; }) ];
}
