{
  services.kanshi = {
    enable = true;
    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
          }
        ];
      };
      docked = {
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
    };
  };
}
