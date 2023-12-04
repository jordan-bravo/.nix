# ~/.nix/shared/dconf.nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      # text-scaling-factor = 1.0; # BitLab LG
      text-scaling-factor = 1.25; # Home Innocn
    };
    "org/gnome/desktop/notifications" = {
      show-banners = false;
      show-in-lock-screen = false;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.30;
      tap-to-click = true;
    };
    "org/gnome/desktop/privacy" = {
      remove-old-trash-files = true;
    };
    "org/gnome/desktop/screensaver" = {
      lock-delay = mkUint32 30;
      lock-enabled = true;
    };
    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 600;
    };
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
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
      num-workspaces = 5;
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      workspaces-only-on-primary = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" ];
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
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      power-saver-profile-on-low-battery = true;
      sleep-inactive-ac-timeout = 7200;
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = 1200;
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
        "gsconnect@andyholmes.github.io"
        "just-perfection-desktop@just-perfection"
        "nextcloud-folder@cosinus.org"
        "space-bar@luchrioh"
        # "unblank@sun.wxg@gmail.com" # unblank breaks some keybindings
        # "Vitals@CoreCoding.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "brave-browser.desktop"
        "org.gnome.Evolution.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Nautilus.desktop"
        "kitty.desktop"
        "obsidian.desktop"
        "org.telegram.desktop.desktop"
        "signal-desktop.desktop"
        "element-desktop.desktop"
        "vlc.desktop"
        "sparrow-desktop.desktop"
        "org.gnome.Settings.desktop"
        "org.gnome.tweaks.desktop"
        "com.mattjakeman.ExtensionManager.desktop"
      ];
    };
    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [
        "firefox.desktop:1"
        "kitty.desktop:2"
        "signal-desktop.desktop:3"
        "org.gnome.Evolution.desktop:3"
        "obsidian.desktop:4"
        "sparrow-desktop.desktop:5"
      ];
      extend-height = true;
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "LEFT";
      extend-height = true;
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
