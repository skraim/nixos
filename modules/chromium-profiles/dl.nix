{ pkgs, ... }:

pkgs.makeDesktopItem {
  name = "chromium-dl";
  desktopName = "Chromium (DL)";
  exec = "chromium --profile-directory=\"Profile 1\"";
  icon = "chromium";
  categories = [ "Network" "WebBrowser" ];
}
