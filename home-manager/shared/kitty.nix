# home-manager/shared/kitty.nix
{
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 11;
    };
    shellIntegration.enableZshIntegration = true;
    settings = {
      dynamic_background_opacity = "yes";
      enable_audio_bell = false;
      enabled_layouts = "horizontal, stack, vertical, grid";
      hide_window_decorations = "titlebar-only"; # options: true, "titlebar-only", "titlebar-and-corners"
      # startup_session = "./kitty-session.conf";
      macos_option_as_alt = "both";
      scrollback_lines = 10000;
      wayland_titlebar_color = "#3b3b3b"; # options: "background", "system", "gray", "#3b3b3b"
      window_alert_on_bell = false;
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
      "kitty_mod+]" = "next_window";
      "kitty_mod+[" = "previous_window";
      "kitty_mod+m" = "next_tab";
      "kitty_mod+n" = "previous_tab";
      "kitty_mod+w" = "close_window";
      "kitty_mod+c" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";
      "kitty_mod+1" = "goto_tab 1";
      "kitty_mod+2" = "goto_tab 2";
      "kitty_mod+3" = "goto_tab 3";
      "kitty_mod+4" = "goto_tab 4";
      "kitty_mod+5" = "goto_tab 5";
      "kitty_mod+6" = "goto_tab 6";
      "kitty_mod+7" = "goto_tab 7";
      # unmap by setting to blank
      "ctrl+tab" = "";
      "ctrl+shift+tab" = "";
    };
    theme = "VSCode_Dark";
  };
}
