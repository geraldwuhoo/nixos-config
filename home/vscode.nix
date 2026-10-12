{ pkgs, ... }:
{
  # Stylix auto-theming is ass compared to the Nordic package
  stylix.targets.vscodium.enable = false;

  programs.vscodium = {
    enable = true;
    # Use unstable Codium package + extensions for latest versions
    package = pkgs.unstable.vscodium;
    profiles.default = {
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

        # Enhanced text
        mechatroner.rainbow-csv
        yzhang.markdown-all-in-one

        # Theming
        arcticicestudio.nord-visual-studio-code
        pkief.material-icon-theme

        # Clanker
        anthropic.claude-code
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
        "editor.inlayHints.fontSize" = 10;
        "editor.minimap.enabled" = false;
        "editor.wordWrap" = "on";
        "window.menuBarVisibility" = "toggle";
        "window.titleBarStyle" = "native";
        "window.customTitleBarVisibility" = "never";
        "window.zoomLevel" = -1.5;

        # Clanker
        "claudeCode.useTerminal" = true;

        # Why does this even exist
        "terminal.integrated.stickyScroll.enabled" = false;

        # vim niceties
        "editor.lineNumbers" = "relative";
        "vim.smartRelativeLine" = true;
        "vim.easymotion" = true;
        "vim.leader" = "<space>";

        # nix
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.formatterPath" = "/run/current-system/sw/bin/nixfmt";

        # disable trash
        "files.enableTrash" = false;

        # Begone telemetry
        "redhat.telemetry.enabled" = false;
      };
    };
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.unstable.claude-code;

    settings = {
      model = "opus";
      effortLevel = "high";
      modelSettings = {
        "claude-opus-5".effortLevel = "high";
        "claude-opus-5-5".effortLevel = "medium";
      };
      theme = "dark-ansi";

      env = {
        # Umbrella: telemetry, error reports, /feedback, updates, release notes, feature flags
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
        DISABLE_TELEMETRY = "1";
        DO_NOT_TRACK = "1";
        DISABLE_ERROR_REPORTING = "1";
        DISABLE_GROWTHBOOK = "1";
        DISABLE_FEEDBACK_COMMAND = "1";
        CLAUDE_CODE_SEND_FEEDBACK = "0";
        CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
        DISABLE_AUTOUPDATER = "1";
        CLAUDE_CODE_DISABLE_OFFICIAL_MARKETPLACE_AUTOINSTALL = "1";
        # Client version and prompt fingerprint in the system prompt
        CLAUDE_CODE_ATTRIBUTION_HEADER = "0";
        # No transcripts or prompt history on disk; breaks --resume and up-arrow history
        CLAUDE_CODE_SKIP_PROMPT_HISTORY = "1";
        # Also skips the model request that names each session
        CLAUDE_CODE_DISABLE_TERMINAL_TITLE = "1";
      };

      feedbackSurveyRate = 0;
      feedbackDrafts = "off";
      # Otherwise every WebFetch hostname is sent to api.anthropic.com first
      skipWebFetchPreflight = true;
      attribution.sessionUrl = false;
      # Minimum allowed; purges existing transcripts older than a day
      cleanupPeriodDays = 1;
      syncClaudeAiSkills = false;
      syncClaudeAiPlugins = false;
      enableArtifact = false;
      disableRemoteControl = true;
    };
  };
}
