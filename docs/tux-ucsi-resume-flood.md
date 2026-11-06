# ucsi_acpi wedges into an unbounded uevent loop after resume

Written 2026-09-11, after catching the fault live. The mitigation on our side is
`hosts/tux/ucsi-flood-watchdog.nix`, which detects the loop after a resume and
reloads the driver. This document is the evidence behind it, and the basis for
a report upstream.

## Summary

On resume from s2idle, `ucsi_acpi` intermittently fails to re-register the USB-C
port partner and then never settles. It re-registers and tears down
`port0-partner` indefinitely, emitting a `change` uevent on each pass, at a rate
high enough to saturate `systemd-udevd` and heat the machine until the fans run
continuously.

The failure announces itself in the kernel log at the moment of resume:

```
typec port0-partner: PM: parent port0 should not be sleeping
typec port0-cable:   PM: parent port0 should not be sleeping
ucsi_acpi USBC000:00: unknown error 0
ucsi_acpi USBC000:00: con1: failed to register partner alt modes (-5)
```

Unloading and reloading `ucsi_acpi` clears it completely.

## Measurements from the 2026-09-11 event

The machine resumed at 07:23:32 and was caught in the act about seven minutes
later, at 07:29:30, still flooding.

A six-second `udevadm monitor --udev` sample taken during the fault:

| Count | Action | Subsystem | Device |
|---|---|---|---|
| 590 | `change` | `power_supply` | `/devices/platform/USBC000:00/power_supply/ucsi-source-psy-USBC000:001` |
| 588 | `change` | `typec` | `/devices/platform/USBC000:00/typec/port0/port0-partner` |

1178 events in six seconds, ~196/s, and **every one of them on the `USBC000:00`
path** — 1178 of 1178.

For contrast, the healthy idle rate is not a single figure — it depends on what
is attached to the port:

| State | Rate | Per 3 s |
|---|---|---|
| Fault | ~196/s | ~590 |
| Idle, nothing plugged in | ~0.17/s | ~0.5 |
| Idle, charging over USB-C | ~2.5/s | 7–8 |

Plugging in a charger raises the idle rate roughly fifteen-fold, because a live
USB-C power contract does continuous PD housekeeping — in a 6 s sample while
charging, 10 of 15 events were `ucsi-source-psy` power-supply updates and the
other 5 were periodic `port0-partner` re-evaluation. Both are normal.

**No idle measurement exists for an actual dock**, which has more to negotiate
than a bare charger and will sit higher again. The watchdog's threshold of 100
per 3 s has ~12x headroom over the highest idle rate measured so far, but that
headroom against a dock is untested.

Consequences observed:

- `systemd-udevd` pinned at **98.6% of a core** for seven minutes (7 min 32 s of
  accumulated CPU time).
- Its RSS grew to **431 MB**, peak **864 MB**.
- The service wedged in `Active: reloading (reload-notify)`, status
  `"Reloading configuration..."`.
- CPU package temperature **88 °C**, CPU-side ACPI zones 73–78 °C. Fans at full.
- This was on battery (`AC0 online=0`, 91%, discharging), so it was also burning
  through charge.
- `/sys/class/typec/port0/port0-partner/` could not be stat'd at all — the
  device was being created and destroyed faster than a path lookup could
  resolve it.

After `modprobe -r ucsi_acpi && modprobe ucsi_acpi`:

- Package temperature **88 °C → 43 °C**.
- Event rate **~196/s → 1 per 6 s**.
- Load average 3.47 → 1.42, `systemd-udevd` out of the top processes entirely.

## Frequency

This is not a one-off. Counting `failed to register partner alt modes` across
every boot still in journal retention:

| Boots with the failure | Total occurrences | Kernel range |
|---|---|---|
| 14 | 44 | 6.18.16 – 6.18.40 |

Per boot: 4, 3, 3, 1, 2, 2, 1, 7, 1, 1, 3, 7, 1, 8.

It spans at least five kernel versions (6.18.16, .24, .33, .37, .38, .40), so it
is **not** a recent regression, and there is no evidence here that any kernel in
that range is better or worse than another. Every boot in retention runs some
6.18.x, so this data cannot say whether older series were affected.

Two distinct error codes appear:

- `-5` (`EIO`), always immediately preceded by `ucsi_acpi USBC000:00: unknown
  error 0`. This is the variant that flooded on 2026-09-11.
- `-22` (`EINVAL`), which appears on its own with no preceding `unknown error`.

## Important caveat: the log line is not the same thing as the flood

There are 44 of these log entries, and the machine has certainly not been
unusable 44 times. So the failed registration is necessary for the flood but
evidently not sufficient — most occurrences apparently recover, and only some
fall into the unbounded loop. What distinguishes the two is not yet known.

This is precisely why the watchdog keys on the **measured event rate** rather
than on grepping the journal for the message. Triggering on the message would
reload the driver dozens of times for occurrences that would have healed on
their own, which on a docked machine means dropping USB-C power delivery for no
reason. Measuring the actual flood is both more accurate and cheaper to be wrong
about.

## Reproducing and diagnosing

To confirm a live flood:

```sh
# Should be ~0-1 on a healthy machine, several hundred during the fault.
timeout 3 udevadm monitor --udev | grep -cF 'USBC000:00'
```

To see whether the driver is safe to cycle (`refcnt` must be 0):

```sh
cat /sys/module/ucsi_acpi/refcnt
```

Only `ucsi_acpi` should be cycled. `typec_ucsi` is held by it, and `typec` is
held by `thunderbolt`; unloading the lower layers would drag Thunderbolt down
with them and is unnecessary.

## Relationship to the lid bug

Unrelated in mechanism, but they share a trigger: both are provoked by this
machine's suspend/resume path, and this machine is confined to s2idle because
S3 resume hangs the firmware (see
[`tux-lid-acpi-q15-firmware-bug.md`](./tux-lid-acpi-q15-firmware-bug.md), and
the `mem_sleep_default` note in `hosts/tux/configuration.nix`). The lid bug is a
firmware defect in the EC's query dispatch; this one is in the USB-C connector
manager. They should be reported separately.

Whether the `unknown error 0` originates in the firmware's UCSI implementation
returning a status the driver does not recognise, or in the driver's handling of
a legitimate error, is not established here. That distinction determines whether
this belongs to TUXEDO or to the `usb/typec/ucsi` maintainers, and needs a
driver-side trace to settle.
