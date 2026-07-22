# caps-escape.nix — escape-shifted Caps Lock for COSMIC (Wayland)
#
# Caps tapped = Escape, Shift+Caps = real Caps Lock toggle.
#
# COSMIC's compositor reads xkb via libxkbcommon from the cosmic-config file
# com.system76.CosmicComp/v1/xkb_config (RON). We define a custom xkb option
# `custom:esc_shifted_caps` in ~/.config/xkb and select it there.
#
# Notes:
# - The xkb_config symlink owns the WHOLE file, so repeat_delay/rate and
#   layout/model become declarative too. Values below mirror the current config.
# - Do NOT use home.keyboard: it drives setxkbmap/localed (X11), which COSMIC's
#   Wayland compositor ignores.
# - After the first switch, reload cosmic-comp or re-login for the keymap to
#   take effect. If the keymap fails to compile, COSMIC falls back to default
#   (Caps acts as Caps) — a safe, obvious failure signal.
# - `v1` in the cosmic path is COSMIC's config schema version; bump it if a
#   future COSMIC moves cosmic-comp to v2.
{ ... }:
{
  xdg.configFile."xkb/symbols/custom".text = ''
    partial modifier_keys
    xkb_symbols "esc_shifted_caps" {
        replace key <CAPS> {
            type = "TWO_LEVEL",
            symbols[Group1] = [ Escape, Caps_Lock ],
            actions[Group1] = [ NoAction(), LockMods(modifiers=Lock) ]
        };
    };
  '';

  xdg.configFile."xkb/rules/evdev".text = ''
    ! option = symbols
      custom:esc_shifted_caps = +custom(esc_shifted_caps)

    ! include %S/evdev
  '';

  xdg.configFile."cosmic/com.system76.CosmicComp/v1/xkb_config".text = ''
    (
        rules: "",
        model: "pc105",
        layout: "us",
        variant: "",
        options: Some(",custom:esc_shifted_caps"),
        repeat_delay: 600,
        repeat_rate: 25,
    )
  '';
}
