# shared/server-conf.nix

{ inputs, osConfig, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 8;
  };
  users.users.main = {
    description = "main";
    extraGroups = [ /*"docker"*/ "networkmanager" "wheel" ];
    isNormalUser = true;
    useDefaultShell = true;
  };
  environment.systemPackages = with pkgs; [
    gcc # GNU Compiler Collection, version 13.2.0 (wrapper script)
    git-crypt
    neovim
    pkg-config # Required for borg mount
    ripgrep
  ];

  programs.ssh = {
    # startAgent = true;
    # Add SSH public keys for Borgbase
    knownHosts = {
      "*.repo.borgbase.com" = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU0mISTyHBw9tBs6SuhSq8tvNM8m9eifQxM+88TowPO";
      };
    };
  };

  programs.zsh.enable = true;

  services.openssh.enable = true;

  programs.git.enable = true;

  programs.zsh.interactiveShellInit = ''
    # Fix bug on NixOS with up arrow (nixos.wiki/wiki/Zsh)
    bindkey "''${key[Up]}" up-line-or-search
    # Add ssh key
  '';
}

/*
  ssh-add ~/.ssh/ssh_id_ed25519_main@${osConfig.networking.hostName} 1> /dev/null 2>&1
*/
