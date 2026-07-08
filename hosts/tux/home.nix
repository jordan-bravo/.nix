{ pkgs, ... }:
{
  imports = [
    ../../modules/home-manager/hm-all.nix
    ../../modules/home-manager/hm-workstation.nix
  ];

  services.trayscale.enable = true;

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
  xdg.dataFile = {
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
