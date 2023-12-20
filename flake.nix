# ~/.nix/flake.nix
{
  description = "Jordan's NixOS / Darwin / Home Manager Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # VSCode / VSCodium extensions
    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
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
  };

  outputs = { self, nixpkgs, nix-darwin, nixpkgs-darwin, home-manager, nixgl, android-nixpkgs, ... }@inputs:
    let
      pkgs-darwin = import nixpkgs-darwin { system = "aarch64-darwin"; config.allowUnfree = true; };
      pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; config.permittedInsecurePackages = [ "electron-25.9.0" ]; overlays = [ nixgl.overlay ]; };
      # You can now reference pkgs.nixgl.nixGLIntel
    in
    {
      nixosConfigurations = {
        tux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./tux/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit pkgs inputs; };
              home-manager.users.jordan = {
                imports = [ ./tux/home.nix ];
              };
            }
          ];
        };
      };
      homeConfigurations = {
        jordan = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs; # equivalent to: inherit pkgs;
          extraSpecialArgs = { inherit nixgl pkgs inputs; };
          modules = [ ./thinky/home.nix ];
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
