{ pkgs, lib, ... }:

{
  programs = {
    zsh = {
      enable = true;
      completionInit = ''
        autoload -U compinit
        zstyle ':completion:*' menu select
        zmodload zsh/complist
        compinit
        _comp_options+=(globdots)
      '';
      defaultKeymap = "emacs";
      autosuggestion = {
        enable = true;
      };
      envExtra = ''
        export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout reverse --height 40% --preview='bat -p --color=always {}'"
        export MANPAGER="/bin/sh -c 'col -bx | bat -l man -p'"
        export MANROFFOPT="-c"
      '';
      history = {
        append = true;
        expireDuplicatesFirst = true;
        extended = true;
        findNoDups = true;
        share = false;
      };
      historySubstringSearch = {
        enable = true;
        searchUpKey = [
          "^[[A"
          "^[OA"
        ];
        searchDownKey = [
          "^[[B"
          "^[OB"
        ];
      };
      localVariables = {
        PS2 = "%F{green}❯❯ %";
        TERM = "xterm-256color";
        KITTY_CONFIG_DIRECTORY = "$HOME/.config/kitty/";
        AUTO_NOTIFY_IGNORE = [
          "docker"
          "man"
          "sleep"
          "yazi"
          "yy"
          "nvim"
          "lazygit"
          "lg"
          "tmux"
          "tmuxp"
          "gpg"
          "bluetui"
          "bc"
          "claude"
          "codex"
          "btop"
          "rmpc"
          "systemctl"
        ];
        AUTO_NOTIFY_EXPIRE_TIME = "5000";
        AUTO_NOTIFY_CANCEL_ON_SIGINT = "0";
      };
      syntaxHighlighting.enable = true;
      setOptions = [
        "GLOB_DOTS"
        "HIST_REDUCE_BLANKS"
      ];
      shellGlobalAliases = {
        "-h" = "-h 2>&1 | bat --language=help --style=plain";
        "--help" = "--help 2>&1 | bat --language=help --style=plain";
      };
      shellAliases = {
        ls = "ls -lhA --color=auto --group-directories-first";
        lg = "lazygit";
        ":q" = "exit";
        txl = "tmuxp load";
        txk = "tmux kill-session";
        txa = "tmux a";
        txls = "tmux ls";
        tx = "tmux";
        gd = "cd ~/Downloads";
        ge = "cd /run/media/$USER";
        gp = "cd ~/Pictures";
        v = "nvim";
        cam = "guvcview";
        fd = "fd --hidden";
        rg = "rg --hidden";
        cat = "bat";
        trash = "gio trash";
        ff = "fastfetch";
        nrs = "sudo nixos-rebuild switch --flake ~/nixos --impure";
        ns = "nix-shell";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./.;
          file = "p10k.zsh";
        }
        {
          name = "auto-notify";
          src = pkgs.fetchFromGitHub {
            owner = "MichaelAquilina";
            repo = "zsh-auto-notify";
            rev = "b51c934d88868e56c1d55d0a2a36d559f21cb2ee";
            hash = "sha256-s3TBAsXOpmiXMAQkbaS5de0t0hNC1EzUUb0ZG+p9keE=";
          };
        }
      ];
      initContent =
        let
          zshKeybinds = lib.mkOrder 550 ''
            zstyle :zle:edit-command-line editor nvim
            autoload edit-command-line; zle -N edit-command-line
            bindkey '^e' edit-command-line
            bindkey '^H' backward-kill-word
            bindkey '^[[3;5~' kill-word
            bindkey '^[[3~' delete-char
            bindkey '^[[1;5D' backward-word
            bindkey '^[[1;5C' forward-word
            bindkey '^[[1;5A' beginning-of-line
            bindkey '^[[1;5B' end-of-line
          '';
          direnvHook = lib.mkOrder 1000 ''
            eval "$(direnv hook zsh)"
          '';
        in
        lib.mkMerge [ zshKeybinds direnvHook ];
    };
    fzf = {
      enableZshIntegration = true;
      enable = true;
    };
    fastfetch = {
      enable = true;
    };
  };
  xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
}
