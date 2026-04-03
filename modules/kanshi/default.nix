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
          exec = [ "$HOME/scripts/post-pywal.sh" ];
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
          exec = [ "$HOME/scripts/post-pywal.sh" ];
        };
      }
    ];
  };
}
