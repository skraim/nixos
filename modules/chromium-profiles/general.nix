{ pkgs, ... }:

pkgs.makeDesktopItem {
  name = "chromium-general";
  desktopName = "Chromium (General)";
  exec = "chromium --profile-directory=\"Default\"";
  icon = "chromium";
  categories = [ "Network" "WebBrowser" ];
}
