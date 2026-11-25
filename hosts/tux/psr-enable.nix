{ pkgs, ... }:

### Panel self-refresh (PSR2) on, at boot.
#
#   Status:   sudo cat /sys/kernel/debug/dri/0000:00:02.0/eDP-1/i915_psr_status
#   Undo now: echo 0 | sudo tee /sys/kernel/debug/dri/0000:00:02.0/i915_edp_psr_debug
#   Undo for good: remove ./psr-enable.nix from configuration.nix imports.
#
# Why: the panel supports PSR2 but the firmware's VBT marks PSR off, so the
# package never reached PC10 with the screen on. Measured 2026-11-22, idle on
# battery: 8.3 W -> 6.3 W, PC10 0% -> 73%.
#
# Why not i915.enable_psr=2: on kernel 6.18 that param can only restrict PSR;
# the default path follows the VBT alone (psr_global_enabled() in
# intel_psr.c). The debugfs override 0x2 (I915_PSR_DEBUG_ENABLE) is the only
# way past it. It persists across suspend and hibernate; reset only at boot.
#
# If the screen flickers, lags, or stops updating (esp. after resume),
# this is the first suspect.
{
  systemd.services.i915-psr-enable = {
    description = "Enable i915 panel self-refresh (firmware VBT disables it)";
    wantedBy = [ "multi-user.target" ];
    after = [ "sys-kernel-debug.mount" ];
    # i915 loads from udev (~17 s into boot), not ordered against this unit,
    # so wait up to 60 s for its debugfs file rather than racing it.
    script = ''
      f=/sys/kernel/debug/dri/0000:00:02.0/i915_edp_psr_debug
      for _ in $(seq 60); do [ -e "$f" ] && break; sleep 1; done
      echo 0x2 > "$f"
      echo "PSR debug mode set to $(cat "$f")"
    '';
    path = [ pkgs.coreutils ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
