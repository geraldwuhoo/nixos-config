{ pkgs, ... }: {
  programs.fzf.tmux.enableShellIntegration = true;

  programs.tmux = {
    enable = true;
    mouse = false;
    keyMode = "vi";
    tmuxinator.enable = true;

    plugins = with pkgs.tmuxPlugins; [
      nord
      prefix-highlight
      resurrect
      tmux-fzf
      vim-tmux-navigator
    ];

    extraConfig = ''
      # for sxhkd
      set -g set-titles on
      set -g set-titles-string "#T"
      setw -g automatic-rename

      # 256 color
      set -g default-terminal "xterm-256color"

      # smart pane switching with awareness of vim splits
      bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-h) || tmux select-pane -L"
      bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-j) || tmux select-pane -D"
      bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-k) || tmux select-pane -U"
      bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iq vim && tmux send-keys C-l) || tmux select-pane -R"

      # switch windows easy
      bind -n M-l next-window
      bind -n M-h previous-window

      # send prefix to nested window
      bind-key -n C-g send-prefix

      # don't rename windows automatically
      set-option -g allow-rename off

      # resize panes in tty
      bind < resize-pane -L 3
      bind > resize-pane -R 3
      bind + resize-pane -U 1
      bind - resize-pane -D 1

      # toggle status bar
      bind -n C-t set-option -g status

      # auto renumber
      set-option -g renumber-windows on
    '';
  };
}
