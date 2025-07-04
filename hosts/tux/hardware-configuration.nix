# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/f6165284-4f0e-49d4-856d-35f2c33d8c6a";
      fsType = "ext4";
    };

  # main partition
  boot.initrd.luks.devices."luks-81d8dbb8-c576-4e74-9e4d-726266c7f62a".device = "/dev/disk/by-uuid/81d8dbb8-c576-4e74-9e4d-726266c7f62a";
  # swap partition
  boot.initrd.luks.devices."luks-b833f707-549f-4dc1-a252-b169903c5677".device = "/dev/disk/by-uuid/b833f707-549f-4dc1-a252-b169903c5677";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/956E-3796";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/1d41849f-d81a-4564-9057-11c349f17490"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
