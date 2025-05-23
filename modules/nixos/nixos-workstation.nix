{ pkgs, ... }:

{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
    # "QT_STYLE_OVERRIDE" = pkgs.lib.mkForce "adwaita-dark";
    GTK_THEME = "Adwaita:dark";
  };

  environment.systemPackages = with pkgs; [
    # adwaita-qt # Adwaita style for Qt apps
    gnome-tweaks
    nextcloud-client
    mullvad-vpn
    zed-editor # High-performance, multiplayer code editor from the creators of Atom and Tree-sitter
  ];

  services.mullvad-vpn.enable = true;
  programs.adb.enable = true;
  programs.virt-manager.enable = true;

  security.rtkit.enable = true;

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.flatpak.enable = true;
  services.printing.enable = true;
  services.tailscale.enable = true;
  services.xserver = {
    # Enable the X11 windowing system.  I think this is required even with Wayland.
    enable = true;
    xkb.layout = "us";
    xkb.options = "caps:escape_shifted_capslock";
  };

  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;

  users.users.jordan = {
    description = "Jordan";
    extraGroups = [ "adbusers" "docker" "libvirtd" "networkmanager" "wheel" ];
    isNormalUser = true;
    shell = pkgs.zsh; # Set the default shell for this user
  };
  programs.zsh.interactiveShellInit = ''
    # Add ssh key, suppress output
    ssh-add "$HOME/.ssh/ssh_id_ed25519_jordan" 1> /dev/null 2>&1
  '';
}
