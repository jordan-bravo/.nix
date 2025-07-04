{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/nixos-all.nix
    ../../modules/nixos/nixos-server.nix
    ./secrets.nix
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  networking = {
    hostName = "punk";
    # next two options read from ./secrets.nix
    # interfaces.eth0.ipv4.addresses = [{ address = "stored-in-secrets"; prefixLength = 24; }];
    # defaultGateway = "also-stored-in-secrets";
    nameservers = [ "82.197.81.10" "1.1.1.1" "8.8.4.4" ]; # hostinger, cloudflare, google
    firewall.allowedTCPPorts = [ 80 443 22 ];
  };
  users.users.main.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILIqAdolJ5EQgszdsbzcbbIBZ+LMmZEOISlsCkcER/Ne jordan@bravo.cc"
  ];
}
