{
  imports = [
    # ./wezterm.nix
    ./workstation-secrets.nix
    ./kitty.nix
  ];

  services.copyq.enable = true;
}
