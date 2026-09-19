{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "undocked";
          outputs =  [
            {
              criteria = "eDP-1";
            }
          ];
          exec = [ "hyprctl keyword monitor \"eDP-1,1920x1200,0x0,1\"" ];
        };
      }
      {
        profile = {
          name = "docked";
          outputs = [
            {
              criteria = "eDP-1";
            }
            {
              criteria = "*";
            }
          ];
          exec = [
            ''
              bash -c '
                line=$(awww query | grep -m1 "eDP-1")
                path=''${line##*image:}
                hyprctl keyword monitor "eDP-1,1920x1200,0x0,1.2"
                [ "$path" != "$line" ] && [ -n "$path" ] && awww img "''${path# }"
              '
            ''
          ];
        };
      }
    ];
  };
}
