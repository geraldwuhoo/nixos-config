{ pkgs, ... }: {
  # Stylix auto-theming is ass compared to the Nordic package
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;
    # Use unstable Codium package + extensions for latest versions
    package = pkgs.unstable.vscodium;
    extensions = with pkgs.unstable.vscode-extensions; [
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
      ms-python.vscode-pylance # unfree
      ms-python.black-formatter

      # Containers/Kubernetes
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-azuretools.vscode-docker

      # IaC
      hashicorp.terraform
      redhat.vscode-yaml
      redhat.ansible
      signageos.signageos-vscode-sops # unfree (no LICENSE in upstream)

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
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.smoothScrolling" = true;
      "workbench.list.smoothScrolling" = true;
      "terminal.integrated.smoothScrolling" = true;

      # D E N S I T Y
      "editor.fontSize" = 14;
      "editor.minimap.enabled" = false;
      "editor.wordWrap" = "on";
      "window.menuBarVisibility" = "toggle";
      "window.zoomLevel" = -1.5;

      # vim niceties
      "editor.lineNumbers" = "relative";
      "vim.smartRelativeLine" = true;
      "vim.easymotion" = true;
      "vim.leader" = "<space>";

      # nix
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.formatterPath" = "/run/current-system/sw/bin/nixfmt";

      # Begone telemetry
      "redhat.telemetry.enabled" = false;
    };
  };
}
