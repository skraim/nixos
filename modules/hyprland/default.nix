{ pkgs, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
    "hypr/plugins.conf".text = ''
      exec-once = hyprctl plugin load ${inputs.hyprland-plugins.packages.${pkgs.system}.hyprscrolling}/lib/libhyprscrolling.so
      exec-once = hyprctl plugin load ${inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo}/lib/libhyprexpo.so
  '';
  };
}
