{...}: {
  programs.tmux = {
    enable = true;

    enableFzf = true;

    enableMouse = true;

    enableSensible = true;

    enableVim = true;

    extraConfig = ''
      # keybindings
      set -g mouse on

      # Set prefix
      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix

      # Start windows and panes at 1
      set -g base-index 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

        set -g @plugin 'tmux-plugins/tpm'
        set -g @plugin 'odedlaz/tmux-onedark-theme'
        set -g @plugin 'tmux-plugins/yank'

        run '~/.tmux/plugins/tpm/tpm'

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}
