{
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCodeNerdFont";
      size = 16;
    };
    shellIntegration.enableZshIntegration = true;
    settings = {
      dynamic_background_opacity = "yes"; # Ctrl+Shift+A, l/m
      enable_audio_bell = false;
      hide_window_decorations = true; # options: true, "titlebar-only", "titlebar-and-corners"
      # startup_session = "./kitty-session.conf";
      scrollback_lines = 50000;
      # wayland_titlebar_color = "red"; # options: "background", "system", "gray", "#3b3b3b"
      window_alert_on_bell = false;
    };
    themeFile = "VSCode_Dark";
  };
}
