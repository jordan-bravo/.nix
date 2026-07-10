{
  imports = [
    # ./wezterm.nix
    ./workstation-secrets.nix
    ./kitty.nix
    ./flatpak.nix
  ];

  services.copyq.enable = true;
}
