# nixos/shared/workstation-conf.nix

{ pkgs, ... }:

{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
    # "QT_STYLE_OVERRIDE" = pkgs.lib.mkForce "adwaita-dark";
  };

  programs = {
    adb.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;
  };

  security.rtkit.enable = true;

  services = {
    flatpak.enable = true;
    # mullvad-vpn.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    printing.enable = true;
    tailscale.enable = true;
    xserver = {
      # Enable the X11 windowing system.  I think this is required even with Wayland.
      enable = true;
      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      # Enable the KDE Plasma Desktop Environment.
      # displayManager.sddm.enable = true;
      # desktopManager.plasma5.enable = true;
    };
  };

  users.users.jordan = {
    description = "jordan";
    extraGroups = [ "adbusers" "docker" "libvirtd" "networkmanager" "wheel" ];
    isNormalUser = true;
    packages = with pkgs; [
      home-manager
    ];
    shell = pkgs.zsh; # Set the default shell for this user
  };
}

