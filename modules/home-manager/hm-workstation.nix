{
  imports = [
    ./kitty.nix
    ./wezterm.nix
    ./workstation-secrets.nix
  ];

  services.copyq.enable = true;
}
