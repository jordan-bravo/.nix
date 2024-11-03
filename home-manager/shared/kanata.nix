{
  home.file = {
    kanata-config = {
      target = ".config/kanata/config.kbd";
      enable = true;
      text = ''
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

        (defcfg
          process-unmapped-keys yes
        )

        (defsrc
          caps       h    j    k    l    ret
        )

        (deflayer default
          @cap-alias _    _    _    _    _
        )

        (deflayer arrows
          _          left down up   rght caps
        )

        (defalias
          cap-alias (tap-hold-press 200 200 esc (layer-toggle arrows)) ;; tap: esc  hold: arrow layer
        )
      '';
    };
    kanata-service = {
      target = ".config/systemd/user/kanata.service";
      enable = true;
      text = ''
        [Unit]
        Description=Kanata keyboard remapper
        Documentation=https://github.com/jtroo/kanata

        [Service]
        Environment=DISPLAY=:0
        Type=simple
        ExecStart=%h/.nix-profile/bin/kanata --cfg %h/.config/kanata/config.kbd
        Restart=no

        [Install]
        WantedBy=default.target

      '';
    };

  };
}
