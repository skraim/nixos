{ pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
  };

  home.packages = with pkgs; [
    hypridle
    hyprsunset
    hyprland-per-window-layout
  ];

  services.hyprpolkitagent.enable = true;

  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hyprland.conf;
    "hypr/hypridle.conf".source = ./hypridle.conf;
    "hypr/hyprsunset.conf".source = ./hyprsunset.conf;
  };
}
