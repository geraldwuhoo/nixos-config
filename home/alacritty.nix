{ ... }:
{
  # Alacritty
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        WINIT_X11_SCALE_FACTOR = "1.0";
      };
    };
  };
}
