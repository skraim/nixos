{inputs, pkgs, ...}:
{
  imports = [
    inputs.matugen.nixosModules.default
  ];

  home.packages = with pkgs; [
    inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  programs.matugen = {
    enable = true;
    variant = "dark";
    jsonFormat = "hex";
    wallpaper = "~/Pictures/wallpapers/wp14410094.jpg";
  };
  home.file.".config/matugen/config.toml".text = ''
    [config]

    [templates.hypr]
      input_path = '${./templates/hyprland-colors.conf}'
      output_path = '~/.config/hypr/colors.conf'
    [templates.kitty]
      input_path = '${./templates/kitty-colors.conf}'
      output_path = '~/.config/kitty/themes/Matugen.conf'
      post_hook = 'pkill -SIGUSR1 kitty'
    [templates.quickshell]
      input_path = '${./templates/quickshell-colors.json}'
      output_path = '~/.cache/quickshell/colors.json'
    [templates.tmux]
      input_path = '${./templates/tmux-colors.conf}'
      output_path = '~/.config/tmux/colors.conf'
    [templates.yazi]
      input_path = '${./templates/yazi-theme.toml}'
      output_path = '~/.config/yazi/theme.toml'
  '';

  home.file."matugen/templates" = {
    source = ./templates;
    target = "~/.config/matugen/templates";
    recursive = true;
  };

  # gtk = {
  #   enable = true;
  #   gtk4.extraCss = "@import url(\"${config.programs.matugen.theme.files}/.config/gtk-4.0/gtk.css\");";
  #   gtk3.extraCss = "@import url(\"${config.programs.matugen.theme.files}/.config/gtk-3.0/gtk.css\");";
  # };
}
