# ~/.nix/shared/dconf.nix
{ lib, ... }:

with lib.hm.gvariant;
{
  dconf.enable = true;
  dconf.settings = {
    #     "org/gnome/desktop/interface" = {
    #       # text-scaling-factor = 0.8; # BitLab LG
    #       # text-scaling-factor = 1.0; # Normal scaling
    #       # text-scaling-factor = 1.25; # Home Innocn
    #       # text-scaling-factor = 1.45; # tux built-in
    #       # text-scaling-factor = 1.75; # Larger
    #       text-scaling-factor = 2.0; # Double
    #     };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:escape_shifted_capslock" ];
    };
    "org/gnome/desktop/interface" = {
      clock-format = "24h";
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
      # speed = -0.8;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      # speed = 0.25;
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
      # allow-volume-above-100-percent = true;
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = [ ];
      minimize = [ ];
      move-to-workspace-1 = [ "<Shift><Alt>1" ];
      move-to-workspace-2 = [ "<Shift><Alt>2" ];
      move-to-workspace-3 = [ "<Shift><Alt>3" ];
      move-to-workspace-4 = [ "<Shift><Alt>4" ];
      move-to-workspace-5 = [ "<Shift><Alt>5" ];
      move-to-workspace-6 = [ "<Shift><Alt>6" ];
      switch-to-workspace-1 = [ "<Alt>1" ];
      switch-to-workspace-2 = [ "<Alt>2" ];
      switch-to-workspace-3 = [ "<Alt>3" ];
      switch-to-workspace-4 = [ "<Alt>4" ];
      switch-to-workspace-5 = [ "<Alt>5" ];
      switch-to-workspace-6 = [ "<Alt>6" ];
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
    # Example syntax for GHOME custom keybindings
    # "org/gnome/settings-daemon/plugins/media-keys" = {
    #   custom-keybindings = [
    #     "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
    #   ];
    # };
    # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
    #   binding = "<Alt><Ctrl>0";
    #   command = "gnome-sessing-quit";
    #   name = "Log Out Of GNOME";
    # };
    # "org/virt-manager/virt-manager/connections" = {
    #   autoconnect = [ "qemu:///system" ];
    #   uris = [ "qemu:///system" ];
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
        "Bluetooth-Battery-Meter@maniacx.github.com"
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
        # "obsidian.desktop:4"
        # "sparrow-desktop.desktop:5"
      ];
      extend-height = true;
    };
    "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
      enable-battery-indicator = false;
      enable-battery-level-icon = false;
      enable-battery-level-text = true;
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
      toggle-overview = [ "<Alt>r" ];
    };
    "org/gtk/settings/file-chooser" = {
      clock-format = "24h";
      extend-height = true;
    };
  };
}
