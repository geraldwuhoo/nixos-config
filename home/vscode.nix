{ pkgs, ... }: {
  # Stylix auto-theming is ass compared to the Nordic package
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # Vim keybindings
      vscodevim.vim

      # Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      mkhl.direnv

      # Rust
      rust-lang.rust-analyzer
      tamasfe.even-better-toml

      # GoLang
      golang.go

      # Python
      ms-python.python
      ms-python.isort
      ms-python.vscode-pylance
      ms-python.black-formatter

      # Containers/Kubernetes
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-azuretools.vscode-docker

      # IaC
      hashicorp.terraform
      redhat.vscode-yaml

      # CSV
      mechatroner.rainbow-csv

      # Theming
      arcticicestudio.nord-visual-studio-code
      pkief.material-icon-theme
    ];

    userSettings = {
      # Theming
      "workbench.colorTheme" = "Nord";
      "workbench.iconTheme" = "material-icon-theme";

      # Mandatory for high refresh screens
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.smoothScrolling" = true;

      # D E N S I T Y
      "editor.fontSize" = 14;
      "editor.minimap.enabled" = false;
      "editor.wordWrap" = "on";
      "window.menuBarVisibility" = "toggle";
      "window.zoomLevel" = -1.5;

      # vim niceties
      "vim.smartRelativeLine" = true;
      "editor.lineNumbers" = "relative";
      "vim.easymotion" = true;
      "vim.leader" = "<space>";

      # nix
      "nix.enableLanguageServer" = true;
      "nix.formatterPath" = "/run/current-system/sw/bin/nixfmt";

      # Begone telemetry
      "redhat.telemetry.enabled" = false;
    };
  };
}
