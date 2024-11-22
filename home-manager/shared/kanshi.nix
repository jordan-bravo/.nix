{
  services.kanshi = {
    enable = true;
    extraConfig = ''
      profile undocked {
          output eDP-1 enable
      }
      profile docked {
          output eDP-1 disable
          output DP-3 enable
      }
    '';
    systemdTarget = "graphical-session.target";
  };
}
