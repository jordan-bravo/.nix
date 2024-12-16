{
  programs.i3status-rust = {
    bars.default = {
      blocks = [
        {
          block = "battery";
        }
        {
          alert = 10.0;
          block = "disk_space";
          info_type = "available";
          interval = 60;
          path = "/";
          warning = 20.0;
        }
        # {
        #   block = "memory";
        #   format = " $icon mem_used_percents ";
        #   format_alt = " $icon $swap_used_percents ";
        # }
        {
          block = "cpu";
          interval = 1;
        }
        {
          block = "load";
          format = " $icon $1m ";
          interval = 1;
        }
        {
          block = "sound";
        }
        {
          block = "time";
          format = " $timestamp.datetime(f:'%a %d/%m %R') ";
          interval = 60;
        }
      ];
    };
  };
}
