{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    age
    ansible
    atool
    awscli2
    bat
    bottles
    bottom
    brave
    chafa
    cht-sh
    cinny-desktop
    clevis
    ctpv
    curlie
    dig
    docker-compose
    du-dust
    efibootmgr
    element-desktop
    exiftool
    eza
    fd
    ffmpeg-full
    ffsend
    file
    firefox
    flameshot
    fluxcd
    fzf
    gallery-dl
    gimp
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
    kubectl
    kubectl-klock
    kubectl-neat
    kubectl-tree
    kubernetes-helm
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
    perl536Packages.FileMimeInfo
    pngquant
    powerline
    powerline-fonts
    pre-commit
    pwgen
    redshift
    rhash
    ripgrep
    s3cmd
    signal-desktop
    sonixd
    sops
    sunshine
    sxhkd
    sxiv
    tealdeer
    tmux
    tmuxinator
    tor-browser
    tree
    ueberzug
    ungoogled-chromium
    unstable.feishin
    unstable.gitlab-ci-local
    unstable.planify
    unzip
    velero
    vim
    webcord-vencord
    wget
    xclip
    xdo
    xdotool
    yj
    yq
    yt-dlp
  ];

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
