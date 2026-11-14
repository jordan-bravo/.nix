{ config, lib, pkgs, ... }:

### Lid resync: undo a stale "lid closed" replayed at resume.
#
# Background. `acpi.ec_no_wakeup=1` (see ./configuration.nix) stops EC events
# from waking s2idle. That fixed the lock-screen typing freeze, but it means a
# lid close that happens while the machine sleeps is only handled at thaw: the
# EC's `_Q19` (lid closed) is replayed at resume, setting `\_SB.LID1.LIDS` to
# Zero, and the matching `_Q16` (lid opened) can arrive late or never.
# `_LID` only returns the cached `LIDS`, and `RWAK` (the one path that resyncs
# it from the EC) runs only on S3/S4, never under s2idle.
#
# logind then believes the lid is shut and, once its 30 s resume holdoff
# expires, re-suspends the machine while it is being used - every ~30 s
# until the lid is cycled. Seen 2026-11-14 08:47-08:52 (four re-suspends).
#
# Fix: after each resume, compare the EC's own lid bit (the source `RWAK`
# trusts, same read as ./lid-watchdog.nix) with what ACPI reports. If the EC
# says open but ACPI says closed, evaluate the EC's lid-open handler `_Q16`
# through acpi_call. From the DSDT (live EC is `\_SB.PC00.LPCB.EC0`; the
# `H_EC`/`LID0` devices have _STA 0 and are unused):
#
#     Method (_Q16, 0, NotSerialized)
#     {
#         P8XH (Zero, 0x16)           // POST-code debug write, harmless
#         ^^^GFX0.GLID (0x03)         // tell the graphics opregion: lid open
#         ^^^^LID1.LIDS = One
#         Notify (LID1, 0x80)         // -> SW_LID open -> logind "Lid opened."
#     }
#
# `GLID` (SSDT4, verified 2026-11-14) only writes the lid state into the Intel
# graphics opregion (CLID) and, if the graphics driver is ready, sends the
# standard Notify(GFX0, 0x80) display-status event - there is no HNOT
# override. So the whole method is exactly what the firmware itself does on a
# real lid open (81 of those this boot alone, with no ill effects). It only ever
# asserts "open", and only when the EC confirms the lid is open, so it cannot
# cause a suspend; the worst case (a wrong EC offset reading "open" on a shut
# lid) is a machine staying awake, which the AC idle-suspend in ./home.nix
# still covers.
#
# Must act inside logind's 30 s HoldoffTimeoutSec, so it starts straight after
# resume and watches for 25 s (the stale close can land a little after thaw).

let
  # Watch window after resume, in seconds. Keep below logind's 30 s holdoff.
  window = 25;
  # Cap on _Q16 calls per resume, in case something keeps flipping it back.
  maxCalls = 3;

  # Same field as ./lid-watchdog.nix: EC RAM byte 0x76 bit 1 (`SLID`),
  # set when the lid is CLOSED. Re-derive from the DSDT after a BIOS update.
  ecLidOffset = 118; # 0x76
  ecLidBit = 1;

  q16 = ''\_SB.PC00.LPCB.EC0._Q16'';

  lid-resync = pkgs.writeShellApplication {
    name = "lid-resync";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
    ];
    text = ''
      EC_IO=/sys/kernel/debug/ec/ec0/io
      CALL=/proc/acpi/call
      LID_STATE=/proc/acpi/button/lid/LID1/state

      for f in "$EC_IO" "$CALL" "$LID_STATE"; do
        if [ ! -e "$f" ]; then
          echo "$f missing (ec_sys / acpi_call / button not loaded?); cannot resync lid"
          exit 0
        fi
      done

      ec_lid() {
        local byte
        byte=$(dd if="$EC_IO" bs=1 skip=${toString ecLidOffset} count=1 status=none 2>/dev/null |
          od -An -tu1 | tr -d ' ')
        if [ -z "$byte" ]; then
          echo unknown
        elif [ "$((byte >> ${toString ecLidBit} & 1))" -eq 1 ]; then
          echo closed
        else
          echo open
        fi
      }

      acpi_lid() {
        awk '{print $2}' "$LID_STATE"
      }

      # Stale = EC says open, ACPI says closed. Require two readings 1 s apart
      # because the hall sensor bounces.
      stale() {
        [ "$(ec_lid)" = open ] && [ "$(acpi_lid)" = closed ] || return 1
        sleep 1
        [ "$(ec_lid)" = open ] && [ "$(acpi_lid)" = closed ]
      }

      calls=0
      end=$((SECONDS + ${toString window}))
      while [ "$SECONDS" -lt "$end" ]; do
        if stale; then
          if [ "$calls" -ge ${toString maxCalls} ]; then
            echo "lid still reported closed after $calls _Q16 calls; giving up"
            exit 0
          fi
          echo "EC says lid open but ACPI says closed (stale _Q19 at resume); evaluating _Q16"
          echo '${q16}' > "$CALL"
          result=$(tr -d '\0' < "$CALL")
          calls=$((calls + 1))
          case "$result" in
            Error*) echo "acpi_call failed: $result"; exit 0 ;;
          esac
          echo "ACPI lid state now: $(acpi_lid)"
        fi
        sleep 1
      done
    '';
  };
in
{
  # /proc/acpi/call. ec_sys (for the EC read) is loaded by ./lid-watchdog.nix.
  boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
  boot.kernelModules = [ "acpi_call" ];

  # Started each time a post-sleep target is reached, i.e. after resume.
  # These targets are ordered after the systemd-*.service that does the
  # sleeping, so they are only reached once the machine is awake again.
  systemd.services.lid-resync =
    let
      targets = [
        "suspend.target"
        "suspend-then-hibernate.target"
        "hibernate.target"
        "hybrid-sleep.target"
      ];
    in
    {
      description = "Fix a stale lid-closed state replayed at resume";
      after = targets;
      wantedBy = targets;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe lid-resync;
      };
    };
}
