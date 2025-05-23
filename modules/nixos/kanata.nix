{
  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          # "/dev/input/by-id/usb-Framework_Laptop_16_Keyboard_Module_-_ANSI_FRAKDKEN0100000000-event-kbd"
          # "/dev/input/by-id/usb-Framework_Laptop_16_Keyboard_Module_-_ANSI_FRAKDKEN0100000000-if02-event-kbd"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          #|

          This minimal config changes Caps Lock to act as Escape on quick tap, but
          if held, it will change hjkl to arrow keys and Enter becomes Caps Lock

          TODO:
          - Find out how to achieve:
              Holding shift and tapping the Caps Lock key should toggle the Caps Lock functionality.

          |#


          #|
          One defcfg entry may be added, which is used for configuration key-pairs. These
          configurations change kanata's behaviour at a more global level than the other
          configuration entries.
          |#

          #|
          defcfg process-unmapped-keys

          This configuration will process all keys pressed inside of kanata, even if
          they are not mapped in defsrc. This is so that certain actions can activate
          at the right time for certain input sequences. By default, unmapped keys are
          not processed through kanata.
          |#

          (defsrc
            caps          h    j    k    l
          )

          (deflayer default
            @caps-alias _    _    _    _
          )

          (deflayer arrows
            _          left down up   rght
          )

          (defalias
            caps-alias (tap-hold-press 200 200 esc (layer-toggle arrows)) ;; tap: space  hold: arrow layer
          )
        '';
      };
    };
  };
}
