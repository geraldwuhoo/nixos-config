{ ... }:
{
  programs.zsh.zsh-abbr = {
    enable = true;

    # Expanded in command position only
    abbreviations = {
      # General
      ll = "ls -lah";
      ":q" = "exit";
      sz = "source ~/.zshrc";
      wreboot = "efibootmgr --bootnext 0005";
      mpv = "devour mpv";
      pifs = "πfs";
      rp = "systemctl --user restart plasma-plasmashell.service";
      ethmine = "tmuxinator start mine";
      fzfb = "fzf --preview 'bat --style=numbers --color=always --line-range=:500 {}'";
      pwc = "pwgen --secure --num-passwords 1 __CURSOR__ | tr -d '[:space:]' | xclip -sel clip";
      pws = "pwgen --secure --symbols --num-passwords 1 __CURSOR__ | tr -d '[:space:]' | xclip -sel clip";
      ydl = "yt-dlp";
      ydl720 = "yt-dlp --format \"bestvideo[height<=?720][vcodec~='vp0?9']+bestaudio[acodec=opus]\"";
      ydl1080 = "yt-dlp --format \"bestvideo[height<=?1080][vcodec~='vp0?9']+bestaudio[acodec=opus]\"";
      gdl = "gallery-dl";
      tma = "tmux a";

      # zfs stuff
      zback = "zfs send -Rwv \"\$(zfs list -t snapshot zroot/data/home | awk 'END{print \$1}')\" > zroot_data_home_\$(date -u +%Y-%m-%dT%H:%M:%S%Z)";

      # topgrade
      tg = "topgrade";
      tgt = "topgrade --tmux";

      # nix
      ngc = "sudo nix-collect-garbage -d --verbose && nix-collect-garbage -d --verbose";
      nsd = "nixos-rebuild switch --flake \"\${HOME}/nixos#NixDesktop\"";
      ntd = "nixos-rebuild test --flake \"\${HOME}/nixos#NixDesktop\"";
      nbd = "nixos-rebuild boot --flake \"\${HOME}/nixos#NixDesktop\"";
      nsx = "nixos-rebuild switch --flake \"\${HOME}/nixos#NixX230\"";
      ntx = "nixos-rebuild test --flake \"\${HOME}/nixos#NixX230\"";
      nbx = "nixos-rebuild boot --flake \"\${HOME}/nixos#NixX230\"";
      nxs = "nix-shell --command zsh -p";
      nrp = "nix run github:pjones/plasma-manager/plasma-5";

      # rsync
      rs1 = "rsync --progress --partial --archive";
      rz1 = "rsync --progress --partial --archive --compress";
      rs2 = "rsync --info=progress2 --partial --archive";
      rz2 = "rsync --info=progress2 --partial --archive --compress";
      rsf1 = "rsync --progress --partial --archive --hard-links --acls --xattrs";
      rzf1 = "rsync --progress --partial --archive --hard-links --acls --xattrs --compress";
      rsf2 = "rsync --info=progress2 --partial --archive --hard-links --acls --xattrs";
      rzf2 = "rsync --info=progress2 --partial --archive --hard-links --acls --xattrs --compress";

      # systemd
      scl = "systemctl status";
      scs = "systemctl start";
      sce = "systemctl enable";
      scse = "systemctl enable --now";
      sct = "systemctl stop";
      scd = "systemctl disable";
      sctd = "systemctl disable --now";

      # KDE
      klogout = "qdbus org.kde.Shutdown /Shutdown logout";
      kreboot = "qdbus org.kde.Shutdown /Shutdown logoutAndReboot";
      kpoweroff = "qdbus org.kde.Shutdown /Shutdown logoutAndShutdown";

      # Ansible
      ap = "ansible-playbook";

      # Docker
      dk = "docker";
      dkrit = "docker run -it";
      dki = "docker images";
      dkig = "docker images | grep __CURSOR__ | awk '{print \$3}'";
      dm = "docker-machine";
      dmssh = "docker-machine ssh";
      dc = "docker compose";
      dkbd = "docker build .";
      dkbt = "docker build -t __CURSOR__ .";
      drid = "docker rmi -f \$(docker images -q -f \"dangling=true\")";
      dcu = "docker compose up";
      dcd = "docker compose down";
      dcbd = "docker compose build";

      # Podman
      pd = "podman";
      pdrit = "podman run -it";
      pdi = "podman images";
      pdig = "podman images | grep __CURSOR__ | awk '{print \$3}'";
      pc = "podman-compose";
      pcu = "podman-compose up";
      pcdu = "podman-compose down && podman-compose up";
      pcb = "podman-compose build";
      pdbd = "podman build .";
      pdbt = "podman build -t __CURSOR__ .";
      prid = "podman rmi -f \$(podman images -q -f \"dangling=true\")";
      pdsp = "podman system prune";

      # kubectl
      kc = "kubectl";
      kg = "kubectl get";
      kga = "kubectl get --all-namespaces";
      kgn = "kubectl get nodes";
      kgp = "kubectl get pods";
      kgpa = "kubectl get pods --all-namespaces";
      kgd = "kubectl get deployments";
      kgda = "kubectl get deployments --all-namespaces";
      kgs = "kubectl get services";
      kgsa = "kubectl get services --all-namespaces";
      kgi = "kubectl get ingress";
      kgia = "kubectl get ingress --all-namespaces";
      kgv = "kubectl get pv";
      kgva = "kubectl get pv --all-namespaces";
      kgc = "kubectl get pvc";
      kgca = "kubectl get pvc --all-namespaces";
      ka = "kubectl apply";
      kaf = "kubectl apply -f";
      kak = "kubectl apply -k";
      kd = "kubectl delete";
      kdf = "kubectl delete -f";
      kdk = "kubectl delete -k";
      kdp = "kubectl delete pods";
      kdd = "kubectl delete deployments";
      kds = "kubectl delete services";
      kdi = "kubectl delete ingress";
      kdv = "kubectl delete pv";
      kdc = "kubectl delete pvc";
      kpv = "kubectl get pv | awk '/Released/ {print \$1;}' | xargs -I{} kubectl delete pv {}";
      kcdbg = "kubectl run --stdin --tty --rm debug --image=alpine --restart=Never -- sh";
      kzb = "kustomize build";
      kzbka = "kustomize build __CURSOR__ | kubectl apply -f -";
      k3dc = "k3d cluster create --config ~/.kube/k3d.yaml && k3d kubeconfig get k3s-default > ~/.kube/k3d.config";
      k3dd = "k3d cluster delete && rm ~/.kube/k3d.config";

      # dav
      khc = "khal calendar now 7d";
      khi = "khal interactive";
      td = "todo | tac";
    };

    # Expanded anywhere on the line
    globalAbbreviations = {
      awp = "~/Anime/Wallpaper/__CURSOR__";
      tt = "/scratch/__CURSOR__";
      sc = "/scratch/__CURSOR__";
    };
  };
}
