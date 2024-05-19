{ ... }: {
  imports = [ ./email.nix ];

  # thunderbird
  programs.thunderbird = {
    enable = true;
    profiles.jerry = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };
}
