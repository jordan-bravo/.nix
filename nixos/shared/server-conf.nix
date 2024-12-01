# shared/server-conf.nix

{ inputs, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  users.users.main = {
    description = "main";
    extraGroups = [ /*"docker"*/ "networkmanager" "wheel" ];
    isNormalUser = true;
    useDefaultShell = true;
  };
  environment.systemPackages = with pkgs; [
    gcc # GNU Compiler Collection, version 13.2.0 (wrapper script)
  ];

  programs = {
    ssh = {
      # startAgent = true;
      # Add SSH public keys for Borgbase
      knownHosts = {
        "*.repo.borgbase.com" = {
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU0mISTyHBw9tBs6SuhSq8tvNM8m9eifQxM+88TowPO";
        };
      };
    };
  };

  services = {
    openssh.enable = true;
  };
}


