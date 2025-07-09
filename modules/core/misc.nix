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

      # Standard utils, but some better
      (btop.override { cudaSupport = config.nvidia.enable; })
      bat
      cryptsetup
      du-dust
      eza
      fd
      file
      htop-vim
      iotop
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
      bruno
      docker-compose
      gitlab-ci-local
      hugo
      pre-commit
      qmk
      qmk-udev-rules

      # IaC tools
      ansible
      gron
      hcloud
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
      (ungoogled-chromium.override {
        commandLineArgs = [
          "--enable-features=VaapiVideoDecodeLinuxGL"
          "--ignore-gpu-blocklist"
          "--enable-zero-copy"
          "--change-stack-guard-on-fork=enable"
        ];
      })

      # GUI applications
      audacity
      bottles
      element-desktop
      feishin
      filezilla
      gimp
      libreoffice
      signal-desktop
      sxhkd
      webcord

      # Media tools
      czkawka
      exiftool
      ffmpeg-full
      flameshot
      imagemagick
      jpegoptim
      libwebp
      mediainfo
      mpv
      oxipng
      perl538Packages.FileMimeInfo
      pngquant
      realesrgan-ncnn-vulkan
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
      unrar-wrapper
      unzip

      # CLI tools
      appimage-run
      cht-sh
      devour
      efibootmgr
      fastfetch
      ffsend
      fzf
      gallery-dl
      glow
      lf
      libnotify
      mbuffer
      opensc
      pwgen
      rclone
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
      clevis
      finamp
      planify
      yt-dlp

      # Kubernetes tooling
      cilium-cli
      fluxcd
      k3d
      kind
      kubectl
      kubectl-klock
      kubectl-ktop
      kubectl-neat
      kubectl-tree
      kubernetes-helm
      kubie
      kustomize
      linkerd
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
  programs.ssh.startAgent = true;
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.chromium.enable = true;
  programs.firefox.enable = true;

  hardware.keyboard.qmk.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Get nerdfonts patched DejaVuSans package
  fonts.packages = with pkgs; [ pkgs.nerd-fonts.dejavu-sans-mono ];
}
