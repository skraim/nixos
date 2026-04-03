{ pkgs, ... }:

let
  arubaVia = pkgs.callPackage ./via.nix {
  };
in {

  home.packages = [ arubaVia ];

  xdg.desktopEntries."aruba-via-ui" = {
    name = "Aruba VIA";
    exec = "aruba-via-ui";
    terminal = false;
    icon = "via";
    categories = [ "Network" "GTK" ];
  };
}
