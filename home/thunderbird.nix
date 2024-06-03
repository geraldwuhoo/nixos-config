{ lib, config, ... }:
{
  imports = [ ./email.nix ];

  options = {
    thunderbird.enable = lib.mkEnableOption "enables thunderbird";
  };

  config = lib.mkIf config.thunderbird.enable {
    # thunderbird
    programs.thunderbird = {
      enable = true;
      profiles.jerry = {
        isDefault = true;
        withExternalGnupg = true;
      };
    };
  };
}
