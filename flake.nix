{
  description = "Jordan's NixOS & Home Manager Configuration Flake";

  inputs = {
    # Android packages
    # android-nixpkgs = {
    #   url = "github:tadfisher/android-nixpkgs";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Lanzaboote enables Secure Boot on NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # This is the nix-bitcoin branch you normally want
    # nix-bitcoin.url = "github:fort-nix/nix-bitcoin/release";
    # This is the branch to use temporarily until the releaes branch is up-to-date
    nix-bitcoin.url = "github:fort-nix/nix-bitcoin/master";
    # Declarative flatpak management (remotes, apps, overrides, auto-update)
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    # NixGL for graphics driver issues on non-NixOS
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-python = {
    #   url = "github:cachix/nixpkgs-python";
    #   # inputs.nixpkgs.follows = "nixpkgs-2411";
    # };
    # nixpkgs-node18.url = "github.com/nixos/nixpkgs/507b63021ada5fee621b6ca371c4fca9ca46f52c";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # xremap-flake = {
    #   url = "github:xremap/nix-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nixpkgs-micro-2-0-12.url = "github:nixos/nixpkgs/a71323f68d4377d12c04a5410e214495ec598d4c";
  };

  outputs =
    {
      nixpkgs,
      disko,
      home-manager,
      # , lanzaboote
      nix-bitcoin,
      nixgl,
      # , nixpkgs-node18
      sops-nix,
      system-manager,
      ...
    }@inputs:
    let
      # Example of pinning a package version
      # pkgs-micro-2-0-12 = import nixpkgs-micro-2-0-12 {
      #   system = "x86_64-linux";
      # };
      pkgs = import nixpkgs {
        localSystem = "x86_64-linux";
        overlays = [ nixgl.overlay ];
        # You can now reference pkgs.nixgl.nixGLIntel
      };
    in
    {
      nixosConfigurations = {
        # Workstations (Laptops / Desktops)
        tux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs sops-nix; };
          modules = [
            ./hosts/tux/configuration.nix
            # lanzaboote.nixosModules.lanzaboote
            # This section uses home-manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              # home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
              home-manager.users.jordan = import ./hosts/tux/home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
        ryz = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs sops-nix; };
          modules = [
            ./hosts/ryz/configuration.nix
            # lanzaboote.nixosModules.lanzaboote
            # This section uses home-manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              # home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];
              home-manager.users.jordan = import ./hosts/ryz/home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
        # Servers
        sovserv = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/sovserv/configuration.nix
            home-manager.nixosModules.home-manager
            {
              # home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.main = import ./hosts/sovserv/home.nix;
              home-manager.backupFileExtension = "backup";
            }
            sops-nix.nixosModules.sops
          ];
        };
        finserv = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/finserv/configuration.nix
            home-manager.nixosModules.home-manager
            {
              # home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.main = import ./hosts/finserv/home.nix;
            }
            nix-bitcoin.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        punk = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/punk/configuration.nix
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              # home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.main = import ./hosts/punk/home.nix;
            }
            sops-nix.nixosModules.sops
          ];
        };
        # nixos-anywhere target machine
        # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hosts/generic/hardware-configuration.nix root@<host-ip-address>
        # generic = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [
        #     disko.nixosModules.disko
        #     ./hosts/generic/configuration.nix
        #     ./hosts/generic/hardware-configuration.nix
        #   ];
        # };

      };
      # Home-Manager standalone configurations
      homeConfigurations = {
        # Pine is running Pop!_OS with COSMIC desktop
        pine = home-manager.lib.homeManagerConfiguration {
          inherit pkgs; # equivalent to pkgs = pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            ./hosts/pine/home.nix
          ];
        };
        # Tuf is running Fedora with COSMIC desktop
        tuf = home-manager.lib.homeManagerConfiguration {
          inherit pkgs; # equivalent to pkgs = pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            inputs.nix-flatpak.homeManagerModules.nix-flatpak
            ./hosts/tuf/home.nix
          ];
        };
      };
      # System-Manager (for controlling services and system config on non-NixOS Linux)
      # Currently not used, need to configure
      systemConfigs = {
        pine = system-manager.lib.makeSystemConfig {
          modules = [ ./system-manager/pine/default.nix ];
        };
      };
    };
}
