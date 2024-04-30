# flake.nix
{
  description = "Jordan's NixOS / Darwin / Home Manager Configuration Flake";

  inputs = {
    # Android packages
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-bitcoin.url = "github:fort-nix/nix-bitcoin/release";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # VSCode / VSCodium extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Manage the system on non-NixOS Linux distros
    # system-manager = {
    #   url = "github:numtide/system-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nix-darwin.url = "github:LnL7/nix-darwin";
    # nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # NixGL for graphics driver issues on non-NixOS
    nixgl.url = "github:guibou/nixGL";
    # Configure Firefox extensions via Home Manager
    # firefox-addons = {
    #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # nixneovim = {
    #   url = "github:nixneovim/nixneovim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixpkgs-python = {
      url = "github:cachix/nixpkgs-python";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixpkgs-py27 = {
    #   url = "github:nixos/nixpkgs/272744825d28f9cea96fe77fe685c8ba2af8eb12"; #python27Packages.virtualenv
    # };
    # nixpkgs-neovim-094.url = "github:nixos/nixpkgs/d44d59d2b5bd694cd9d996fd8c51d03e3e9ba7f7";
    # nixpkgs-nixos-nixd-123.url = "github:nixos/nixpkgs/9a9dae8f6319600fa9aebde37f340975cab4b8c0"; #nixd on NixOS
    # nixpkgs-2311.url = "github:nixos/nixpkgs/23.11"; #nixd on non-NixOS
    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-micro-2-0-12.url = "github:nixos/nixpkgs/a71323f68d4377d12c04a5410e214495ec598d4c";
  };

  outputs =
    { android-nixpkgs
    , home-manager
    , nix-bitcoin
    , nixpkgs
      # , nix-darwin
      # , nixpkgs-darwin
    , nixpkgs-python
      # , nixpkgs-py27
    , nixgl
      # , nixneovim
      # , nixpkgs-neovim-094
      # , nixpkgs-nixos-nixd-123
      # , nixpkgs-2311
    , sops-nix
    , system-manager
    , nixpkgs-micro-2-0-12
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
      # pkgs-2311 = import nixpkgs-2311 {
      #   system = "x86_64-linux";
      # };
      pkgs-micro-2-0-12 = import nixpkgs-micro-2-0-12 {
        system = "x86_64-linux";
      };
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "electron-19.1.9"
          "electron-25.9.0"
          "nodejs_14"
          "nodejs_16"
          "python-2.7.18.7"
          "python-2.7.18.7-env"
        ];
        overlays = [
          nixgl.overlay
          # nixneovim.overlays.default
        ];
      };
      # You can now reference pkgs.nixgl.nixGLIntel
    in
    {
      nixosConfigurations = {
        # Laptops / Desktops
        tux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/tux/configuration.nix
          ];
        };
        carby = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/carby/configuration.nix
            ./nixos/shared/workstation-conf.nix
            # This section uses home-manager as a NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit pkgs inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jordan = import ./home-manager/carby/home.nix;
            }
          ];
        };
        # Servers
        sovserv = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/sovserv/configuration.nix
            ./nixos/shared/server-conf.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit pkgs inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.main = import ./home-manager/sovserv/home.nix;
            }
          ];
        };
        finserv = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/finserv/configuration.nix
            ./nixos/shared/server-conf.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit pkgs inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.main = import ./home-manager/finserv/home.nix;
            }
            nix-bitcoin.nixosModules.default
          ];
        };
      };
      # Home-Manager standalone configurations
      homeConfigurations = {
        carby = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs; # equivalent to: inherit pkgs;
          extraSpecialArgs = { inherit pkgs inputs; };
          modules = [ ./home-manager/carby/home.nix ];
        };
        lenny = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs; # equivalent to: inherit pkgs;
          extraSpecialArgs = { inherit nixgl pkgs inputs; };
          modules = [ ./home-manager/lenny/home.nix ];
        };
        thinky = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs; # equivalent to: inherit pkgs;
          extraSpecialArgs = { inherit nixgl pkgs inputs pkgs-micro-2-0-12; };
          modules = [ ./home-manager/thinky/home.nix ];
        };
        tux = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs; # equivalent to: inherit pkgs;
          extraSpecialArgs = { inherit pkgs inputs; };
          modules = [ ./home-manager/tux/home.nix ];
        };
      };
      # System-Manager (for controlling services and system config on non-NixOS Linux)
      systemConfigs.default = system-manager.lib.makeSystemConfig {
        modules = [
          # ./system-manager
        ];
      };

      # Note: since I no longer have a machine with MacOS, this configuration has gone a long
      # time without any updates.  It likely needs some tweaking before it will work properly.
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
