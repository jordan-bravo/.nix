{
  services.kanshi = {
    enable = true;
    extraConfig = ''
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
    '';
    systemdTarget = "graphical-session.target";
  };
}
