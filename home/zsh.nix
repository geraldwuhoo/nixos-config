{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Not packaged in nixpkgs, so pin them here instead of cloning at shell startup.
  minimal-prompt = pkgs.fetchFromGitHub {
    owner = "subnixr";
    repo = "minimal";
    rev = "6588a399744f34194a25988b4c159cb8b8c67e27";
    hash = "sha256-r5AIk7TzXQ5x+mXRA6isWCn0FvmICeFR36k5Kq4s+Yk=";
  };
  kube-ps1 = pkgs.fetchFromGitHub {
    owner = "jonmosco";
    repo = "kube-ps1";
    rev = "b4cd09ec8d4dc007173e28da40aeebf8eff8c87f";
    hash = "sha256-b72f0uha4JrdOuDNXE8zUNLBn1ulWQUgJmn0UtjfzNE=";
  };
  zshFiles = ./files/zsh;
in
{
  programs.fzf.enable = true;
  programs.zoxide.enable = true;

  # Extra completion definitions; home-manager puts profile site-functions on fpath.
  home.packages = [ (lib.lowPrio pkgs.zsh-completions) ];

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;

    history = {
      size = 1000000;
      save = config.programs.zsh.history.size;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    historySubstringSearch.enable = true;

    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"
        "line"
        "cursor"
        "root"
      ];
      styles = {
        alias = "fg=green,bold";
        builtin = "fg=blue";
        command = "fg=green";
        commandseparator = "fg=cyan,bold";
        cursor = "bg=magenta";
        double-hyphen-option = "fg=magenta";
        double-quoted-argument = "fg=yellow";
        function = "fg=blue,bold";
        path = "fg=yellow,underline";
        precommand = "fg=blue,underline";
        redirection = "fg=cyan";
        single-hyphen-option = "fg=magenta";
        single-quoted-argument = "fg=yellow";
      };
      patterns = {
        "rm*-rf*" = "fg=white,bold,bg=red";
      };
    };

    # Cache the completion dump and only regenerate it once a day.
    completionInit = ''
      autoload -Uz compinit
      () {
        setopt local_options extended_glob
        local dump="''${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
        mkdir -p ''${dump:h}
        if [[ -n $dump(#qN.mh-24) ]]; then
          compinit -C -d $dump
        else
          compinit -d $dump
          zcompile -R -- $dump
        fi
      }
    '';

    plugins = [
      {
        name = "command-time";
        src = pkgs.zsh-command-time;
        file = "share/zsh/plugins/command-time/command-time.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "minimal";
        src = minimal-prompt;
        file = "minimal.zsh";
      }
      {
        name = "kube-ps1";
        src = kube-ps1;
        file = "kube-ps1.sh";
      }
    ];

    sessionVariables = {
      # Partial line character
      PROMPT_EOL_MARK = "";

      # podman socket config
      DOCKER_SOCK = "/run/user/$UID/podman/podman.sock";
      DOCKER_HOST = "unix://${config.programs.zsh.sessionVariables.DOCKER_SOCK}";

      # ctrl+w stops at certain delimiters
      WORDCHARS = "*?_-.[]~=&;!#$%^(){}<>";

      # Disable checkpoint telemetry for cdktf
      CHECKPOINT_DISABLE = "yes";

      # ffsend config
      FFSEND_HOST = "https://send.wuhoo.xyz";

      # Bat theme config
      BAT_THEME = "Nord";

      # Source all k8s configs
      KUBECONFIG = ''$(\ls ~/.kube | awk -v d="$HOME/.kube/" '/conf/ { printf "%s%s:", d,$0}')'';

      # Disable kopia autoupdate check since we manage it with nix
      KOPIA_CHECK_FOR_UPDATES = "false";
    };

    setOptions = [
      "NO_BEEP"
      "EXTENDED_GLOB"
      "CLOBBER"
      "INC_APPEND_HISTORY"
      # allow background jobs to run after terminal closes
      "NO_HUP"
      "NO_CHECK_JOBS"
    ];

    initContent = lib.mkMerge [
      # Before compinit and plugin sourcing, so plugins see the same options.
      (lib.mkOrder 550 ''
        # Fix time format bc the bash format is 10/10 better
        export TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'
      '')

      # Default order (1000): after plugins are sourced, before syntax highlighting.
      ''
        # command-time
        ZSH_COMMAND_TIME_MIN_SECONDS=10
        ZSH_COMMAND_TIME_EXCLUDE=(ssh xxh vi vim ex ed tmux z zi top htop btm)

        # minimal prompt
        MNML_OK_COLOR=6
        # change prompt char if in nix-shell
        _nix_shell_char () {
          [[ -n "''${IN_NIX_SHELL}" ]] && MNML_USER_CHAR="❄" || MNML_USER_CHAR="λ"
        }
        precmd_functions+=(_nix_shell_char)

        # kube-ps1
        KUBE_PS1_SYMBOL_DEFAULT="k8s"
        KUBE_PS1_SYMBOL_PADDING=false
        KUBE_PS1_SUFFIX=') '
        get_cluster_short() {
          echo "$1" | cut -d'@' -f2
        }
        KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short
        KUBE_PS1_NS_ENABLE=false
        PROMPT='$(kube_ps1)'"$PROMPT"
        kubeoff -g

        source ${zshFiles}/bindkey.zsh
        source ${zshFiles}/aliases.zsh
        source ${zshFiles}/abbreviations.zsh
      ''
    ];
  };
}
