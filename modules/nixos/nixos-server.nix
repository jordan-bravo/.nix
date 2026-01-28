{ config, pkgs, ... }:

{
  users.users.main = {
    description = "main";
    extraGroups = [
      # "docker"
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    useDefaultShell = true;
  };
  environment.systemPackages = with pkgs; [
    pkg-config # Required for borg mount
  ];

  programs.ssh = {
    # Add SSH public keys for Borgbase
    knownHosts = {
      "*.repo.borgbase.com" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU0mISTyHBw9tBs6SuhSq8tvNM8m9eifQxM+88TowPO";
      };
    };
  };

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  users.users.main.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILIqAdolJ5EQgszdsbzcbbIBZ+LMmZEOISlsCkcER/Ne jordan@bravo.cc"
  ];

  programs.zsh.interactiveShellInit = ''
    # Add ssh key
    ssh-add ~/.ssh/ssh_id_ed25519_main@${config.networking.hostName} 1> /dev/null 2>&1
  '';
}

# ssh-add ~/.ssh/ssh_id_ed25519_main@${osConfig.networking.hostName} 1> /dev/null 2>&1
