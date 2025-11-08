{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
  };

  home.packages = with pkgs; [
    hyprpaper
    hypridle
    hyprsunset
    hyprland-per-window-layout
  ];

  services.hyprpolkitagent.enable = true;

  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hyprland.conf;
    "hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    "hypr/hypridle.conf".source = ./hypridle.conf;
    "hypr/hyprsunset.conf".source = ./hyprsunset.conf;
  };
}
