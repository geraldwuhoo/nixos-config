{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "aur.archlinux.org" = {
        IdentityFile = "~/.ssh/aur";
        User = "aur";
      };
      "gitlab.com" = {
        PreferredAuthentications = "publickey";
        IdentityFile = "~/.ssh/id_gitlab";
      };
      # Old Brocade switch only speaks legacy crypto
      "icx6450 192.168.1.55 10.0.0.10" = {
        KexAlgorithms = "+diffie-hellman-group1-sha1";
        HostKeyAlgorithms = "+ssh-rsa";
        PreferredAuthentications = "keyboard-interactive,password";
        ServerAliveInterval = 1;
        ServerAliveCountMax = 10;
      };
      "bake nise neko kabuki".User = "root";
      "hetzner shinobu araragi k3s-master-? k3s-worker-?".User = "nixos";
    };
  };
}
