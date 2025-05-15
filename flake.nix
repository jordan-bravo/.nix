{
  description = "Jordan's NixOS & Home Manager Configuration Flake";

  inputs = {
    # Android packages
    # android-nixpkgs = {
    #   url = "github:tadfisher/android-nixpkgs";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Lanzaboote enables Secure Boot on NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lnbits = {
      url = "github:lnbits/lnbits/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-bitcoin.url = "github:fort-nix/nix-bitcoin/release";
    nixpkgs-2411.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # VSCode / VSCodium extensions
    # nix-vscode-extensions = {
    #   url = "github:nix-community/nix-vscode-extensions";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # NixGL for graphics driver issues on non-NixOS
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Configure Firefox extensions via Home Manager
    # firefox-addons = {
    #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #   inputs.nixpkgs.follows = "nixpkgs-2411";
    # };
    # nixneovim = {
    #   url = "github:nixneovim/nixneovim";
    #   inputs.nixpkgs.follows = "nixpkgs-2411";
    # };
    # nixpkgs-python = {
    #   url = "github:cachix/nixpkgs-python";
    #   # inputs.nixpkgs.follows = "nixpkgs-2411";
    # };
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
      # android-nixpkgs,
      home-manager
    , lanzaboote
    , lnbits
    , nix-bitcoin
    , nixpkgs-2411
    , nixpkgs
      # , nixpkgs-python
      # , nixpkgs-py27
    , nixgl
      # , nixneovim
      # , nixpkgs-neovim-094
      # , nixpkgs-nixos-nixd-123
    , sops-nix
    , system-manager
      # , xremap-flake
      # , nixpkgs-micro-2-0-12
    , ...
    }@inputs:
    # let
    #   /*
    #    * Example of pinning a package version
    #    */
    #   # pkgs-micro-2-0-12 = import nixpkgs-micro-2-0-12 {
    #   #   system = "x86_64-linux";
    #   # };
    #   # uncomment this next line if servers need pkgs arg for home-manager
    #   # pkgs = nixpkgs.legacyPackages."x86_64-linux";
    #   pkgs = import nixpkgs {
    #     system = "x86_64-linux";
    #     overlays = [ nixgl.overlay ];
    #     # You can now reference pkgs.nixgl.nixGLIntel
    #   };
    # in
    {
      nixosConfigurations = {
        # Workstations (Laptops / Desktops)
        tux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # specialArgs = { inherit inputs pkgs-2411; };
          modules = [
            ./nixos/tux/configuration.nix
            # lanzaboote.nixosModules.lanzaboote
            /*
              This section uses home-manager as a NixOS module
            */
            home-manager.nixosModules.home-manager
            {
              # home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jordan = import ./home-manager/tux/home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
        # Servers
        sovserv = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/sovserv/configuration.nix
            # home-manager.nixosModules.home-manager
            # {
            #   home-manager.extraSpecialArgs = { inherit inputs; };
            #   home-manager.useGlobalPkgs = true;
            #   home-manager.useUserPackages = true;
            #   home-manager.users.main = import ./home-manager/sovserv/home.nix;
            #   home-manager.backupFileExtension = "backup";
            # }
          ];
        };
        finserv = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/finserv/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.main = import ./home-manager/finserv/home.nix;
            }
            nix-bitcoin.nixosModules.default
            lnbits.nixosModules.default
          ];
        };
      };
      # Home-Manager standalone configurations
      homeConfigurations = {
        # Thinky is running Ubuntu with Sway
        thinky = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home-manager/thinky/home.nix ];
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
