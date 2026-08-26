{ lib, pkgs, ... }:

### Lid watchdog: catch lid closes that never resulted in a suspend.
#
# Background (2026-08-21). logind's lid handling has failed on this machine in
# two distinct ways, and they need different fixes:
#
#   1. No `Lid closed.` line in the journal at all. The SW_LID evdev event was
#      never delivered - the flaky hall sensor / EC. Nothing in logind's
#      configuration can help, because logind is never told anything happened.
#
#   2. `Lid closed.` present, but no `Suspending, then hibernating...` after it.
#      logind received the event and declined to act. On 2026-08-19 the lid
#      closed at 15:00:11 and nothing happened until 16:38:11 - 98 minutes
#      running in a closed bag, and the machine was hot when it came out.
#      The prime suspect is HandleLidSwitchDocked, which defaults to "ignore"
#      and which logind applies whenever *more than one display is connected*.
#      logind decides this once, at the instant the lid closes, and never
#      revisits it - so unplugging the monitor and packing up leaves the
#      machine awake with no one watching.
#
# Raising HandleLidSwitchDocked to "suspend-then-hibernate" would fix case 2 but
# break clamshell use with an external monitor, which is wanted here. So instead
# of changing what logind decides, this re-checks the decision afterwards.
#
# It is NOT an idle timer - it never looks at user activity, so it will not
# suspend a machine being actively used in clamshell. It only asks whether the
# lid is shut with nothing but the (disabled) internal panel attached, which is
# a state in which no display can be showing anything to anyone.

let
  # How often to look, and how many consecutive confirmations before acting.
  # The hall sensor bounces, so one reading is not enough to trust; two checks
  # 2 min apart puts a suspend roughly 4 minutes into the failure case, which
  # is well inside the thermal budget of a laptop in a bag.
  interval = "2min";
  threshold = 2;

  lid-watchdog = pkgs.writeShellApplication {
    name = "lid-watchdog";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      systemd
    ];
    text = ''
      STATE=/run/lid-watchdog.count
      THRESHOLD=${toString threshold}

      # Abandon this pass and clear the debounce counter.
      stand_down() {
        rm -f "$STATE"
        exit 0
      }

      # 1. Is the lid physically shut?
      #
      # Read the ACPI _LID control method directly - boot.button's
      # lid_init_state is "method", so this is a live firmware query. Going
      # through /proc rather than the SW_LID evdev event is deliberate: the
      # evdev path is exactly the one that intermittently drops events, so
      # polling the firmware also covers failure mode 1 above, provided the
      # firmware itself knows the lid is shut.
      lid=""
      for f in /proc/acpi/button/lid/*/state; do
        [ -r "$f" ] || continue
        lid=$(awk '{print $2}' "$f")
        break
      done

      if [ -z "$lid" ]; then
        echo "no readable /proc/acpi/button/lid/*/state; cannot judge lid position"
        stand_down
      fi

      [ "$lid" = closed ] || stand_down

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

      # 4. Debounce. The hall sensor bounces a spurious "open" and can just as
      #    easily report a spurious "closed", so require consecutive agreement.
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
