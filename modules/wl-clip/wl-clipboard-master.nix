{ config, lib, pkgs, ... }:
with lib;
let
  wl-clipboard-master = pkgs.stdenv.mkDerivation rec {
    pname = "wl-clipboard";
    version = "master";

    src = pkgs.fetchFromGitHub {
      owner = "bugaevc";
      repo = "wl-clipboard";
      rev = "master";
      hash = "sha256-sR/P+urw3LwAxwjckJP3tFeUfg5Axni+Z+F3mcEqznw=";
    };

    strictDeps = true;

    nativeBuildInputs = with pkgs; [
      meson
      ninja
      pkg-config
      wayland-scanner
    ];

    buildInputs = with pkgs; [
      wayland
      wayland-protocols
    ];

    propagatedBuildInputs = with pkgs; [
      xdg-utils
      mailcap
    ];

    mesonFlags = [
      "-Dfishcompletiondir=${placeholder "out"}/share/fish/vendor_completions.d"
      "-Dzshcompletiondir=${placeholder "out"}/share/zsh/site-functions"
    ];

    meta = with lib; {
      homepage = "https://github.com/bugaevc/wl-clipboard";
      description = "Command-line copy/paste utilities for Wayland (master branch)";
      longDescription = ''
        wl-clipboard implements two command-line Wayland clipboard utilities,
        wl-copy and wl-paste, that let you easily copy data between the
        clipboard and Unix pipes, sockets, files and so on.

        This package builds from the master branch for the latest features.
      '';
      license = licenses.gpl3Plus;
      maintainers = [ ];
      platforms = platforms.linux;
      mainProgram = "wl-copy";
    };
  };

in {
  options = {
    programs.wl-clipboard-master = {
      enable = mkEnableOption "wl-clipboard from master branch";

      package = mkOption {
        type = types.package;
        default = wl-clipboard-master;
        defaultText = literalExpression "wl-clipboard-master";
        description = ''
          The wl-clipboard package to use. By default, this builds from the
          master branch of the upstream repository.
        '';
      };
    };
  };

  config = mkIf config.programs.wl-clipboard-master.enable {
    environment.systemPackages = [ config.programs.wl-clipboard-master.package ];
    environment.pathsToLink = [
      "/share/fish"
      "/share/zsh"
    ];
  };
}
