# ~/.nix/mbp/configuration.nix

{ config, pkgs, ... }:

let
  username = "jordan";
  homeDirectory = "/Users/${username}";

in
{
  environment.systemPackages = with pkgs; [
  ];

  networking.hostName = "mbp";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.6"
  ];

  programs.zsh.enable = true;

  services = {
    nix-daemon.enable = true;
    sketchybar = {
      enable = false;
      # config = ''
      #   sketchybar --bar height=24
      #   sketchybar --update
      #   echo "sketchybar configuration loaded..."
      # '';
      # extraPackages = [
      #   # Extra packages to add to PATH
      #   pkgs.jq
      # ];
    };
    skhd = {
      enable = false;
      # package = pkgs.skhd;
      # skhdConfig = ''
      #   # send window to desktop and follow focus
      #   alt + shift - 1 : yabai -m window --space 1; yabai -m space --focus 1
      #   alt + shift - 2 : yabai -m window --space 2; yabai -m space --focus 2
      #   alt + shift - 3 : yabai -m window --space 3; yabai -m space --focus 3
      #   alt + shift - 4 : yabai -m window --space 4; yabai -m space --focus 4
      # '';
    };
    yabai = {
      enable = false;
      enableScriptingAddition = true;
      config = {
        layout = "bsp";
        top_padding = 12;
        right_padding = 12;
        bottom_padding = 12;
        left_padding = 12;
        window_gap = 12;
        window_border = "off";
        window_opacity = "on";
        active_window_opacity = 1.0;
        normal_window_opacity = 0.9;
        # external_bar = all:35:0;
      };
      # extraConfig = ''
      # '';
    };
  };
  # services.nextdns.enable = true; # Research NextDNS DNS/53 to DoH Proxy service.

  system = {
    defaults = {
      dock = {
        autohide = true;
        minimize-to-application = true;
        mru-spaces = false;
        orientation = "left";
        show-recents = false;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 0;
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
      };
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSDocumentSaveNewDocumentsToCloud = false;
      };
      screencapture.location = "${homeDirectory}/Pictures/Screenshots";
      trackpad = {
        Clicking = true;
        Dragging = true;
      };
    };
    stateVersion = 4;
  };

  users.users.${username}.home = homeDirectory;

}
