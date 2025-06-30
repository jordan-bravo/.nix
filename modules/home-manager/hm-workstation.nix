{
  home.stateVersion = "25.05";

  imports = [
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/kitty.nix
    ../../modules/home-manager/ripgrep.nix
  ];

  services.copyq.enable = true;
}
