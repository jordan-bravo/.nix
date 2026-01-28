{ pkgs, ... }:

{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
    # "QT_STYLE_OVERRIDE" = pkgs.lib.mkForce "adwaita-dark";
    # GTK_THEME = "Adwaita:dark";
    # COSMIC_DATA_CONTROL_ENABLED = 1; # Required for cosmic clipboard manager
  };

  environment.systemPackages = with pkgs; [
    adwaita-qt # Adwaita style for Qt apps
    # gnome-software
    # gnome-tweaks
    ivpn
    ivpn-ui
    qemu
    quickemu
    # grayjay
    # nextcloud-client
    # mullvad-vpn
    steam-run
    zed-editor # High-performance, multiplayer code editor from the creators of Atom and Tree-sitter
  ];

  # services.mullvad-vpn.enable = true;
  # programs.adb.enable = true;

  # Virtual machines
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-intel" ];

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
  services.xserver = {
    # Enable the X11 windowing system.  I think this is required even with Wayland.
    enable = true;
    xkb.layout = "us";
    xkb.options = "caps:escape_shifted_capslock";
  };

  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;

  users.users.jordan = {
    description = "Jordan";
    extraGroups = [
      # "adbusers"
      "docker"
      "libvirtd"
      "qemu-libvirtd"
      "networkmanager"
      "wheel"
    ];
    isNormalUser = true;
    shell = pkgs.zsh; # Set the default shell for this user
  };
  programs.zsh.interactiveShellInit = ''
    # start ssh agent
    eval "$(ssh-agent)" > /dev/null
    # Add ssh key to agent, suppress output
    ssh-add -q ~/.ssh/ssh_id_ed25519_jordan_bravo
  '';

  # programs.ssh.startAgent = true;
  programs.ssh.extraConfig = ''
    ForwardAgent yes
  '';
  # services.gnome.gcr-ssh-agent.enable = false;

  ### Add flathub as flatpak remote
  ### This is not working. Need to figure out how to install
  ### user flatpak instead of system
  # systemd.services.flatpak-repo = {
  #   wantedBy = [ "multi-user.target" ];
  #   path = [ pkgs.flatpak ];
  #   script = ''
  #     flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  #   '';
  # };
  ### Auto-update flatpaks daily
  # Create the systemd service and timer
  systemd.services.flatpak-update = {
    description = "Update Flatpak packages";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.flatpak}/bin/flatpak update -y";
      User = "root"; # Run as root to update system-wide flatpaks
    };
    # Ensure flatpak is available
    path = [ pkgs.flatpak ];
  };

  systemd.timers.flatpak-update = {
    description = "Run Flatpak update daily at noon";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # Set specific time to noon (12:00)
      OnCalendar = "*-*-* 12:00:00";
      # Run missed timers when system comes back online
      Persistent = true;
      # Add some randomization to avoid load spikes
      RandomizedDelaySec = "30m";
    };
  };
}
