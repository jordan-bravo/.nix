{ lib, pkgs, ... }:

### Lid watchdog: catch lid closes that the firmware never reported.
#
# Background. On this machine `\_SB.LID1._LID` does not query hardware - the
# DSDT defines it as:
#
#     Name (LIDS, One)
#     Method (_LID, 0, NotSerialized) { Return (LIDS) }
#
# `LIDS` has exactly three writers: the EC query handlers `_Q16` (lid opened,
# sets One) and `_Q19` (lid closed, sets Zero), and `RWAK` (`_WAK`) which
# resyncs from the live EC bit on resume from S3/S4.
#
# When the EC fails to dispatch `_Q19` on a lid close - which it does
# intermittently - `LIDS` keeps its old value. The `Notify(LID1, 0x80)` that
# would raise SW_LID never happens, `_LID` keeps answering "open", and
# /proc/acpi/button/lid/*/state answers "open" with it. logind and any poller of
# /proc are therefore NOT independent channels: they are the same channel, and
# they go blind together. On 2026-09-01 the lid shut at 13:48:47 and this
# machine ran awake on AC for 7h33m while an earlier version of this watchdog
# polled /proc 278 times and read "open" every single time.
#
# `RWAK` would fix it, but only runs on resume from S3/S4, and this machine is
# restricted to s2idle because S3 resume hangs the firmware. Under s2idle `_WAK`
# is never evaluated. So the machine would have to suspend to correct its lid
# state, and it will not suspend because its lid state is wrong.
#
# This therefore reads the EC's own lid bit directly, which is the source `RWAK`
# itself trusts. Verified 2026-09-01 22:28: with the lid shut for 28 s, the EC
# bit read "closed" while `_LID` read "open" and logind logged no lid event at
# all. See ../../docs/tux-lid-acpi-q15-firmware-bug.md.
#
# It is NOT an idle timer - it never looks at user activity, so it will not
# suspend a machine being actively used in clamshell. It only asks whether the
# lid is shut with nothing but the (disabled) internal panel attached, which is
# a state in which no display can be showing anything to anyone.
#
# The lid-independent backstop is the AC idle-suspend in ./home.nix; the two
# fail for unrelated reasons, which is the point of having both.

let
  # How often to look, and how many consecutive confirmations before acting.
  # The hall sensor bounces, so one reading is not enough to trust; two checks
  # 2 min apart puts a suspend roughly 4 minutes into the failure case, which
  # is well inside the thermal budget of a laptop in a bag.
  interval = "2min";
  threshold = 2;

  # Where the lid lives in EC RAM, from the DSDT:
  #
  #     OperationRegion (ECXP, EmbeddedControl, Zero, 0xFF)
  #     Field (ECXP, ByteAcc, Lock, Preserve) {
  #         ...
  #         Offset (0x76),
  #             ,   1,
  #         SLID,   1,
  #
  # so bit 1 of byte 0x76. Polarity is from RWAK, which treats `SLID == Zero`
  # as lid-open, i.e. the bit is SET when the lid is CLOSED.
  #
  # This is machine- and firmware-specific and a BIOS update could move it.
  # Re-derive with:
  #   sudo install -m 644 -o "$USER" /sys/firmware/acpi/tables/DSDT /tmp/dsdt.aml
  #   nix shell nixpkgs#acpica-tools -c iasl -d /tmp/dsdt.aml
  #   grep -nF 'SLID' /tmp/dsdt.dsl
  # The stuck-bit guard below is what stops a wrong offset from causing
  # spurious suspends.
  ecLidOffset = 118; # 0x76
  ecLidBit = 1;

  lid-watchdog = pkgs.writeShellApplication {
    name = "lid-watchdog";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      kmod
      systemd
    ];
    text = ''
      STATE=/run/lid-watchdog.count
      SEEN_OPEN=/run/lid-watchdog.seen-open
      THRESHOLD=${toString threshold}
      EC_IO=/sys/kernel/debug/ec/ec0/io
      EC_OFFSET=${toString ecLidOffset}
      EC_BIT=${toString ecLidBit}

      # Abandon this pass and clear the debounce counter.
      stand_down() {
        rm -f "$STATE"
        exit 0
      }

      # 1. Is the lid physically shut?
      #
      # Read the EC's own lid bit. This is the only trustworthy source on this
      # machine - see the header. /proc/acpi/button/lid/*/state is read too, but
      # only to log the disagreement when the firmware bug bites, since that
      # disagreement is the evidence for the vendor bug report.
      if ! modprobe -q ec_sys 2>/dev/null; then
        : # already built in, or already loaded; the read below is the real test
      fi

      if [ ! -r "$EC_IO" ]; then
        echo "cannot read $EC_IO (ec_sys missing, or debugfs not mounted); cannot judge lid position"
        stand_down
      fi

      byte=$(dd if="$EC_IO" bs=1 skip="$EC_OFFSET" count=1 status=none 2>/dev/null |
        od -An -tu1 | tr -d ' ')
      if [ -z "$byte" ]; then
        echo "short read at EC offset $EC_OFFSET; cannot judge lid position"
        stand_down
      fi

      if [ "$((byte >> EC_BIT & 1))" -eq 1 ]; then
        lid=closed
      else
        lid=open
      fi

      # Stuck-bit guard. If the offset is ever wrong - a BIOS update moving the
      # field, say - the bit we read could be something unrelated that is
      # permanently 1, and we would suspend the machine every few minutes for
      # no reason. So refuse to act until we have seen this bit read "open" at
      # least once since boot, which proves it actually tracks something.
      #
      # Booting with the lid already shut means we never arm; that is the safe
      # direction (we do nothing), and such a boot is a docked one anyway, where
      # the external-display check below would stand us down regardless.
      if [ "$lid" = open ]; then
        : > "$SEEN_OPEN"
        stand_down
      fi

      if [ ! -e "$SEEN_OPEN" ]; then
        echo "EC lid bit reads closed but has never read open since boot; refusing to trust offset $EC_OFFSET bit $EC_BIT"
        stand_down
      fi

      # Log the firmware bug when we catch it in the act.
      acpi_lid=""
      for f in /proc/acpi/button/lid/*/state; do
        [ -r "$f" ] || continue
        acpi_lid=$(awk '{print $2}' "$f")
        break
      done
      if [ "$acpi_lid" = open ]; then
        echo "EC reports lid closed but _LID still reports open - the EC dropped _Q19; trusting the EC"
      fi

      # 2. Is anything other than the internal panel connected?
      #
      # This is the clamshell guard. It is deliberately the same signal logind
      # uses for its own "docked" determination, so the watchdog and logind
      # agree about what a desk looks like. If an external display is attached,
      # leave the machine alone no matter how long it has sat untouched.
      for s in /sys/class/drm/card*-*/status; do
        [ -r "$s" ] || continue
        case "$s" in
          *eDP* | *LVDS* | *DSI*) continue ;;
        esac
        if [ "$(cat "$s")" = connected ]; then
          stand_down
        fi
      done

      # 3. Honour a deliberate override, e.g.
      #      systemd-inhibit --what=sleep --why="long build" sleep 3h
      # Read logind's own view rather than parsing `systemd-inhibit --list`.
      blocked=$(busctl get-property org.freedesktop.login1 /org/freedesktop/login1 \
        org.freedesktop.login1.Manager BlockInhibited 2>/dev/null |
        cut -d'"' -f2 || true)
      case ":$blocked:" in
        *:sleep:*)
          echo "lid shut with no external display, but sleep is block-inhibited ($blocked); standing down"
          stand_down
          ;;
      esac

      # 4. Debounce. The hall sensor bounces, so require consecutive agreement
      #    before acting.
      count=0
      if [ -r "$STATE" ]; then
        read -r count < "$STATE" || count=0
      fi
      if ! [ "$count" -ge 0 ] 2>/dev/null; then
        count=0
      fi
      count=$((count + 1))
      echo "$count" > "$STATE"

      if [ "$count" -lt "$THRESHOLD" ]; then
        echo "lid shut, no external display ($count/$THRESHOLD) - confirming before acting"
        exit 0
      fi

      echo "lid shut and no external display confirmed $count times; suspending"
      rm -f "$STATE"
      exec systemctl suspend-then-hibernate
    '';
  };
in
{
  # The EC lid bit is only reachable through ec_sys + debugfs.
  boot.kernelModules = [ "ec_sys" ];

  systemd.services.lid-watchdog = {
    description = "Suspend if the lid is shut with no external display attached";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe lid-watchdog;
    };
  };

  systemd.timers.lid-watchdog = {
    description = "Periodically re-check for a closed lid that never suspended";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = interval;
      OnUnitActiveSec = interval;
      AccuracySec = "20s";
      Unit = "lid-watchdog.service";
    };
  };
}
