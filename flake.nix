# ~/.nix/flake.nix
{
  description = "Jordan's NixOS / Darwin / Home Manager Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # VSCode / VSCodium extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # NixGL for graphics driver issues on non-NixOS
    nixgl.url = "github:guibou/nixGL";
    # Configure Firefox extensions via Home Manager
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Android packages
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixneovim = {
      url = "github:nixneovim/nixneovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-python = {
      url = "github:cachix/nixpkgs-python";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-py27 = {
      url = "github:nixos/nixpkgs/272744825d28f9cea96fe77fe685c8ba2af8eb12"; #python27Packages.virtualenv
    };
  };

  outputs =
    { home-manager
    , nixpkgs
    , nix-darwin
    , nixpkgs-darwin
    , nixpkgs-python
    , nixpkgs-py27
    , nixgl
    , android-nixpkgs
    , nixneovim
    , ...
    }@inputs:
    let
      pkgs-darwin = import nixpkgs-darwin {
        system = "aarch64-darwin";
        config.allowUnfree = true;
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
          nixneovim.overlays.default
        ];
      };
      # You can now reference pkgs.nixgl.nixGLIntel
    in
    {
      nixosConfigurations = {
        tux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./tux/configuration.nix
          ];
        };
      };
      homeConfigurations = {
        tux = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs; # equivalent to: inherit pkgs;
          extraSpecialArgs = { inherit pkgs inputs; };
          modules = [ ./tux/home.nix ];
        };
        thinky = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs; # equivalent to: inherit pkgs;
          extraSpecialArgs = { inherit nixgl pkgs inputs; };
          modules = [ ./thinky/home.nix ];
        };
        lenny = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs; # equivalent to: inherit pkgs;
          extraSpecialArgs = { inherit nixgl pkgs inputs; };
          modules = [ ./lenny/home.nix ];
        };
      };
      darwinConfigurations = {
        mbp = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { pkgs = pkgs-darwin; };
          modules = [
            ./mbp/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { pkgs = pkgs-darwin; };
              home-manager.users.jordan = {
                imports = [ ./mbp/home.nix ];
              };
            }
          ];
        };
      };
    };
}
