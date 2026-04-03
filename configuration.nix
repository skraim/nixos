{ inputs, config, pkgs, lib, ... }:
with lib; let
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";
    themeConfig = {
      Blur = 1.0;
      BlurMax = 64;
      FormPosition = "left";
      Font = "Jersey 10";
      FontSize = 20;
      HideSystemButtons = false;
      HideVirtualKeyboard = true;
    };
  };

  sddmDependencies = with pkgs; [
    sddm-astronaut
    kdePackages.qtmultimedia
    google-fonts
  ];
in
  {
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        # "librewolf-bin-146.0.1-1"
        # "librewolf-bin-unwrapped-146.0.1-1"
        "openssl-1.1.1w"
      ];
    };
  };

  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader =
      {
        timeout = 2;
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

    kernelParams = [ "i915.enable_guc=3" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      download-buffer-size = 500000000;
        substituters = [
          "https://cache.nixos.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];

    };
  };

  environment.variables.NIXOS_FLAKE_PATH = builtins.getEnv "PWD";

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu.runAsRoot = false;
    };
  };

  networking = {
    hostName = "nixos";
    firewall.checkReversePath = "loose";
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-fortisslvpn
        networkmanager-l2tp
        networkmanager-openvpn
        networkmanager-strongswan
      ];
    };
  };

  programs = {
    nix-index-database.comma.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
    nm-applet.enable = true;
    ydotool.enable = true;
    zsh.enable = true;
    hyprland.enable = true;
    thunar.enable = true;
    npm = {
      enable = true;
      package = pkgs.nodejs_20;
    };
  };

  time.timeZone = "Europe/Kyiv";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "uk_UA.UTF-8";
      LC_IDENTIFICATION = "uk_UA.UTF-8";
      LC_MEASUREMENT = "uk_UA.UTF-8";
      LC_MONETARY = "uk_UA.UTF-8";
      LC_NAME = "uk_UA.UTF-8";
      LC_NUMERIC = "uk_UA.UTF-8";
      LC_PAPER = "uk_UA.UTF-8";
      LC_TELEPHONE = "uk_UA.UTF-8";
      LC_TIME = "uk_UA.UTF-8";
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
  };

  services = {
    pcscd.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    gnome.gnome-keyring.enable = true;
    xl2tpd.enable = true;
    libinput.enable = true;
    power-profiles-daemon.enable = true;
    tailscale.enable = true;
    strongswan = {
      enable = true;
      secrets = [
        "ipsec.d/ipsec.nm-l2tp.secrets"
      ];
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = sddmDependencies;
    };
    xserver = {
      videoDrivers = [ "modesetting" ];
      xkb = {
        layout = "us,ua-graph-rev";
        variant = "";
        extraLayouts = {
          ua-graph-rev = {
            description = "UA Graphite reverse";
            symbolsFile = ./xkb/ua-graph-rev;
            languages = [ "ua" ];
          };
        };
      };
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber = {
        enable = true;
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-mitigate-annoying-profile-switch.conf" ''
            wireplumber.settings = {
              bluetooth.autoswitch-to-headset-profile = false
            }

            monitor.bluez.properties = {
              bluez5.roles = [ a2dp_sink a2dp_source ]
            }
          '')
        ];
      };
      extraConfig.pipewire = {
        "10-block-agc" = {
          "pulse.rules" = [
            {
              matches = [
                { "application.process.binary" = "~.*"; }
              ];
              actions = {
                quirks = [ "block-source-volume" ];
              };
            }
          ];
        };
      };
    };
  };

  users = {
    groups.libvirtd.members = [ "artem" ];
    defaultUserShell = pkgs.zsh;
    users.artem = {
      isNormalUser = true;
      description = "Artem";
      extraGroups = [ "networkmanager" "wheel" "ydotool" "libvirtd" "kvm" ];
    };
  };

  fonts.packages = [
    pkgs.google-fonts
  ];

  qt.enable = true;

  environment = {
    etc = {
      "strongswan.conf".text = ''
        charon {
          filelog {
            charon {
              path = /var/log/charon.log
              default = 2
            }
          }
        }
      '';

      "ipsec.secrets".text = ''
      '';
    };

    variables = {
      QML2_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml";
    };

    sessionVariables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      LIBVA_DRIVER_NAME = "iHD";
      NIXOS_OZONE_WL = "1";
    };

    shells = [ pkgs.zsh ];
    systemPackages = with pkgs; [
      (python313.withPackages (ps: with ps; [ dbus-next ]))
      intel-compute-runtime
      brightnessctl
      expect
      pinentry-qt
      pavucontrol
      nettools
      glib
      lsof
      unzip
      gcc_multi
      libxml2
      wl-clip-persist
      git
      udiskie
      imagemagick
      cargo
      libnotify
      networkmanagerapplet
      sddm-astronaut
      cachix
      kitty
      ripgrep
      fd
      qtcreator
      inputs.matugen.packages.${system}.default
      virt-viewer
    ];
    pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
  };

  system.stateVersion = "25.05";

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.extraConfig = ''
      Defaults pwfeedback
      Defaults timestamp_timeout = 300
    '';
    pam.services = {
      sddm = {
        gnupg = {
          enable = true;
          storeOnly = true;
        };
        enableGnomeKeyring = true;
      };
      sddm-greeter = {
        gnupg = {
          enable = true;
          storeOnly = true;
        };
        enableGnomeKeyring = true;
      };
      login = {
        gnupg = {
          enable = true;
          storeOnly = true;
        };
        failDelay = {
          enable = true;
          delay = 1000000;
        };
        enableGnomeKeyring = true;
      };
    };
  };

  systemd.services = {
    snx-rs = {
      description = "SNX-RS Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.snx-rs}/bin/snx-rs -m command";
        User = "root";
        Restart = "on-failure";
      };
      path = [pkgs.iproute2 pkgs.kmod];
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    nodejs_20
    brotli
    unixodbc
    zstd
    glib
    stdenv.cc.cc
  ];
}
