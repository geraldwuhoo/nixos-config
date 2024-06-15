setopt extendedglob

typeset -A abbrevs

# General aliases
abbrevs=(
  "ll"          "ls -lah"
  ":q"          "exit"
  "sz"          "source ~/.zshrc"
  "wreboot"     "sudo efibootmgr --bootnext DC5B"
  "mpv"         "devour mpv"
  "pifs"        "πfs"
  "rp"          "kquitapp5 plasmashell && kstart5 plasmashell"
  "ethmine"     "tmuxinator start mine"
  "fzfb"        "fzf --preview 'bat --style=numbers --color=always --line-range=:500 {}'"
  "pwc"         "pwgen --secure --num-passwords 1 __CURSOR__ | tr -d '\n' | xclip -sel clip"
  "pws"         "pwgen --secure --symbols --num-passwords 1 __CURSOR__ | tr -d '\n' | xclip -sel clip"
  "ydl"         "yt-dlp"
  "gdl"         "gallery-dl"
  "tma"         "tmux a"
)

# zfs stuff
abbrevs+=(
  "hymnt"   "sudo zfs load-key zroot/data/hydrus && sudo zfs mount zroot/data/hydrus"
  "hyumnt"  "sudo zfs umount zroot/data/hydrus && sudo zfs unload-key zroot/data/hydrus"
  "zback1"  "sudo zpool import -f -d /dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S2RANX0J441149V-part1 zbackup && sudo zfs load-key zbackup && sudo zpool set cachefile=none zbackup"
)

# Paths
abbrevs+=(
  "awp"   "~/Anime/Wallpaper/__CURSOR__"
  "tt"    "/scratch/__CURSOR__"
  "sc"    "/scratch/__CURSOR__"
)

# topgrade
abbrevs+=(
  "tg"    "topgrade"
  "tgt"   "topgrade --tmux"
)

# nix
abbrevs+=(
  "ngc"   "sudo nix-collect-garbage -d --verbose && nix-collect-garbage -d --verbose"
  "nsd"   "sudo nixos-rebuild switch --flake \"\${HOME}/nixos#NixDesktop\""
  "ntd"   "sudo nixos-rebuild test --flake \"\${HOME}/nixos#NixDesktop\""
  "nbd"   "sudo nixos-rebuild boot --flake \"\${HOME}/nixos#NixDesktop\""
  "nsx"   "sudo nixos-rebuild switch --flake \"\${HOME}/nixos#NixX230\""
  "ntx"   "sudo nixos-rebuild test --flake \"\${HOME}/nixos#NixX230\""
  "nbx"   "sudo nixos-rebuild boot --flake \"\${HOME}/nixos#NixX230\""
  "nxs"   "nix-shell --command zsh -p"
  "nrp"   "nix run github:pjones/plasma-manager/plasma-5"
)

# apt
abbrevs+=(
  "aptu"  "sudo apt update"
  "aptU"  "sudo apt upgrade"
  "aptuU" "sudo apt update && sudo apt upgrade"
  "aptr"  "sudo apt remove"
  "aptar" "sudo apt autoremove"
  "aptp"  "sudo apt purge"
  "apti"  "sudo apt install"
  "apts"  "apt search"
)

# pacman
abbrevs+=(
  "pacU"	"sudo pacman -Syu"
  "paci"	"sudo pacman -S"
  "pacs"	"pacman -Ss"
  "pacQ"	"pacman -Q"
  "pacq"	"pacman -Qs"
  "pacr"	"sudo pacman -Rcns"
  "pacR"	"sudo pacman -Runs"
)

# aur
abbrevs+=(
  "ac"	"aur sync --pacman-conf /etc/pacman_chroot.conf --makepkg-conf /etc/makepkg_chroot.conf -c"
  "avd"	"aur vercmp-devel"
)

# rsync
abbrevs+=(
  "rs1"   "rsync --progress --partial --archive"
  "rz1"   "rsync --progress --partial --archive --compress"
  "rs2"   "rsync --info=progress2 --partial --archive"
  "rz2"   "rsync --info=progress2 --partial --archive --compress"
  "rsf1"  "rsync --progress --partial --archive --hard-links --acls --xattrs"
  "rzf1"  "rsync --progress --partial --archive --hard-links --acls --xattrs --compress"
  "rsf2"  "rsync --info=progress2 --partial --archive --hard-links --acls --xattrs"
  "rzf2"  "rsync --info=progress2 --partial --archive --hard-links --acls --xattrs --compress"
)

# systemd
abbrevs+=(
  "scl"   "systemctl status"
  "scs"   "sudo systemctl start"
  "sce"   "sudo systemctl enable"
  "scse"  "sudo systemctl enable --now"
  "sct"   "sudo systemctl stop"
  "scd"   "sudo systemctl disable"
  "sctd"  "sudo systemctl disable --now"
)

# firewalld
abbrevs+=(
  "fdl"  "sudo firewall-cmd --list-all"
  "fds"  "sudo firewall-cmd --permanent --add-service=__CURSOR__"
  "fdp"  "sudo firewall-cmd --permanent --add-port=__CURSOR__"
  "fdr"  "sudo firewall-cmd --reload"
)

# Ansible
abbrevs+=(
  "ap"    "ansible-playbook"
)

# Docker
abbrevs+=(
  "dk"    "docker"
  "dkrit" "docker run -it"
  "dki"   "docker images"
  "dkig"  "docker images | grep __CURSOR__ | awk '{print \$3}'"
  "dm"    "docker-machine"
  "dmssh" "docker-machine ssh"
  "dc"    "docker compose"
  "dkbd"  "docker build ."
  "dkbt"  "docker build -t __CURSOR__ ."
  "drid"  "docker rmi -f \$(docker images -q -f \"dangling=true\")"
  "dcu"   "docker compose up"
  "dcd"   "docker compose down"
  "dcbd"  "docker compose build"
)

# Podman
abbrevs+=(
  "pd"    "podman"
  "pdrit" "podman run -it"
  "pdi"   "podman images"
  "pdig"  "podman images | grep __CURSOR__ | awk '{print \$3}'"
  "pc"    "podman-compose"
  "pcu"   "podman-compose up"
  "pcdu"  "podman-compose down && podman-compose up"
  "pcb"   "podman-compose build"
  "pdbd"  "podman build ."
  "pdbt"  "podman build -t __CURSOR__ ."
  "prid"  "podman rmi -f \$(docker images -q -f \"dangling=true\")"
  "pdsp"  "podman system prune"
)

# kubectl
abbrevs+=(
  "kc"    "kubectl"
  "kg"    "kubectl get"
  "kga"   "kubectl get --all-namespaces"
  "kgn"   "kubectl get nodes"
  "kgp"   "kubectl get pods"
  "kgpa"  "kubectl get pods --all-namespaces"
  "kgd"   "kubectl get deployments"
  "kgda"  "kubectl get deployments --all-namespaces"
  "kgs"   "kubectl get services"
  "kgsa"  "kubectl get services --all-namespaces"
  "kgi"   "kubectl get ingress"
  "kgia"  "kubectl get ingress --all-namespaces"
  "kgv"   "kubectl get pv"
  "kgva"  "kubectl get pv --all-namespaces"
  "kgc"   "kubectl get pvc"
  "kgca"  "kubectl get pvc --all-namespaces"
  "ka"    "kubectl apply"
  "kaf"   "kubectl apply -f"
  "kak"   "kubectl apply -k"
  "kd"    "kubectl delete"
  "kdf"   "kubectl delete -f"
  "kdk"   "kubectl delete -k"
  "kdp"   "kubectl delete pods"
  "kdd"   "kubectl delete deployments"
  "kds"   "kubectl delete services"
  "kdi"   "kubectl delete ingress"
  "kdv"   "kubectl delete pv"
  "kdc"   "kubectl delete pvc"
  "kpv"   "kubectl get pv | awk '/Released/ {print \$1;}' | xargs -I{} kubectl delete pv {}"
  "kcdbg" "kubectl run --stdin --tty --rm debug --image=alpine --restart=Never -- sh"
  "kb"    "kustomize build"
  "kbka"  "kustomize build __CURSOR__ | kubectl apply -f -"
  "k3dc"  "k3d cluster create --config ~/.kube/k3d.yaml && k3d kubeconfig get k3s-default > ~/.kube/k3d.config"
  "k3dd"  "k3d cluster delete && rm ~/.kube/k3d.config"
)

# dav
abbrevs+=(
  "khc"   "khal calendar now 7d"
  "khi"   "khal interactive"
  "td"    "todo | tac"
)

for abbr in ${(k)abbrevs}; do
  alias $abbr="${abbrevs[$abbr]}"
done

magic-enter () {
  # If commands are not already set, use the defaults
  [ -z "$MAGIC_ENTER_GIT_COMMAND" ] && MAGIC_ENTER_GIT_COMMAND="git status -u . && ls -lh"
  [ -z "$MAGIC_ENTER_OTHER_COMMAND" ] && MAGIC_ENTER_OTHER_COMMAND="ls -lh ."

  if [[ -z $BUFFER ]]; then
    echo ""
    if git rev-parse --is-inside-work-tree &>/dev/null; then
      eval "$MAGIC_ENTER_GIT_COMMAND"
    else
      eval "$MAGIC_ENTER_OTHER_COMMAND"
    fi
    zle redisplay
  else
    zle accept-line
  fi
}

magic-abbrev-expand() {
  local MATCH
  LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
  command=${abbrevs[$MATCH]}
  LBUFFER+=${command:-$MATCH}

  if [[ "${command}" =~ "__CURSOR__" ]]; then
    RBUFFER=${LBUFFER[(ws:__CURSOR__:)2]}
    LBUFFER=${LBUFFER[(ws:__CURSOR__:)1]}
  else
    zle self-insert
  fi
}

magic-abbrev-expand-and-execute() {
  magic-enter
  magic-abbrev-expand
  zle backward-delete-char
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-enter
zle -N magic-abbrev-expand
zle -N magic-abbrev-expand-and-execute
zle -N no-magic-abbrev-expand

bindkey " " magic-abbrev-expand
bindkey "^M" magic-abbrev-expand-and-execute
bindkey "^x " no-magic-abbrev-expand
bindkey -M isearch " " self-insert

# vim: ts=2 sw=2 sts=2 et smartindent
