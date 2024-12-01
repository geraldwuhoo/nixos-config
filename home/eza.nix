{ lib, config, ... }:
{
  options = {
    eza.enable = lib.mkEnableOption "enables eza";
  };

  config = lib.mkIf config.eza.enable {
    programs.eza = {
      enable = true;
      icons = "auto";
      git = true;
      extraOptions = [
        "--color=auto"
        "--group-directories-first"
      ];
    };
  };
}
