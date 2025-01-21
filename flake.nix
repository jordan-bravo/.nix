# flake.nix
{
  description = "Jordan's NixOS / Darwin / Home Manager Configuration Flake";

  inputs = {
    # Android packages
    # android-nixpkgs = {
    #   url = "github:tadfisher/android-nixpkgs";
    #   inputs.nixpkgs.follows = "nixpkgs-2411";
    # };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    # Lanzaboote enables Secure Boot on NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    lnbits = {
      url = "github:lnbits/lnbits/main";
      # inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    nix-bitcoin.url = "github:fort-nix/nix-bitcoin/";
    nixpkgs-2411.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # VSCode / VSCodium extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    # NixGL for graphics driver issues on non-NixOS
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-2411";
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
    # nixpkgs-py27 = {
    #   url = "github:nixos/nixpkgs/272744825d28f9cea96fe77fe685c8ba2af8eb12"; #python27Packages.virtualenv
    # };
    # nixpkgs-neovim-094.url = "github:nixos/nixpkgs/d44d59d2b5bd694cd9d996fd8c51d03e3e9ba7f7";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    # xremap-flake = {
    #   url = "github:xremap/nix-flake";
    #   inputs.nixpkgs.follows = "nixpkgs-2411";
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
    , nixpkgs-unstable
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
    let
      # pkgs-darwin = import nixpkgs-darwin {
      #   system = "aarch64-darwin";
      #   config.allowUnfree = true;
      # };
      # pkgs-neovim-094 = import nixpkgs-neovim-094 {
      #   system = "x86_64-linux";
      #   config.allowUnfree = true;
      # };
      # pkgs-nixos-nixd-123 = import nixpkgs-nixos-nixd-123 {
      #   system = "x86_64-linux";
      # };
      # pkgs-micro-2-0-12 = import nixpkgs-micro-2-0-12 {
      #   system = "x86_64-linux";
      # };
      pkgs-2411 = import nixpkgs-2411 {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [
          nixgl.overlay
          # nixneovim.overlays.default
        ];
      };
      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          # "nodejs_14"
          # "nodejs_16"
          # "python-2.7.18.7"
          # "python-2.7.18.7-env"
        ];
      };
      # You can now reference pkgs-2411.nixgl.nixGLIntel
    in
    {
      nixosConfigurations = {
        # Workstations (Laptops / Desktops)
        tux = nixpkgs-2411.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs pkgs-unstable pkgs-2411; };
          modules = [
            ./nixos/tux/configuration.nix
            lanzaboote.nixosModules.lanzaboote
            # This section uses home-manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              # home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable/* pkgs-2411 */; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jordan = import ./home-manager/tux/home.nix;
              home-manager.backupFileExtension = "bak";
            }
          ];
        };
        # Servers
        sovserv = nixpkgs-2411.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit pkgs-unstable pkgs-2411 inputs; };
          modules = [
            ./nixos/sovserv/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit pkgs-unstable pkgs-2411 inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.main = import ./home-manager/sovserv/home.nix;
              home-manager.backupFileExtension = "bak";
            }
          ];
        };
        finserv = nixpkgs-2411.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit pkgs-unstable pkgs-2411 inputs; };
          modules = [
            ./nixos/finserv/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit pkgs-unstable pkgs-2411 inputs; };
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
          pkgs = pkgs-2411; # equivalent to: inherit pkgs;
          extraSpecialArgs = { inherit nixgl pkgs-unstable pkgs-2411 inputs; };
          modules = [ ./home-manager/lenny/home.nix ];
        };
        # Lenny is running Ubuntu with Sway
        lenny = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs-2411; # equivalent to: inherit pkgs;
          extraSpecialArgs = { inherit nixgl pkgs-unstable pkgs-2411 inputs; };
          modules = [ ./home-manager/lenny/home.nix ];
        };
      };
      # System-Manager (for controlling services and system config on non-NixOS Linux)
      # Currently not used, need to configure
      systemConfigs = {
        thinky = system-manager.lib.makeSystemConfig {
          modules = [ ./system-manager/thinky/default.nix ];
        };
      };

      # Note: since I no longer have a machine with MacOS, this configuration has gone a long
      # time without any updates.  It is likely needs out of date.
      # darwinConfigurations = {
      #   mbp = nix-darwin.lib.darwinSystem {
      #     system = "aarch64-darwin";
      #     specialArgs = { pkgs = pkgs-darwin; };
      #     modules = [
      #       ./mbp/configuration.nix
      #       home-manager.darwinModules.home-manager
      #       {
      #         home-manager.useGlobalPkgs = true;
      #         home-manager.useUserPackages = true;
      #         home-manager.extraSpecialArgs = { pkgs = pkgs-darwin; };
      #         home-manager.users.jordan = {
      #           imports = [ ./home-manager/mbp/home.nix ];
      #         };
      #       }
      #     ];
      #   };
      # };
    };
}
