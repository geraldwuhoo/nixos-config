{ ... }:
{
  programs.eza = {
    enable = true;
    icons = true;
    git = true;
    extraOptions = [
      "--color=auto"
      "--group-directories-first"
    ];
  };
}
