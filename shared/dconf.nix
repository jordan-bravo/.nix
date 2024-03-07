# ~/.nix/shared/dconf.nix
{ lib, ... }:

with lib.hm.gvariant;
{
  
  dconf.settings = {
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:escape_shifted_capslock" ];
    };
    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      cursor-theme = "Adwaita";
      gtk-theme = "Adwaita";
      icon-theme = "Adwaita";
      show-battery-percentage = true;
    };
    "org/gnome/desktop/notifications" = {
      show-banners = false;
      show-in-lock-screen = false;
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
      speed = -0.33;
    };
    "org/gnome/desktop/privacy" = {
      remove-old-trash-files = true;
    };
    "org/gnome/desktop/screensaver" = {
      lock-delay = mkUint32 30;
      lock-enabled = true;
    };
    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 2400; # The number of seconds of inactivity before the session is considered idle.
    };
    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };
    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-1 = [ "<Shift><Alt>1" ];
      move-to-workspace-2 = [ "<Shift><Alt>2" ];
      move-to-workspace-3 = [ "<Shift><Alt>3" ];
      move-to-workspace-4 = [ "<Shift><Alt>4" ];
      switch-to-workspace-1 = [ "<Alt>1" ];
      switch-to-workspace-2 = [ "<Alt>2" ];
      switch-to-workspace-3 = [ "<Alt>3" ];
      switch-to-workspace-4 = [ "<Alt>4" ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize,maximize:appmenu";
      dynamic-workspaces = false;
      num-workspaces = 6;
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      workspaces-only-on-primary = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Alt>5";
      command = "dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-5 \"['<Alt>5']\"";
      name = "Switch to workspace 5";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Shift><Alt>5";
      command = "dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-5 \"['<Shift><Alt>5']\"";
      name = "Move to workspace 5";
    };
    # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
    #   binding = "<Alt>6";
    #   command = "dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-6 \"['<Alt>6']\"";
    #   name = "Switch to workspace 6";
    # };
    # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
    #   binding = "<Shift><Alt>6";
    #   command = "dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-6 \"['<Shift><Alt>6']\"";
    #   name = "Move to workspace 6";
    # };
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      power-saver-profile-on-low-battery = true;
      sleep-inactive-ac-timeout = 7200; # The amount of time in seconds the computer on AC power needs to be inactive before it goes to sleep. A value of 0 means never.
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = 1200;
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
        "forge@jmmaranan.com" # Window tiler for Gnome
        "gsconnect@andyholmes.github.io"
        "just-perfection-desktop@just-perfection"
        "nextcloud-folder@cosinus.org"
        "space-bar@luchrioh"
        # "unblank@sun.wxg@gmail.com" # unblank breaks some keybindings
        # "Vitals@CoreCoding.com"
      ];
      favorite-apps = [
        "brave-browser.desktop"
        "librewolf.desktop"
        "thunderbird.desktop"
        "firefox.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Nautilus.desktop"
        "kitty.desktop"
        "md.obsidian.Obsidian.desktop"
        "org.telegram.desktop.desktop"
        "signal-desktop.desktop"
        "element-desktop.desktop"
        "slack.desktop"
        "vlc.desktop"
        "freetube.desktop"
        "sparrow-desktop.desktop"
        "org.gnome.Settings.desktop"
        "org.gnome.tweaks.desktop"
        "com.mattjakeman.ExtensionManager.desktop"
      ];
      last-selected-power-profile = "performance";
    };
    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [
        # "firefox.desktop:1"
        "kitty.desktop:2"
        # "signal-desktop.desktop:3"
        "slack.desktop:3"
        "thunderbird.desktop:3"
        "obsidian.desktop:4"
        # "sparrow-desktop.desktop:5"
      ];
      extend-height = true;
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "LEFT";
      extend-height = true;
      intellihide-mode = "ALL_WINDOWS"; # FOCUS_APPLICATION_WINDOWS
      show-dock-urgent-notify = false;
    };
    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
    };
    "org/gnome/shell/extensions/unblank" = {
      time = 1800;
    };
    "org/gnome/shell/keybindings" = {
      toggle-overview = [ "<Super>space" ];
    };
    "org/gtk/settings/file-chooser" = {
      clock-format = "24h";
      extend-height = true;
    };
  };
}
