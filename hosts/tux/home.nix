{ pkgs, ... }:
{
  imports = [
    ../../modules/home-manager/hm-all.nix
    ../../modules/home-manager/hm-workstation.nix
    ../../modules/home-manager/dconf.nix
  ];

  services.trayscale.enable = true;

  # Flatpak apps for this host (shared flatpak config lives in
  # modules/home-manager/flatpak.nix; apps are declared per host).
  services.flatpak.packages = [
    "app.grayjay.Grayjay"
    "com.brave.Browser"
    "com.github.PintaProject.Pinta"
    "com.github.tchx84.Flatseal"
    "com.mattjakeman.ExtensionManager"
    "com.tdameritrade.ThinkOrSwim"
    "md.obsidian.Obsidian"
    "org.asamk.SignalCli"
    "org.cubocore.CoreRenamer"
    "org.fedoraproject.MediaWriter"
    "org.gajim.Gajim"
    "org.gnome.Calculator"
    "org.kde.krename"
    "org.libreoffice.LibreOffice"
    "org.mozilla.firefox"
    "org.mozilla.thunderbird_esr"
    "org.onlyoffice.desktopeditors"
    "org.qbittorrent.qBittorrent"
    "org.signal.Signal"
    "org.torproject.torbrowser-launcher"
    "org.videolan.VLC"
  ];

  # The AppIndicator GNOME extension spawns `gjs` from PATH to re-discover
  # existing tray icons whenever the extension re-enables (e.g. after screen
  # unlock). Without gjs in PATH, already-running tray apps like trayscale
  # lose their icon after every lock/unlock.
  home.packages = [
    pkgs.gjs
    pkgs.gnomeExtensions.appindicator
  ];

  # GNOME Specific:
  # The following disables the notification sound that plays in GNOME when
  # a charging cable is plugged in or unplugged.
  # Sound theme that inherits everything from the default but disables the
  # charger plug/unplug sounds (a "<name>.disabled" file mutes that event).
  # The Buzz AppImage's WebKit does not pass GST_PLUGIN_SYSTEM_PATH_1_0 down to
  # its WebKitWebProcess, so GStreamer there falls back to its built-in search
  # paths and sees only the core plugins. Missing appsink/appsrc/autoaudiosink
  # makes the web process abort, and the Buzz window vanishes on launch.
  # ~/.local/share/gstreamer-1.0/plugins is one of those fallback paths and
  # needs no environment variable, so populating it fixes the crash.
  xdg.dataFile = {
    "gstreamer-1.0/plugins".source =
      "${
        pkgs.symlinkJoin {
          name = "appimage-gst-plugins";
          paths = with pkgs.gst_all_1; [
            gst-plugins-base # appsink, appsrc
            gst-plugins-good # autoaudiosink
            gst-plugins-bad
            gst-libav # decoders for decodebin
            pkgs.pipewire # pipewiresink
          ];
        }
      }/lib/gstreamer-1.0";

    "sounds/__custom/index.theme".text = ''
      [Sound Theme]
      Name=Custom
      Inherits=freedesktop
      Directories=.
    '';
    "sounds/__custom/power-plug.disabled".text = "";
    "sounds/__custom/power-unplug.disabled".text = "";
  };

  dconf.settings."org/gnome/desktop/sound".theme-name = "__custom";
}
