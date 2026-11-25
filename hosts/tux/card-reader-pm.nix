{ pkgs, ... }:

### Built-in SD card reader: off at boot to save battery.
#
#   sdcard        show on/off
#   sdcard on     enable the reader, then insert the card
#   sdcard off    disable it again (rebooting also does)
#
# Why: the reader (Realtek 0bda:0316) never slept, which kept the USB
# controller awake and the CPU package out of deep idle (no PC10).
# Disabling it cut draw from ~12-14 W to ~11 W (measured 2026-11-22).
#
# While on, the power rules below let it sleep between 10 s media polls.
# Keep the disable rule ACTION=="add" only; "change" would undo `sdcard on`.
let
  sdcard = pkgs.writeShellScriptBin "sdcard" ''
    set -eu
    dev=
    for d in /sys/bus/usb/devices/*; do
      if [ "$(cat "$d/idVendor" 2>/dev/null)" = 0bda ] &&
         [ "$(cat "$d/idProduct" 2>/dev/null)" = 0316 ]; then
        dev=$d
        break
      fi
    done
    [ -n "$dev" ] || { echo "sdcard: card reader (0bda:0316) not found" >&2; exit 1; }
    case "''${1:-}" in
      on)  echo 1 | sudo tee "$dev/authorized" >/dev/null; echo "SD card reader on" ;;
      off) echo 0 | sudo tee "$dev/authorized" >/dev/null; echo "SD card reader off" ;;
      "")  [ "$(cat "$dev/authorized")" = 1 ] && echo on || echo off ;;
      *)   echo "usage: sdcard [on|off]" >&2; exit 2 ;;
    esac
  '';
in
{
  environment.systemPackages = [ sdcard ];

  services.udev.extraRules = ''
    # USB card reader: disconnect at boot (re-enable with `sdcard on`)
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="0316", ATTR{authorized}="0"
    # USB card reader: allow autosuspend
    ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="0316", ATTR{power/control}="auto"
    # Its SCSI disk: allow autosuspend after 1 s idle (default -1 = never)
    ACTION=="add|change", SUBSYSTEM=="scsi", ENV{DEVTYPE}=="scsi_device", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="0316", ATTR{power/control}="auto", ATTR{power/autosuspend_delay_ms}="1000"
    # Its block device: poll for media every 10 s instead of every 2 s
    ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sd*", ENV{DEVTYPE}=="disk", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="0316", ATTR{events_poll_msecs}="10000"
  '';
}
