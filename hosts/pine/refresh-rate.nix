# Switch the internal OLED panel to 60 Hz on battery and 90 Hz on AC.
#
# Listens for UPower PropertiesChanged signals (OnBattery, LidIsClosed) on the
# system bus and re-evaluates on each one; no polling. Uses Fedora's
# /usr/bin/cosmic-randr and /usr/bin/gdbus rather than nixpkgs' so the
# cosmic-randr protocol version always matches the running cosmic-comp.
{ pkgs, ... }:
let
  output = "eDP-1";
  acHz = 90;
  batteryHz = 60;

  script = pkgs.writeShellApplication {
    name = "refresh-rate-on-power";
    runtimeInputs = [
      pkgs.gawk
      pkgs.gnugrep
    ];
    text = ''
      randr=/usr/bin/cosmic-randr

      apply() {
        local target kdl block w h mhz
        if /usr/bin/busctl get-property org.freedesktop.UPower /org/freedesktop/UPower \
             org.freedesktop.UPower OnBattery | grep -q true; then
          target=${toString batteryHz}
        else
          target=${toString acHz}
        fi

        kdl=$("$randr" list --kdl) || return 0
        block=$(awk -v o='"${output}"' '$1 == "output" { inblk = ($2 == o) } inblk' <<<"$kdl")
        # Leave the panel alone when it's disabled (lid closed / external only),
        # otherwise setting a mode would turn it back on.
        grep -q 'enabled=#true' <<<"$block" || return 0

        read -r w h mhz < <(awk '/current=#true/ { print $2, $3, $4 }' <<<"$block")
        [ -n "''${mhz:-}" ] || return 0
        if [ $(( (mhz + 500) / 1000 )) -eq "$target" ]; then
          return 0
        fi

        echo "on_battery=$([ "$target" -eq ${toString batteryHz} ] && echo yes || echo no): ${output} -> ''${w}x''${h}@''${target}Hz"
        "$randr" mode ${output} "$w" "$h" --refresh "$target" || true
      }

      apply
      # Each signal line from UPower triggers a re-check; apply() is idempotent.
      /usr/bin/gdbus monitor --system --dest org.freedesktop.UPower \
          --object-path /org/freedesktop/UPower |
        while read -r _; do apply; done
    '';
  };
in
{
  systemd.user.services.refresh-rate-on-power = {
    Unit = {
      Description = "Set ${output} to ${toString acHz} Hz on AC, ${toString batteryHz} Hz on battery";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${script}/bin/refresh-rate-on-power";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
