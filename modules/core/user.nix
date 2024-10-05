{ pkgs, config, ... }:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jerry = {
    isNormalUser = true;
    home = "/home/jerry";
    extraGroups = [
      "wheel"
      "libvirtd"
    ] ++ (if config.ipfs.enable then [ config.services.kubo.group ] else [ ]);
    shell = pkgs.zsh;
  };
}
