# Firmware bug report: lid state goes permanently stale after a dropped EC query

Written 2026-09-01, revised the same day after disassembling the DSDT. Draft of a
support report for TUXEDO, plus the evidence behind it. The mitigation on our
side is idle-suspend on AC, configured in `hosts/tux/home.nix`; this document is
about getting the defect fixed at source.

> **Revision note.** An earlier draft blamed `\_SB.PC00.LPCB.EC0._Q15` and its
> `AE_NOT_FOUND` abort. The disassembly disproves that: `_Q15` is a *display*
> notification handler, not a lid handler, and its abort is harmless. The real
> defect is described below. The `_Q15` bug is still worth fixing and is kept as
> a secondary item.

## Summary

`\_SB.LID1._LID` does not query the hardware. It returns a cached AML variable:

```asl
Name (LIDS, One)
Method (_LID, 0, NotSerialized)
{
    Return (LIDS)
}
```

`LIDS` has only three writers in the entire DSDT:

| Writer | Sets | When |
|---|---|---|
| `_Q16` (EC query 0x16) | `One` (open) | EC dispatches a lid-open event |
| `_Q19` (EC query 0x19) | `Zero` (closed) | EC dispatches a lid-close event |
| `RWAK` (i.e. `_WAK`) | resyncs from `EC0.SLID` | resume from S3/S4 |

So if the EC ever fails to dispatch `_Q19` on a lid close, `LIDS` keeps its
previous value and `_LID` reports **`open` while the lid is physically shut**,
for as long as the lid stays shut. Every consumer goes stale together: the
`Notify(LID1, 0x80)` that would raise `SW_LID`, the `_LID` method, and therefore
`/proc/acpi/button/lid/*/state`. There is no independent path for an OS to
notice or recover, because all three derive from that one variable.

The exposure window is exactly the dangerous one: from the moment the lid shuts
until it is next opened, the machine believes it is open. It will not suspend
and will not lock. Opening the lid makes the stale value accidentally correct
again, so the fault leaves no trace afterwards and the *next* lid close is an
independent coin flip — which is why this presents as intermittent.

Within that window nothing can recover it. The one self-healing mechanism, the
`RWAK` resync from `EC0.SLID`, is unreachable here: `_WAK` is only evaluated on
resume from S3/S4, and **this unit must run s2idle** because S3 resume hangs the
firmware (black screen, hard power-off required — separately reported). Under
s2idle the system never leaves S0 and `_WAK` is never evaluated. The machine
would have to suspend to resync its lid state, and it will not suspend because
its lid state is wrong.

## System identification

| | |
|---|---|
| Vendor | TUXEDO |
| Product | TUXEDO InfinityBook Pro Gen7 (MK1) |
| Board | PHxARX1_PHxAQF1, version Standard |
| BIOS | American Megatrends, **N.1.05A09**, dated 05/15/2024 |
| GPU | Intel Alder Lake-P GT2 (`i915`, PCI `8086:46A6`) — no discrete GPU |
| OS | NixOS 26.11, kernel **6.18.40** |
| ACPICA | 20250807 |

N.1.05A09 is the newest BIOS offered for this model on both the TUXEDO account
downloads page and LVFS.

## The relevant AML

Lid handlers, both clean — nothing here can fail on this hardware:

```asl
Method (_Q16, 0, NotSerialized)      // lid opened
{
    P8XH (Zero, 0x16)
    ^^^GFX0.GLID (0x03)
    ^^^^LID1.LIDS = One
    Notify (LID1, 0x80)
}

Method (_Q19, 0, NotSerialized)      // lid closed
{
    P8XH (Zero, 0x19)
    ^^^GFX0.GLID (0x02)
    ^^^^LID1.LIDS = Zero
    Notify (LID1, 0x80)
}
```

The live hardware lid bit does exist — `RWAK` trusts it as the authoritative
source when resyncing:

```asl
If ((\_SB.PC00.LPCB.EC0.SLID == Zero))  { \_SB.LID1.LIDS = One  }   // open
Else                                    { \_SB.LID1.LIDS = Zero }   // closed
```

`SLID` is declared as **bit 1 of EC RAM offset 0x76**, in
`OperationRegion (ECXP, EmbeddedControl, Zero, 0xFF)`:

```asl
Offset (0x76),
    ,   1,
SLID,   1,
```

`_LID` could return this directly and would then always be correct. It doesn't.

### Direct evidence that `SLID` stays correct when `LIDS` does not

Reproduced 2026-09-01 22:28. The lid was held shut for 28 seconds under a
`handle-lid-switch` inhibitor (to stop the OS acting on any event that did
arrive), while polling both sources:

```
TIME        SLID    _LID
22:28:04    open    open
22:28:07    closed  open    <-- lid physically shut here
22:28:35    open    open    <-- lid reopened
```

Throughout those 28 seconds `systemd-logind` logged **no lid event at all** —
the EC did not dispatch `_Q19`, so `LIDS` was never written and `_LID` kept
answering `open`. The EC's own `SLID` bit was correct the entire time.

This is the same failure as the 7 h 33 min event earlier that day, caught
deliberately, and it demonstrates that the hardware state is available and
accurate at the moment `_LID` is wrong. A `_LID` that returned `SLID` would have
reported the truth.

## Impact and evidence

Timeline from a single boot, 2026-09-01, machine on AC power:

```
11:12:36  Lid opened.                     ← last lid event the OS ever received
11:49:00  idle-suspend (battery timer, unrelated)
11:52:54  resume from s2idle              ← _WAK not evaluated; no LIDS resync
13:48:47  lid physically closed           ← no _Q19 dispatched
   ...    7 h 33 min awake, lid shut, on AC
21:21     lid opened by hand — machine had never suspended and was not locked
```

Corroboration that the lid really did close at 13:48:47: systemd's backlight
helper (`sd-bright`) ran in the same second, and the EC dispatched query `_Q15`
three times in 1.5 s (the display-notify handler; this unit's hall sensor is
known to bounce, and three transitions in that window is consistent with a real
close). **The EC noticed activity at the lid and raised a display event, but
never raised the lid event `_Q19`.**

During the 7 h 33 min window:

- **Zero** lid events of any kind reached `systemd-logind`.
- A 2-minute polling service read `/proc/acpi/button/lid/*/state` **278 times**
  and got `open` on every read, with the lid shut the entire time — because
  `_LID` was returning the stale `LIDS`.

This is the same failure that, on 2026-08-19, left the machine running for
98 minutes inside a closed bag. It came out hot. The thermal and data-security
exposure here is the reason we are filing: a laptop that reports its lid as open
while shut in a bag will neither suspend nor lock.

The fault is intermittent — 12 consecutive lid closes worked correctly between
2026-08-21 and 08-26 on the same kernel and BIOS.

## Ruled out

- **Not OS lid policy.** `systemd-logind` was never notified, so no policy
  (`HandleLidSwitch`, `HandleLidSwitchDocked`, inhibitors) was ever consulted.
  Verified with logind debug logging enabled.
- **Not a kernel regression.** Kernel unchanged across working and failing
  periods.
- **Not stale firmware.** Already on the newest released BIOS, N.1.05A09.
- **Not recoverable in software.** Both the event path and the polling path
  derive from the same `LIDS` variable, so they fail together by construction.

## What we are asking for

1. **Primary — EC:** investigate why the EC dispatches `_Q15` but not `_Q19` for
   a lid close. This is the originating fault.
2. **Primary — DSDT robustness:** make `\_SB.LID1._LID` return the live
   `\_SB.PC00.LPCB.EC0.SLID` (inverted, per `RWAK`'s polarity) instead of the
   cached `LIDS`. A dropped EC query would then be self-correcting on the next
   poll rather than permanent, which would contain the damage even if item 1
   proves hard to reproduce. Note the existing `RWAK` resync cannot serve this
   role on a machine restricted to s2idle.
3. **Secondary — cosmetic AML bug:** `_Q15` unconditionally calls
   `Notify (^^^PEG1.PEGP.EDP1, 0x86)`. On iGPU-only units that symbol does not
   resolve and the method aborts:

   ```
   ACPI BIOS Error (bug): Could not resolve symbol [^^^PEG1.PEGP.EDP1], AE_NOT_FOUND (20250807/psargs-332)
   ACPI Error: Aborting method \_SB.PC00.LPCB.EC0._Q15 due to previous error (AE_NOT_FOUND) (20250807/psparse-529)
   ```

   The failing `Notify` is the last statement in the method, so nothing is
   skipped and the practical impact is log noise — but it suggests one DSDT is
   shipped across iGPU and dGPU variants without guarding the dGPU path.
4. Failing 1 and 2, confirmation that overriding the DSDT locally (recompiled,
   loaded via initrd) is safe on this hardware.

## Appendix: reproducing the diagnosis

Check whether the lid is currently wedged — with the lid shut this should print
`closed`; if it prints `open`, `LIDS` is stale:

```sh
cat /proc/acpi/button/lid/*/state
```

Confirm the OS never saw the event:

```sh
journalctl -b -u systemd-logind | grep -F -e 'Lid closed' -e 'Lid opened'
```

Read the live EC lid bit and compare against `_LID` (needs root; `SLID` is bit 1
of offset 0x76, and reads `0` when the lid is **open**):

```sh
sudo modprobe ec_sys
sudo dd if=/sys/kernel/debug/ec/ec0/io bs=1 skip=118 count=1 status=none |
  od -An -tu1 |
  awk '{print "SLID =", int($1/2)%2, "(1 = closed)"}'
```

Disassemble the tables (`iasl` comes from `nix shell nixpkgs#acpica-tools`):

```sh
# `install` copies, sets the mode, and hands over ownership in one step; a plain
# `cp` preserves the source's 0400 root:root and iasl then fails with
# "Could not open file ... Permission denied".
sudo install -m 644 -o "$USER" /sys/firmware/acpi/tables/DSDT /tmp/dsdt.aml
nix shell nixpkgs#acpica-tools -c iasl -d /tmp/dsdt.aml

# -F keeps the pattern literal; the "(" would otherwise open a regex group.
grep -nF -A10 'Method (_Q19' /tmp/dsdt.dsl
grep -nF -A5  'Method (_LID' /tmp/dsdt.dsl
grep -nF 'LIDS' /tmp/dsdt.dsl
```

Note the fault clears the moment the lid is reopened (the stale `open` becomes
correct again), so it must be caught **while the lid is still shut**. To hold the
machine awake with the lid closed and compare the two sources, take a low-level
lid inhibitor, which logind always honours:

```sh
sudo systemd-inhibit --what=handle-lid-switch --why='lid diagnostics' sleep 60
```
