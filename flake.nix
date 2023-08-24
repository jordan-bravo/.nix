# ~/.setup/flake.nix
{
  description = "Jordan's NixOS / Darwin / Home Manager Configuration Flake";

  inputs = {
    # All flake references used to build my NixOS setup.  These are dependencies.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Nix packages
    # Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    #hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }:
    {
      nixosConfigurations = {
        tux = nixpkgs.lib.nixosSystem {
          #specialArgs = {inherit inputs;}; # this is the important part for Hyprland
          system = "x86_64-linux";
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
              home-manager.users.jordan = {
                imports = [ ./tux/home.nix ];
              };
            }
          ];
        };
      };
      darwinConfigurations = {
        mbp = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./mbp/configuration.nix
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
