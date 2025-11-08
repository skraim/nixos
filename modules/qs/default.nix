{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    (inputs.quickshell.packages.${pkgs.system}.default.withModules [
      qt6.qt5compat
      qt6.qtquick3d
      qt6.qtwayland
      qt6.qtdeclarative
      qt6.qtsvg
    ])
  ];

  # xdg.configFile."quickshell/" = {
  #   source = ./quickshell;
  #   recursive = true;
  # };
}
