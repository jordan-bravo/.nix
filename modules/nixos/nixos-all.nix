{ pkgs, inputs, ... }:

{
  # According to home-manager docs for programs.zsh.enableCompletion, adding the following
  # line enables completion for system packages (e.g. systemd)
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  time.timeZone = "America/New_York";
  networking = {
    # enableIPv6 = false;
    firewall.checkReversePath = "loose"; # This is required for Tailscale exit node to work
    # nameservers = [ "9.9.9.9" "149.112.112.112" ]; # Quad9
    networkmanager = {
      enable = true;
      # dns = "none";
    };
  };
  # boot.kernelParams = [ "ipv6.disable=1" ];
  boot.loader.systemd-boot.configurationLimit = 8;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  environment.systemPackages = with pkgs; [
    claude-code
    doggo # Replacement for dig
    duf # Disk Usage/Free Utility
    dust # du + rust = dust. Like du but more intuitive
    fd # Simple, fast and user-friendly alternative to find
    fira-code
    fontconfig
    gcc # GNU Compiler Collection, version 13.2.0 (wrapper script)
    gh # GitHub CLI
    git-crypt
    home-manager
    host # Resolve domain names to ip addresses and vice versa
    jq # JSON parsing
    lsd # Next gen ls command
    neovim
    ripgrep # Alternative to grep
    speedtest-go
    # termimage # Display images in your terminal
    trash-cli
    tre-command # Tree command, improved
    wl-clipboard # Wayland clipboard utilities, wl-copy and wl-paste

    # Programming language tools (lang servers, formatters, etc.)
    nil
    nixd
    nixfmt
    prettier
  ];
  programs.git.enable = true;
  programs.gnupg.agent.enable = true;
  programs.yazi.enable = true;
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      # Fix bug on NixOS with zsh-autocomplete when pressing up or down arrows (nixos.wiki/wiki/Zsh)
      bindkey "''${key[Up]}" up-line-or-search

      ${builtins.readFile ../zsh-init.sh}
    '';
  };
  environment.shellAliases = import ../shell-aliases.nix;
  programs.starship = {
    enable = true;
    settings = {
      directory = {
        truncation_length = 8;
        truncation_symbol = ".../";
        repo_root_style = "purple";
      };
      gcloud = {
        disabled = true;
      };
    };
  };
  programs.bat = {
    enable = true;
    settings.theme = "\"Visual Studio Dark+\"";
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
  services.tailscale.enable = true;
  # There is an outstanding bug with NetworkManager that causes NixOS rebuilds to fail sometimes, this is the workaround.
  # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1658731959
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.networkmanager}/bin/nm-online -q"
      ];
    };
  };
  system.stateVersion = "25.05";
  users.users.root.hashedPassword = "!";
  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
    rootless.setSocketVariable = true;
  };

  ### Auto-upgrades disabled (2026-07-13): upgrades are fully manual.
  # The upgrade mechanism is: `nix flake update` + commit + rebuild each host.
  # autoUpgrade used to run daily with --update-input nixpkgs, which upgraded
  # the running system past the repo's flake.lock; a later manual rebuild then
  # jumped *backwards* to the committed pin, and on workstations that large
  # delta restarted the GNOME user units and tore down the live session
  # (happened on tux 2026-07-12/13). Without --update-input the timer would
  # only rebuild the already-running generation, so it is pointless — hence
  # disabled rather than kept as a weekly no-op.
  # system.autoUpgrade = {
  #   enable = true;
  #   flake = inputs.self.outPath;
  #   flags = [
  #     "--print-build-logs"
  #   ];
  #   dates = "Sat 09:00";
  #   randomizedDelaySec = "45min";
  # };

  ### Auto-optimize storage
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ]; # Optional; allows customizing optimisation schedule
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  # Run garbage collection if storage is low
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

}
