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
        profile.name = "home-innocn";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "Beihai Century Joint Innovation Technology Co.,Ltd 40C1R 0000000000000";
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
        profile.name = "home-hdmi";
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
  output "eDP-1" enable
  }

  profile home-innocn {
  output "eDP-1" disable
  output "Beihai Century Joint Innovation Technology Co.,Ltd 40C1R 0000000000000" enable
  }

  profile hdmi-bitlab {
  output "eDP-1" disable
  output "LG Electronics LG ULTRAGEAR 0x0004C6F2" enable scale 0.800000
  }

  profile home-hdmi {
  output "eDP-1" enable scale 1.000000
  output "Philips Consumer Electronics Company PHL 273V7 UHB1915002425" enable scale 0.800000
  }

*/
