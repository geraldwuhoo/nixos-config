{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [
      age
      ansible
      appimage-run
      atool
      awscli2
      bat
      bottles
      bottom
      brave
      cht-sh
      cinny-desktop
      clevis
      curlie
      devour
      dig
      docker-compose
      du-dust
      efibootmgr
      element-desktop
      exiftool
      eza
      fd
      feishin
      ffmpeg-full
      ffsend
      file
      firefox
      flameshot
      fzf
      gallery-dl
      gimp
      gitlab-ci-local
      glow
      gnupg
      gocryptfs
      gron
      home-manager
      htop-vim
      httpie
      imagemagick
      jpegoptim
      jq
      kdePackages.kolf # very important
      kustomize
      lf
      libnotify
      libreoffice
      libsForQt5.bismuth
      libwebp
      lsof
      mediainfo
      mpv
      ncdu
      neofetch
      nil
      nixfmt-rfc-style
      openssl
      opentofu
      ouch
      oxipng
      p7zip
      pbzip2
      perl536Packages.FileMimeInfo
      pigz
      pngquant
      pre-commit
      pwgen
      redshift
      rhash
      ripgrep
      s3cmd
      signal-desktop
      sops
      sxhkd
      sxiv
      tealdeer
      tmux
      tmuxinator
      tor-browser
      tree
      udiskie
      ungoogled-chromium
      unzip
      vim
      webcord
      wget
      xclip
      xdo
      xdotool
      yj
      yq
      yt-dlp
    ]
    ++ (with unstable; [
      finamp
      planify

      # Kubernetes tooling
      fluxcd
      kubectl
      kubectl-klock
      kubectl-ktop
      kubectl-neat
      kubectl-tree
      kubernetes-helm
      velero
    ]);

  # Programs
  programs.dconf.enable = true;

  # Disable system zsh stuff to avoid cache invalidation with zinit in home-manager
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

  # Get nerdfonts patched DejaVuSans package
  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; }) ];
}
