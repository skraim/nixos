{ pkgs, ... }:

{
  programs.pywal = {
    enable = true;
    package = pkgs.pywal16;
  };

  xdg.configFile."wal/templates/" = {
    source = ./templates;
    recursive = true;
  };
}
