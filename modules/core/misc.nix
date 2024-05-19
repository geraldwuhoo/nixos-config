{ pkgs, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    age
    ansible
    atool
    awscli2
    bat
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
    hydrus
    imagemagick
    jpegoptim
    jq
    kubectl
    kubectl-klock
    kubectl-neat
    kubectl-tree
    kubectx
    kubernetes-helm
    lf
    libreoffice
    libsForQt5.bismuth
    libwebp
    lsof
    mediainfo
    mpv
    mullvad-browser
    mullvad-vpn
    ncdu
    neofetch
    nerdfonts
    nil
    nixfmt
    nixpkgs-fmt
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
    rustup
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
    tor
    tor-browser
    tree
    ueberzug
    ungoogled-chromium
    unstable.feishin
    unstable.gitlab-ci-local
    unstable.k9s
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
    zoxide
    zsh
  ];

  # Programs
  programs.dconf.enable = true;
  programs.zsh.enable = true;
  programs.java.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  programs.kdeconnect.enable = true;
  programs.gnupg.agent.enable = true;
  programs.git = {
    enable = true;
    lfs.enable = true;
  };
}
