{ lib
, pkgs
, ...
} @ args:
{
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    bat
    curl
    delta
    gcc
    git
    lsd
    neovim
    trash-cli
    wl-clipboard
  ];

  networking = {
    hostName = "punk";
    # next two options read from ./secrets.nix
    # interfaces.eth0.ipv4.addresses = [{ address = "stored-in-secrets"; prefixLength = 24; }];
    # defaultGateway = "also-stored-in-secrets";
    nameservers = [ "82.197.81.10" "1.1.1.1" "8.8.4.4" ]; # hostinger, cloudflare, google
    firewall.allowedTCPPorts = [ 80 443 22 ];
  };

  # users.users.root.initialHashedPassword = "$y$j9T$8Sk5rvIZbjXDqYTlsgDzS.$4z7A1Ixu8T49tzTgyupKG/bwWbRMZVXfrRHOCFbgElD";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILIqAdolJ5EQgszdsbzcbbIBZ+LMmZEOISlsCkcER/Ne jordan@bravo.cc"
  ];

  system.stateVersion = "25.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  time.timeZone = "America/New_York";

  nixpkgs.config.allowUnfree = true;
  environment.shellAliases = {
    l = "ls -lAhF";
  };
}
