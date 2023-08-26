{
  programs.kitty = {
    enable = true;
    font = {
      name = "Fira Code";
      size = 14;
    };
    keybindings = {
      "kitty_mod+u" = "scroll_page_up";
      "cmd+shift+u" = "scroll_page_up";

      "kitty_mod+d" = "scroll_page_down";
      "cmd+shift+d" = "scroll_page_down";

      "kitty_mod+o" = "scroll_page_down";
      "cmd+shif+o" = "scroll_page_down";

      "kitty_mod+;" = "goto_layout stack";
      "cmd+shift+;" = "goto_layout stack";

      "kitty_mod+i" = "goto_layout horizontal";
      "cmd+shift+i" = "goto_layout horizontal";

      "kitty_mod+\\" = "goto_layout vertical";
      "cmd+shift+\\" = "goto_layout vertical";

      "kitty_mod+y" = "goto_layout grid";
      "cmd+shift+y" = "goto_layout grid";

      "kitty_mod+space" = "toggle_layout stack";
      "cmd+shift+space" = "toggle_layout stack";

      "kitty_mod+enter" = "launch --cwd=current";
      "cmd+shift+enter" = "launch --cwd=current";

      "kitty_mod+t" = "launch --type=tab --cwd=current";
      "cmd+shift+t" = "launch --type=tab --cwd=current";

      "kitty_mod+]" = "next_window";
      "cmd+shift+]" = "next_window";

      "kitty_mod+[" = "previous_window";
      "cmd+shift+[" = "previous_window";

      "kitty_mod+m" = "next_tab";
      "cmd+shift+m" = "next_tab";

      "kitty_mod+n" = "previous_tab";
      "cmd+shift+n" = "previous_tab";

      "kitty_mod+w" = "close_window";
      "cmd+shift+w" = "close_window";

      "kitty_mod+c" = "copy_to_clipboard";
      "cmd+shift+c" = "copy_to_clipboard";

      "kitty_mod+v" = "paste_from_clipboard";
      "cmd+shift+v" = "paste_from_clipboard";
    };
    settings = {
      enable_audio_bell = false;
      enabled_layouts = "horizontal, stack, vertical, grid";
      hide_window_decorations = "titlebar-only"; # options: true, "titlebar-only", "titlebar-and-corners"
      # kitty_mod = "ctrl+shift";
      # startup_session = ./session.conf;
      macos_option_as_alt = "both";
      window_alert_on_bell = false;
    };
    shellIntegration.enableZshIntegration = true;
    # theme = "Adwaita dark";
  };
}
