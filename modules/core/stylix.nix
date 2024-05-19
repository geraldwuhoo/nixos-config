{ pkgs, config, ... }: {
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    polarity = "dark";

    fonts = {
      sansSerif = {
        name = "DejaVu Sans";
        package = pkgs.dejavu_fonts;
      };
      serif = {
        name = "DejaVu Serif";
        package = config.stylix.fonts.sansSerif.package;
      };
      monospace = {
        name = "DejaVu Sans Mono for Powerline";
        package = pkgs.powerline-fonts;
      };
      sizes = {
        applications = 9;
        desktop = 9;
        popups = 9;
        terminal = 9;
      };
    };

    cursor = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
      size = 24;
    };

    opacity.terminal = 0.95;
  };
}
