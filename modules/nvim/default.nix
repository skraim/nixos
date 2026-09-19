{ config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  xdg.configFile = {
    "nvim/after" = {
      source = ./nvim/after;
      recursive = true;
    };
    "nvim/lua" = {
      source = ./nvim/lua;
      recursive = true;
    };
    "nvim/plugin" = {
      source = ./nvim/plugin;
      recursive = true;
    };
    "nvim/init.lua" = {
      source = ./nvim/init.lua;
    };
    "nvim/nvim-pack-lock.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/modules/nvim/nvim/nvim-pack-lock.json";
    };
  };
}
