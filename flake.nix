{
  description = "Jordan's NixOS & Home Manager Configuration Flake";

  inputs = {
    # Android packages
    # android-nixpkgs = {
    #   url = "github:tadfisher/android-nixpkgs";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    disko = {
      url = "github:nix-commumity/disko";
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
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sparrow-nixpkgs.url = "github:nixos/nixpkgs/bdac72d387dca7f836f6ef1fe547755fb0e9df61"; # bdac72d387dca7f836f6ef1fe547755fb0e9df61
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
    { nixpkgs
    , disko
    , home-manager
      # , lanzaboote
    , nix-bitcoin
    , nixgl
    , sops-nix
    , sparrow-nixpkgs
    , system-manager
    , ...
    }@inputs:
    let
      /*
       * Example of pinning a package version
       */
      # pkgs-micro-2-0-12 = import nixpkgs-micro-2-0-12 {
      #   system = "x86_64-linux";
      # };
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixgl.overlay ];
        # You can now reference pkgs.nixgl.nixGLIntel
      };
      sparrow-pkgs = import sparrow-nixpkgs { system = "x86_64-linux"; };
    in
    {
      nixosConfigurations = {
        # Workstations (Laptops / Desktops)
        tux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs sparrow-pkgs; };
          modules = [
            ./hosts/tux/configuration.nix
            # lanzaboote.nixosModules.lanzaboote
            /*
              This section uses home-manager as a NixOS module
            */
            home-manager.nixosModules.home-manager
            {
              # home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jordan = import ./hosts/tux/home.nix;
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
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.main = import ./hosts/sovserv/home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
        finserv = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/finserv/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.main = import ./hosts/finserv/home.nix;
            }
            nix-bitcoin.nixosModules.default
          ];
        };
        punk = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # specialArgs = { inherit inputs; };
          modules = [
            ./hosts/punk/configuration.nix
            # home-manager.nixosModules.home-manager
            # {
            #   home-manager.extraSpecialArgs = { inherit inputs; };
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.users.main = import ./hosts/punk/home.nix;
            # }
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
        # Thinky is running Ubuntu with Sway
        thinky = home-manager.lib.homeManagerConfiguration {
          # pkgs = nixpkgs.legacyPackages."x86_64-linux";
          inherit pkgs; # equivalent to pkgs = pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./hosts/thinky/home.nix ];
        };
      };
      # System-Manager (for controlling services and system config on non-NixOS Linux)
      # Currently not used, need to configure
      systemConfigs = {
        thinky = system-manager.lib.makeSystemConfig {
          modules = [ ./system-manager/thinky/default.nix ];
        };
      };
    };
}
