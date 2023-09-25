# ~/.nix/shared/kitty.nix
{
  programs.kitty = {
    enable = true;
    font = {
      # name = "Fira Code";
      name = "FiraCode Nerd Font Mono";
      size = 14;
    };
    shellIntegration.enableZshIntegration = true;
    settings = {
      enable_audio_bell = false;
      enabled_layouts = "horizontal, stack, vertical, grid";
      hide_window_decorations = "titlebar-only"; # options: true, "titlebar-only", "titlebar-and-corners"
      # startup_session = ./session.conf;
      macos_option_as_alt = "both";
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
    };
    theme = "VSCode_Dark";
  };
}
