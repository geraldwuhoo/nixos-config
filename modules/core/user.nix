{ pkgs, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jerry = {
    isNormalUser = true;
    home = "/home/jerry";
    extraGroups = [ "wheel" "libvirtd" ];
    shell = pkgs.zsh;
  };
}
