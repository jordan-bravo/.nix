{
  imports = [
    ../../modules/home-manager/hm-all.nix
    ../../modules/home-manager/hm-workstation.nix
  ];

  services.trayscale.enable = true;
}
