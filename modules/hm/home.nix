{ config, pkgs, inputs, nixpkgs, yazi, ... }:

{
  imports = [
    ../shell
    ../hyprland
    ../qs
    ../pass-store
    ../yazi
    ../kitty
    ../nvim
    ../handlr
    ../git
    ../tmux
    ../lazygit
    ../pywal
  ];

  gtk = {
    enable = true;

    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };

    iconTheme = {
      package = pkgs.nordzy-icon-theme;
      name = "Nordzy";
    };
  };

  programs = {
    home-manager.enable = true;
    java.enable = true;
    claude-code.enable = true;
    gpg.enable = true;

    btop = {
      enable = true;
      settings = {
        color_theme = "TTY";
        theme_background = false;
      };
    };

    librewolf = {
      enable = true;
      settings = {
        "middlemouse.paste" = false;
        "general.autoScroll" = true;
      };
      nativeMessagingHosts = [ pkgs.passff-host ];
    };

    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs = [
        "--enable-features=MiddleClickAutoscroll"
        "--extension-mime-request-handling=always-prompt-for-install"
        "--webrtc-ip-handling-policy=default_public_interface_only"
      ];
    };

    less = {
      enable = true;
      config = ''
      h forw-line
      a back-line
      '';
    };

    bat = {
      enable = true;
      config = {
        style = "plain";
      };
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  home = {
    sessionVariables = {
      ANTHROPIC_API_KEY = builtins.readFile config.sops.secrets.anthropic_api_key.path;
    };
    sessionVariablesExtra = ''
      export PATH="$HOME/scripts:$HOME/.npm-global/bin:$PATH"
    '';
    file = {
      ".pam-gnupg".text = "8DC4A8D3BB188FC9E265261B2A36C117664BFF56";
      "scripts" = {
        source = ../../scripts;
        recursive = true;
      };
    };
    stateVersion = "25.05";
    packages = with pkgs; [
      spotify
      freecad
      tldr
      zapzap
      teams-for-linux
      bc
      nerd-fonts.meslo-lg
      nerd-fonts.profont
      jq
      swappy
      material-symbols
      dunst
      snx-rs
      jetbrains.idea-oss
      qbittorrent
      rofi
      telegram-desktop
      slack
      bibata-cursors
      lazygit
      slurp
      libreoffice
      (import ../chromium-profiles/general.nix { inherit pkgs; })
      (import ../chromium-profiles/dl.nix { inherit pkgs; })
      grim
      wl-screenrec
      vlc
      zbar
      bluetui
      nwg-look
      gsettings-desktop-schemas
      cliphist
      maven
      playerctl
      orca-slicer
    ];
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      extraConfig = ''
        allow-preset-passphrase
      '';
      maxCacheTtl = 86400;
      pinentry.package = pkgs.pinentry-qt;
    };
  };

  fonts.fontconfig.enable = true;

  sops = {
    age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519_personal" ];
    defaultSopsFile = ../../secrets.yaml;
    secrets = {
      "personal_email" = {};
      "git_name_lw" = {};
      "git_email_lw" = {};
      "git_name_dl" = {};
      "git_email_dl" = {};
      "git_name_dh" = {};
      "git_email_dh" = {};
      "git_name_sc" = {};
      "git_email_sc" = {};
      "anthropic_api_key" = {};
      "link_regex_sc" = {};
      "link_regex_lw" = {};
      "link_regex_dl1" = {};
      "link_regex_dl2" = {};
      "proj_dir_dlfe" = {};
      "proj_runcmd_dlfe" = {};
      "proj_dir_dlaem" = {};
      "proj_dir_sc" = {};
      "proj_dir_lw" = {};
    };
  };
}
