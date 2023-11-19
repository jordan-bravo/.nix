# ~/.nix/flake.nix
{
  description = "Jordan's NixOS / Darwin / Home Manager Configuration Flake";

  inputs = {
    # All flake references used to build my NixOS setup.  These are dependencies.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # VSCode / VSCodium extensions
    # nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    # Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs:
    # let 
    #   pkgs = import nixpkgs { system = "x86_64-linux"; };
    # in
    {
      nixosConfigurations = {
        tux = nixpkgs.lib.nixosSystem {
          #specialArgs = {inherit inputs;}; # this is the important part for Hyprland
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          # pkgs = import nixpkgs { system = "x86_64-linux"; };
	  # pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./tux/configuration.nix
            #hyprland.nixosModules.default
            #{programs.hyprland.enable = true;}
            #hyprland.homeManagerModules.default
            #{wayland.windowManager.hyprland.enable = true;}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.jordan = {
                imports = [ ./tux/home.nix ];
              };
            }
          ];
        };
      };
      homeConfigurations = {
      	jordan = home-manager.lib.homeManagerConfiguration {
	  pkgs = nixpkgs.legacyPackages.x86_64-linux;
	  modules = [ ./thinky/home.nix ];
	};
      };
      darwinConfigurations = {
        mbp = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./mbp/configuration.nix
            # { nixpkgs.overlays = [ inputs.nixpkgs-firefox-darwin.overlay ]; }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jordan = {
                imports = [ ./mbp/home.nix ];
              };
            }
          ];
        };
      };
    };
}
