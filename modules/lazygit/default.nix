{ pkgs, lib, config, ... }:

{
  programs.lazygit.enable = true;
  home.file."${config.xdg.configHome}/lazygit/config.yml" = {
    enable = lib.mkForce true;
    source = lib.mkForce ./config.yml;
  };
}
