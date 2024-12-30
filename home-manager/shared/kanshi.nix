{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "left-display-port";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "DP-3";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "hdmi";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
            scale = 0.8;
          }
        ];
      }
    ];
    systemdTarget = "graphical-session.target";
  };
}

/*

  profile undocked {
  output eDP-1 enable
  }
  profile dpl {
  output eDP-1 disable
  output DP-3 enable
  }
  profile hdmi {
  output eDP-1 disable
  output HDMI-A-1 enable scale 0.8
  }

*/
