# ~/.nix/mbp/configuration.nix

{ config, pkgs, ... }:

let
  username = "jordan";
  homeDirectory = "/Users/${username}";

in
{
  environment.systemPackages = with pkgs; [
    # firefox
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
    yabai = {
      enable = false;
      # config = {
      #   
      # };
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
