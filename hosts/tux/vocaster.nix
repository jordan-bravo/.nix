{ ... }:

### Focusrite Vocaster One: hide the capture endpoints not used day to day.
#
# Since firmware 1769 (flashed 2026-11-20 with `nix run nixpkgs#scarlett2 --
# update`; 1749 broke the UCM profile with "CaptureChannels=10 > avail 8"),
# alsa-ucm-conf's Vocaster-One-HiFi.conf splits the 10-channel capture PCM
# into separate sources:
#
#   USB3 Video Call   mic + aux + "Playback" output (mix-minus for calls)
#   USB4 Show Mix     everything
#   USB5 Host Mic     raw mic (post-DSP)
#   USB6 Aux          3.5 mm aux in          <- hidden
#   USB7 Loopback 1   computer playback 1    <- hidden
#   USB8 Loopback 2   computer playback 2    <- hidden
#
# WirePlumber's alsa monitor evaluates node.disabled before it creates the
# SplitPCM loopback, so a disabled node never appears as a source at all.
# The hardware channels still exist; drop a line here to bring one back.
{
  services.pipewire.wireplumber.extraConfig."51-vocaster-hide-sources" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" =
              "~alsa_input\\.usb-Focusrite_Vocaster_One_USB_.*\\.HiFi__USB[678]__source";
          }
        ];
        actions.update-props."node.disabled" = true;
      }
    ];
  };
}
