{
  imports = [
    ./kitty.nix
    ./workstation-secrets.nix
  ];

  services.copyq.enable = true;
}
