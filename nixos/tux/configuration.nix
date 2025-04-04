# ~/.nix/tux/configuration.nix

{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared/shared-conf.nix
    ../shared/workstation-conf.nix
    # inputs.xremap-flake.nixosModules.default
  ];

  nix.settings.trusted-users = [ "root" "jordan" ];

  # Remap keys

  # services.xremap = {
  #   enable = false;
  #   withGnome = true;
  #   serviceMode = "system";
  #   userName = "jordan";
  #   config = {
  #     modmap = [
  #       {
  #         name = "Global";
  #         remap = { "Context_Menu" = "RightMeta"; };
  #       }
  #     ];
  #   };
  #   debug = true;
  #   watch = true;
  # };
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ "jordan" ];
  users.groups.input.members = [ "jordan" ];

  environment.systemPackages = with pkgs; [
    greetd.gtkgreet
  ];

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

  services.ivpn.enable = false;

  services.greetd = {
    enable = true;
  };

  services.postgresql = {
    enable = false;
    package = pkgs.postgresql_14;
    ensureDatabases = [ "thefacebood-dev" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  services.redis.servers."alta" = {
    enable = false;
    port = 6379;
  };

  # services.ollama = {
  #   enable = true;
  # };
  #
  # services.nextjs-ollama-llm-ui = {
  #   enable = true;
  #   ollamaUrl = "http://127.0.0.1:11434";
  # };

  networking.hostName = "tux";

  # probably the above line accomplished the same thing as the below
  # programs.uwsm = {
  #   enable = true;
  #   waylandCompositors.hyprland = {
  #     binPath = "/run/current-system/sw/bin/hyprland";
  #     comment = "Hyprland session managed by uwsm";
  #     prettyName = "Hyprland";
  #   };
  # };

  programs.git.enable = true;

  # The following is to get Alta Legacy working on NixOS
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      xorg.libX11
      xorg.libxcb
      # xorg.libXcomposite # For VSCodium extension Markdown PDF
      # zlib # numpy
      # libgcc # sqlalchemy
      # zlib
      # that's where the shared libs go, you can find which one you need using 
      # nix-locate --top-level libstdc++.so.6  (replace this with your lib)
    ];
  };

  # Secure Boot using lanzaboote

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };


}
