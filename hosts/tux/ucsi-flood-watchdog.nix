{ lib, pkgs, ... }:

### UCSI flood watchdog: clear the USB-C event loop that ucsi_acpi falls into
### on resume.
#
# Background. On 2026-09-11 this machine resumed from s2idle at 07:23:32 and
# the USB-C connector manager came back wrong. The kernel said so at the moment
# of resume:
#
#     typec port0-partner: PM: parent port0 should not be sleeping
#     typec port0-cable:   PM: parent port0 should not be sleeping
#     ucsi_acpi USBC000:00: unknown error 0
#     ucsi_acpi USBC000:00: con1: failed to register partner alt modes (-5)
#
# After that failed registration the driver never settles. It re-registers and
# tears down the port partner forever, emitting a `change` uevent each time. A
# 6-second `udevadm monitor` sample taken 7 minutes into the failure caught
# 1178 events, and every single one of them was on this device:
#
#     590 change power_supply /devices/platform/USBC000:00/power_supply/ucsi-source-psy-USBC000:001
#     588 change typec       /devices/platform/USBC000:00/typec/port0/port0-partner
#
# That is ~196 events/s against a healthy idle rate of about one event every
# six seconds. systemd-udevd cannot keep up: it sat at 98.6% of a core for 7
# minutes, its RSS grew to 431 MB (peak 864 MB), and the service wedged in
# `Active: reloading`. The CPU package reached 88 C and the fans ran flat out
# on battery. `/sys/class/typec/port0/port0-partner/` could not even be stat'd,
# because the device was being created and destroyed faster than a path lookup.
#
# Unloading and reloading `ucsi_acpi` re-initialises the connector manager and
# ends the loop; verified by hand the same day, after which the package temp
# fell 88 C -> 43 C and the event rate fell to 1 per 6 s.
#
# This is worth automating because it recurs. The failed registration appears
# 44 times across the 14 boots still in journal retention, spanning kernels
# 6.18.16 through 6.18.40, so it is neither a one-off nor a recent regression.
#
# Note though that the log line and the flood are not the same event: 44
# occurrences have plainly not made this machine unusable 44 times, so most
# registrations that fail must recover on their own and only some fall into the
# unbounded loop. What separates the two is not known. That is why this measures
# the event rate rather than grepping the journal for the message - triggering
# on the message would cycle the driver dozens of times for faults that would
# have healed themselves.
#
# Why this is conditional rather than a blind reload on every resume. The
# machine is often docked, and reloading the driver drops USB-C power delivery
# for a moment, so an unconditional reload would blip a healthy dock on every
# single lid-open to fix something that usually is not broken. The separation
# between broken and healthy is four orders of magnitude (~196/s vs ~0.17/s),
# so detection is easy and worth the extra code. Same reasoning as the debounce
# in ./lid-watchdog.nix: act on confirmed evidence, not on a guess.
#
# Why the events are counted per-device rather than globally. /sys/kernel/
# uevent_seqnum would be cheaper, but it is system-wide, and a dock waking up
# legitimately enumerates a pile of devices at exactly the moment this check
# runs. Matching the USBC000:00 path means a busy dock cannot be mistaken for
# the fault. In the captured flood the attribution was 1178/1178.
#
# Why this is ordered on suspend.target and not sleep.target. They sit on
# opposite sides of the actual sleep:
#
#     sleep.target                      <- reached BEFORE suspending
#       -> systemd-suspend.service      <- performs the sleep, blocks until resume
#            -> suspend.target          <- reached only AFTER resume
#
# (`systemd-suspend.service` is `After=sleep.target`; `suspend.target` is
# `After=systemd-suspend.service`. Same shape for the hibernate variants.)
# A unit that is `WantedBy=` and `After=` suspend.target therefore runs on the
# way out of sleep, and does so without blocking the resume - unlike a
# `systemd-sleep` hook or `powerManagement.resumeCommands`, both of which run
# inside the critical path and would add this check's runtime to every resume.
# Note that NixOS only defines post-resume.target when powerManagement
# resume hooks are in use; it does not exist on this system.
#
# Instrumentation. Because the open question is which failed registrations
# flood and which heal themselves, every resume that logs a failed registration
# emits one machine-readable record, flood or not:
#
#     ucsi-probe: flood=no  code=-22 unknown_error=no  events=2
#     ucsi-probe: flood=yes code=-5  unknown_error=yes events=587
#
# Read the accumulated data back with:
#
#     journalctl -u ucsi-flood-watchdog.service --no-pager \
#       | grep -oP 'ucsi-probe: \K.*' | sort | uniq -c | sort -rn
#
# The hypothesis worth testing first is that the `-5`/`unknown error 0` variant
# floods and the bare `-22` variant does not - the one flood captured so far was
# a `-5`. A few weeks of resumes should settle it, and would also give the flood
# rate as a fraction of all failures, which is the number an upstream report
# needs. Resumes with no failure at all are deliberately not recorded here; the
# ordinary "quiet after resume" line already counts those.
#
# systemd-udevd is deliberately NOT restarted afterwards. Caught within seconds
# of resume it has not had time to balloon, and restarting it is a good deal
# more invasive than reloading one driver. If a flood is ever missed and udevd
# is found holding hundreds of MB, restart it by hand.
#
# See ../../docs/tux-ucsi-resume-flood.md.

let
  # Let the resume settle before sampling. A dock or charger coming back
  # legitimately re-negotiates on this same port, and that burst is over in a
  # second or two; sampling straight away would be measuring normal hotplug
  # traffic. The fault, by contrast, persists indefinitely, so waiting costs
  # nothing but avoids the only realistic false positive.
  settleSeconds = 5;

  # Long enough that the count is not noise, short enough that the service is
  # finished well before anyone opens a laptop lid and looks at it.
  sampleSeconds = 3;

  # Events on the USBC000:00 path within the sample window that mean "flood".
  # All figures measured on 2026-09-11:
  #
  #   fault:                     ~196/s  -> ~590 in 3 s
  #   idle, nothing plugged in:  ~0.17/s -> ~0.5 in 3 s
  #   idle, charging over USB-C: ~2.5/s  -> 7-8 in 3 s  (steady over 4 samples)
  #
  # The idle rate is NOT a single number - it depends on what is attached,
  # because a live USB-C power contract does continuous PD housekeeping on
  # `ucsi-source-psy` (10 of 15 events in a 6 s charging sample) plus periodic
  # partner re-evaluation (the other 5). Plugging the charger in raised idle
  # roughly 15-fold.
  #
  # 100 therefore sits ~6x below the fault and ~12x above the highest idle rate
  # actually measured. **Caveat: no idle measurement exists for a real dock**,
  # which has more to negotiate than a bare charger and will idle higher still.
  # If a dock ever trips this spuriously, that is the number to raise - and the
  # journal will say so plainly, because the post-reload confirmation re-samples
  # and would report the port "settling" to a value near the trigger.
  threshold = 100;

  # The platform device the ucsi_acpi driver binds to, and the path prefix that
  # every event in the captured flood carried.
  ucsiDevice = "USBC000:00";

  # How far back to look for this resume's kernel messages. The failed
  # registration is logged during the resume itself, moments before this unit
  # starts, so the window is anchored on the most recent `PM: suspend exit` and
  # only falls back to a fixed lookback if that cannot be found. Bounding the
  # journal query also keeps it cheap - without it this would scan the whole
  # boot's kernel log on every resume.
  lookbackMinutes = 10;

  # refcnt was 0 during the fault, so this unloads cleanly. typec_ucsi (refcnt
  # 1, held by ucsi_acpi) and typec (held by thunderbolt) are deliberately left
  # alone - only the leaf module needs to cycle, and pulling the lower layers
  # would drag thunderbolt down with them.
  ucsiModule = "ucsi_acpi";

  ucsi-flood-watchdog = pkgs.writeShellApplication {
    name = "ucsi-flood-watchdog";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      kmod
      systemd
    ];
    text = ''
      SETTLE=${toString settleSeconds}
      SAMPLE=${toString sampleSeconds}
      THRESHOLD=${toString threshold}
      DEVICE=${ucsiDevice}
      MODULE=${ucsiModule}
      LOOKBACK=${toString lookbackMinutes}min

      # Epoch second of this resume, for scoping the kernel-log query.
      #
      # Anchored on the last `PM: suspend exit` rather than a flat "N seconds
      # ago" so that a double resume - which this machine does, the lid sensor
      # bounces - cannot attribute the previous resume's failure to this run.
      resume_epoch() {
        local ts
        ts=$(journalctl -k --since "-$LOOKBACK" -o short-unix --no-pager 2>/dev/null |
          grep -F 'PM: suspend exit' | tail -1 | cut -d' ' -f1 | cut -d. -f1 || true)
        if [ -n "$ts" ]; then
          printf '%s\n' "$ts"
        else
          # No resume found in the window: this was probably a manual start.
          # Fall back to the whole window rather than reporting nothing.
          date -d "-$LOOKBACK" +%s
        fi
      }

      # Count udev events on the UCSI device over one sample window.
      #
      # `timeout` kills udevadm with status 124 when the window closes; that is
      # the normal exit path here, not a failure. `grep -c` likewise exits 1
      # when it counts zero, which is the healthy case. Both are swallowed
      # deliberately - writeShellApplication runs under `set -euo pipefail`.
      sample_events() {
        local out count
        out=$(mktemp)
        timeout "$SAMPLE" udevadm monitor --udev > "$out" 2>/dev/null || true
        count=$(grep -cF "$DEVICE" "$out" || true)
        rm -f "$out"
        printf '%s\n' "$count"
      }

      # 1. Let any legitimate re-enumeration finish before measuring.
      sleep "$SETTLE"

      # 2. What did ucsi_acpi say during this resume?
      #
      # Collected whether or not the port ends up flooding, because the open
      # question is precisely which failures flood and which recover on their
      # own. `grep -q` is used in an `if` rather than with `&&` so that a
      # no-match does not trip `set -e`.
      klog=$(journalctl -k --since "@$(resume_epoch)" --no-pager 2>/dev/null || true)

      code=$(printf '%s' "$klog" |
        grep -oE 'failed to register partner alt modes \(-[0-9]+\)' |
        tail -1 | grep -oE -- '-[0-9]+' || true)

      if printf '%s' "$klog" | grep -qF 'unknown error 0'; then
        unknown_error=yes
      else
        unknown_error=no
      fi

      # 3. Is the port flooding?
      before=$(sample_events)
      if [ "$before" -ge "$THRESHOLD" ]; then
        flood=yes
      else
        flood=no
      fi

      # 4. Emit one machine-readable record per resume that saw a failed
      #    registration. Aggregate later with:
      #      journalctl -u ucsi-flood-watchdog.service | grep -oP 'ucsi-probe: \K.*' | sort | uniq -c
      if [ -n "$code" ]; then
        echo "ucsi-probe: flood=$flood code=$code unknown_error=$unknown_error events=$before"
      fi

      if [ "$flood" = no ]; then
        if [ -n "$code" ]; then
          echo "$DEVICE registration failed during this resume (code $code) but recovered on its own ($before events in ''${SAMPLE}s, threshold $THRESHOLD); nothing to do"
        else
          echo "$DEVICE quiet after resume ($before events in ''${SAMPLE}s, threshold $THRESHOLD); nothing to do"
        fi
        exit 0
      fi

      echo "$DEVICE flooding after resume: $before events in ''${SAMPLE}s (threshold $THRESHOLD) - ucsi_acpi did not survive the resume"

      # 3. Only the leaf module is safe to cycle, and only while nothing holds
      #    a reference to it. If something does, say so and leave it alone
      #    rather than forcing it; a noisy port is a great deal better than a
      #    half-unloaded USB-C stack.
      if [ ! -d "/sys/module/$MODULE" ]; then
        echo "$MODULE is not loaded; cannot reload it, leaving the port alone"
        exit 1
      fi

      refcnt=$(cat "/sys/module/$MODULE/refcnt" 2>/dev/null || echo unknown)
      if [ "$refcnt" != 0 ]; then
        echo "$MODULE refcnt is $refcnt, expected 0; refusing to unload a module that is in use"
        exit 1
      fi

      # 4. Cycle the driver.
      if ! modprobe -r "$MODULE"; then
        echo "failed to unload $MODULE; leaving the port alone"
        exit 1
      fi
      if ! modprobe "$MODULE"; then
        echo "unloaded $MODULE but could not load it back - USB-C power delivery is now down until the next boot"
        exit 1
      fi

      # 5. Confirm it actually helped. Re-registration produces its own small
      #    burst, so settle again before believing the second reading.
      sleep "$SETTLE"
      after=$(sample_events)
      if [ "$after" -ge "$THRESHOLD" ]; then
        echo "reloaded $MODULE but $DEVICE is still flooding ($after events in ''${SAMPLE}s); the reload did not take"
        exit 1
      fi

      echo "reloaded $MODULE; $DEVICE settled ($before -> $after events in ''${SAMPLE}s)"
    '';
  };
in
{
  systemd.services.ucsi-flood-watchdog = {
    description = "Reload ucsi_acpi if the USB-C port floods uevents after resume";

    # See the header: these four targets are all reached on the way OUT of
    # sleep, so this runs on resume without blocking it. sleep.target would be
    # the wrong end of the cycle.
    #
    # All four are listed rather than just suspend.target because the one that
    # actually fires here is suspend-then-hibernate.target - that is what
    # services.logind HandleLidSwitch is set to in ./configuration.nix, so a
    # lid close never reaches suspend.target at all. Confirmed on 2026-09-11:
    #
    #     07:55:37  Reached target Sleep.                             (going down)
    #     07:55:47  Stopped target Sleep.
    #     07:55:47  Reached target Suspend; Hibernate if not used ... (coming back)
    #
    # and the service ran at 07:55:47. Wiring only suspend.target would have
    # left this silently dead on every lid close.
    after = [
      "suspend.target"
      "hibernate.target"
      "suspend-then-hibernate.target"
      "hybrid-sleep.target"
    ];
    wantedBy = [
      "suspend.target"
      "hibernate.target"
      "suspend-then-hibernate.target"
      "hybrid-sleep.target"
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe ucsi-flood-watchdog;
    };
  };
}
