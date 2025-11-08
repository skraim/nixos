{ pkgs, config, ... }:
{
  programs = {
    tmux = {
      enable = true;
      focusEvents = true;
      baseIndex = 1;
      escapeTime = 0;
      historyLimit = 5000;
      mouse = true;
      customPaneNavigationAndResize = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "xterm-256color";
      tmuxp.enable = true;
      extraConfig = ''
        set -ga terminal-overrides ",xterm-256color:Tc"
        set -g allow-passthrough all
        set -ga update-environment TERM_PROGRAM
        set -g visual-activity off

        set -g status-position top
        set -g status-left "#[fg=blue,bg=default] #[fg=black,bg=blue] #S #[fg=blue,bg=default]  "
        set -g status-right "#[fg=green]#{server_sessions} session(s) #[fg=cyan,bold,bg=default]%a %Y-%m-%d %H:%M"
        set -g status-justify left
        set -g status-left-length 200
        set -g status-right-length 200
        set -g status-style 'bg=default'
        set -g window-status-current-format '#[fg=magenta,bg=default]#[fg=black,bg=magenta]#[bold]#I#[nobold]: #W#[fg=magenta,bg=default]'
        set -g window-status-format '#[fg=gray,bg=default]#[bold]#I#[nobold]: #W'

        bind y select-pane -L
        bind h select-pane -D
        bind a select-pane -U
        bind e select-pane -R
      '';
    };
  };

  home.file = {
    ".tmuxp/dl-fe.yaml".text = ''
      session_name: dl-fe
      start_directory: ${builtins.readFile config.sops.secrets.proj_dir_dlfe.path}
      windows:
        - window_name: dev
          focus: true
          panes:
          - shell_command:
            - cmd: nvim .
        - window_name: git
          panes:
          - shell_command: lazygit
        - window_name: shell
          panes:
            - shell_command:
        - window_name: todo
          panes:
            - shell_command:
              - cmd: nvim ~/todos/dl.todo.md
        - window_name: build
          panes:
            - echo ${builtins.readFile config.sops.secrets.proj_runcmd_dlfe.path}
    '';
    ".tmuxp/dl-aem.yaml".text = ''
      session_name: dl-aem
      start_directory: ${builtins.readFile config.sops.secrets.proj_dir_dlaem.path}
      windows:
        - window_name: dev
          focus: true
          panes:
          - shell_command:
            - cmd: nvim .
        - window_name: git
          panes:
          - shell_command: lazygit
        - window_name: shell
          panes:
            - shell_command:
        - window_name: todo
          panes:
            - shell_command:
              - cmd: nvim ~/todos/dl.todo.md
    '';
    ".tmuxp/sc.yaml".text = ''
      session_name: sc
      start_directory: ${builtins.readFile config.sops.secrets.proj_dir_sc.path}
      windows:
        - window_name: dev
          focus: true
          panes:
          - shell_command:
            - cmd: nvim .
        - window_name: git
          panes:
          - shell_command: lazygit
        - window_name: shell
          panes:
            - shell_command:
        - window_name: todo
          panes:
            - shell_command:
              - cmd: nvim ~/todos/sc.todo.md
    '';
    ".tmuxp/lw.yaml".text = ''
      session_name: lw
      start_directory: ${builtins.readFile config.sops.secrets.proj_dir_lw.path}
      windows:
        - window_name: dev
          focus: true
          panes:
          - shell_command:
            - cmd: nvim .
        - window_name: git
          panes:
          - shell_command: lazygit
        - window_name: shell
          panes:
            - shell_command:
        - window_name: todo
          panes:
            - shell_command:
              - cmd: nvim ~/todos/lw.todo.md
    '';
    ".tmuxp/nix.yaml".text = ''
      session_name: nix
      start_directory: ~/nixos/
      windows:
        - window_name: dev
          focus: true
          panes:
          - shell_command:
            - cmd: nvim .
        - window_name: git
          panes:
            - shell_command: lazygit
        - window_name: shell
          panes:
            - shell_command:
        - window_name: todo
          panes:
            - shell_command:
              - cmd: nvim ~/todos/setup.todo.md
    '';
  };
}
