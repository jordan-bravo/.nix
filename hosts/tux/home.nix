{ pkgs, ... }:
{
  imports = [
    ../../modules/home-manager/hm-all.nix
    ../../modules/home-manager/hm-workstation.nix
    ../../modules/home-manager/dconf.nix
    ../../modules/home-manager/maple.nix
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

  xdg.dataFile = {
    # GNOME Specific:
    # The following disables the notification sound that plays in GNOME when
    # a charging cable is plugged in or unplugged.
    # Sound theme that inherits everything from the default but disables the
    # charger plug/unplug sounds (a "<name>.disabled" file mutes that event).
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

  ### Idle-suspend on AC: a lid-independent safety net.
  #
  # tux's lid is unreliable at the *firmware* level. \_SB.LID1._LID does not
  # query hardware - it is `Return (LIDS)`, a cached AML variable written only
  # by the EC query handlers _Q16 (open) / _Q19 (closed) and by _WAK on resume.
  # When the EC drops the _Q19 dispatch for a lid close, LIDS keeps its old
  # value, so the SW_LID event, _LID, and /proc/acpi/button/lid/*/state all go
  # stale together and report "open" for as long as the lid stays shut. Opening
  # the lid makes the stale value accidentally correct again, so each lid close
  # is an independent coin flip and the fault leaves no trace afterwards.
  #
  # That is why logind's lid handling and ../../hosts/tux/lid-watchdog.nix do
  # not fail independently - both hang off _Q19, so they go blind together. On
  # 2026-09-01 the lid shut at 13:48:47 and the machine ran awake on AC for
  # 7h33m; the watchdog polled 278 times and read "open" every time. The one
  # firmware resync path, _WAK, only runs on resume from S3/S4 and this machine
  # is forced onto s2idle - so it must suspend to fix its lid state and cannot
  # suspend because its lid state is broken. See
  # ../../docs/tux-lid-acpi-q15-firmware-bug.md.
  #
  # Idle-suspend is the only backstop that survives this, because it never
  # consults lid state: gsd-power reads mutter's idle monitor directly. The
  # battery half already works (it fired at 11:49 on 2026-09-01), but AC was
  # left at "nothing"/7200 by an older revision of
  # ../../modules/home-manager/dconf.nix, where these keys are now commented
  # out - and both bad events (2026-08-19, 2026-09-01) happened on AC.
  #
  # logind's own IdleAction= is NOT a substitute: GNOME only reports a session
  # idle to logind when the screensaver engages, and idle-delay is 0 ("never
  # blank"), so logind's IdleHint never flips. Verified on 2026-09-01 -
  # IdleSinceHint sat unchanged at 11:52:54 through the entire 7.5h window.
  #
  # Both keys are int32 in the schema, so plain integers are correct here
  # (contrast org/gnome/desktop/session idle-delay, which needs mkUint32).
  dconf.settings."org/gnome/settings-daemon/plugins/power" = {
    sleep-inactive-ac-type = "suspend";
    sleep-inactive-ac-timeout = 1200; # 20 min
  };
}
