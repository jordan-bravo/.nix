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
        profile.name = "left-display-port-8";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "DP-8";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "left-display-port-9";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "DP-9";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "right-display-port";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "DP-1";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "hdmi-bitlab";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "LG Electronics LG ULTRAGEAR 0x0004C6F2";
            status = "enable";
            scale = 0.8;
          }
        ];
      }
      {
        profile.name = "hdmi-home";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.0;
          }
          {
            criteria = "Philips Consumer Electronics Company PHL 273V7 UHB1915002425";
            status = "enable";
            scale = 0.8;
          }
        ];
      }
    ];
    # Post about kanshi systemd user service not starting with sway:
    # https://discourse.nixos.org/t/starting-kanshi-via-systemd-user-swaywm/27960/2
    # The posted solution is to set systemdTarget to an empty string.
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
