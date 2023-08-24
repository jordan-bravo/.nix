{
  programs.kitty = {
    enable = true;
    font = {
      name = "Fira Code";
      size = 14;
    };
    keybindings = {
      "kitty_mod+u" = "scroll_page_up";
      "kitty_mod+d" = "scroll_page_down";
      "kitty_mod+o" = "scroll_page_down";
      "kitty_mod+;" = "goto_layout stack";
      "kitty_mod+i" = "goto_layout horizontal";
      "kitty_mod+\\" = "goto_layout vertical";
      "kitty_mod+y" = "goto_layout grid";
      "kitty_mod+space" = "toggle_layout stack";
      "kitty_mod+enter" = "launch --cwd=current";
      "kitty_mod+t" = "launch --type=tab --cwd=current";
    };
    settings = {
      enable_audio_bell = false;
      enabled_layouts = "horizontal, stack, vertical, grid";
      hide_window_decorations = true; # also: "titlebar-only" or "titlebar-and-corners"
      # kitty_mod = "ctrl+shift";
      # startup_session = ./session.conf;
      macos_option_as_alt = "both";
      window_alert_on_bell = false;
    };
    shellIntegration.enableZshIntegration = true;
    # theme = "Adwaita dark";
  };
}
