{ config, ... }:
{
  programs.fzf.enable = true;

  home.file.".zsh/bindkey.zsh".source = ./files/zsh/bindkey.zsh;
  home.file.".zsh/aliases.zsh".source = ./files/zsh/aliases.zsh;
  home.file.".zsh/abbreviations.zsh".source = ./files/zsh/abbreviations.zsh;

  programs.zsh = {
    enable = true;
    enableCompletion = false;

    history = {
      size = 1000000;
      save = config.programs.zsh.history.size;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

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

    initContent = ''
      setopt no_beep
      setopt extendedglob

      # allow background jobs to run after terminal closes
      setopt NO_HUP
      setopt NO_CHECK_JOBS

      # appends every command to the history file once it is executed
      setopt inc_append_history
      setopt clobber

      # Fix time format bc the bash format is 10/10 better
      export TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'

      # zinit
      ZINIT_HOME="${config.home.homeDirectory}/.local/share/zinit/zinit.git"
      [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
      [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      source "''${ZINIT_HOME}/zinit.zsh"

      # command-time
      zinit ice wait lucid
      zinit light popstas/zsh-command-time
      ZSH_COMMAND_TIME_MIN_SECONDS=10
      ZSH_COMMAND_TIME_EXCLUDE=(ssh xxh vi vim ex ed tmux z zi top htop btm)

      # history-substring-search
      zinit ice wait"0a" lucid
      zinit light zsh-users/zsh-history-substring-search
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # syntax highlighting
      zinit ice wait"0b" lucid
      zinit light zsh-users/zsh-syntax-highlighting
      # highlighters
      ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern line cursor root)
      # colors
      typeset -A ZSH_HIGHLIGHT_STYLES
      ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
      ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue'
      ZSH_HIGHLIGHT_STYLES[command]='fg=green'
      ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=cyan,bold'
      ZSH_HIGHLIGHT_STYLES[cursor]='bg=magenta'
      ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=magenta'
      ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
      ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'
      ZSH_HIGHLIGHT_STYLES[path]='fg=yellow,underline'
      ZSH_HIGHLIGHT_STYLES[precommand]='fg=blue,underline'
      ZSH_HIGHLIGHT_STYLES[redirection]='fg=cyan'
      ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=magenta'
      ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
      # patterns
      typeset -A ZSH_HIGHLIGHT_PATTERNS
      ZSH_HIGHLIGHT_PATTERNS+=('rm*-rf*' 'fg=white,bold,bg=red')

      # autosuggestions
      zinit ice wait"0c" lucid atload"_zsh_autosuggest_start"
      zinit light zsh-users/zsh-autosuggestions

      # completions
      zinit wait lucid atload"zicompinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION; zicdreplay" blockf for \
          zsh-users/zsh-completions \
          Aloxaf/fzf-tab

      # minimal2
      zinit light subnixr/minimal
      MNML_OK_COLOR=6
      # change prompt char if in nix-shell
      _nix_shell_char () {
        [[ -n "''${IN_NIX_SHELL}" ]] && MNML_USER_CHAR="❄" || MNML_USER_CHAR="λ"
      }
      precmd_functions+=_nix_shell_char

      # zoxide
      zinit ice wait"0d" as"command" from"gh-r" lucid \
        mv"zoxide -> zoxide" \
        atclone"./zoxide init zsh > init.zsh" \
        atpull"%atclone" src"init.zsh" nocompile'!' \
        atload'unalias zi'
      zinit light ajeetdsouza/zoxide

      # kube-ps1
      zinit light jonmosco/kube-ps1
      KUBE_PS1_SYMBOL_DEFAULT="k8s"
      KUBE_PS1_SYMBOL_PADDING=false
      KUBE_PS1_SUFFIX=') '
      function get_cluster_short() {
          echo "$1" | cut -d'@' -f2
      }
      KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short
      KUBE_PS1_NS_ENABLE=false
      PROMPT='$(kube_ps1)'"$PROMPT"
      kubeoff -g

      # Source everything from ~/.zsh/*.zsh
      for f ("$HOME"/.zsh/*.zsh) . $f
    '';
  };
}
