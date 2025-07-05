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

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    fira-code
    fontconfig
    gcc # GNU Compiler Collection, version 13.2.0 (wrapper script)
    gh # GitHub CLI
    git-crypt
    home-manager
    jq
    lsd
    neovim
    ripgrep
    termimage
    trash-cli
    wl-clipboard # Wayland clipboard utilities, wl-copy and wl-paste

    # Programming language tools (lang servers, formatters, etc.)
    nil
    nixd
    nixpkgs-fmt
    nodePackages.prettier
  ];
  programs.git.enable = true;
  programs.gnupg.agent.enable = true;
  programs.yazi.enable = true;
  programs.zoxide = { enable = true; enableZshIntegration = true; };
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      # Fix bug on NixOS with zsh-autocomplete when pressing up or down arrows (nixos.wiki/wiki/Zsh)
      bindkey "''${key[Up]}" up-line-or-search

      # If bat exists, use instead of cat
      type bat > /dev/null 2>&1 && alias cat=bat

      # If lsd exists, use instead of ls
      type lsd > /dev/null 2>&1 && alias ls=lsd

      # If zoxide exists, use instead of cd
      type zoxide > /dev/null 2>&1 && alias cd=z

      # If ripgrep exists, use instead of grep
      type rg > /dev/null 2>&1 && alias grep=rg

      # If fd exists, use instead of find
      type fd > /dev/null 2>&1 && alias find=fd

      # Accept next word from zsh autosuggestion with Ctrl+U
      bindkey ^U forward-word

      # Disable git pull
      git() { if [[ $@ == "pull" ]]; then command echo "git pull disabled.  Use git fetch + git merge."; else command git "$@"; fi; }
    '';
  };
  environment.shellAliases = {
    l = "ls -lAhF";
    lal = "ls -AhF";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gf = "git fetch";
    gm = "git merge";
    gp = "git push";
    gr = "git rebase";
    hms = "home-manager switch --flake ~/.nix#$(hostname)";
    mise-activate = "eval \"$(~/.local/bin/mise activate zsh)\"";
    nr = "sudo nixos-rebuild switch --flake ~/.nix";
    sauce = "source $HOME/.config/zsh/.zshrc";
    sshk = "kitty +kitten ssh";
    td = "sudo tailscale down";
    te = "sudo tailscale up --exit-node=us-atl-wg-001.mullvad.ts.net --exit-node-allow-lan-access=true --accept-dns=false --operator=$USER";
    tu = "sudo tailscale up --exit-node= --exit-node-allow-lan-access=false --accept-dns=false --operator=$USER";
    ts = "tailscale status";
    v = "nvim";

    # Connect to machines on tailnet
    finserv = "ssh main@$(tailscale status | grep finserv | awk '{print $1}')";
    medserv = "ssh main@$(tailscale status | grep medserv | awk '{print $1}')";
    punk-ubuntu = "ssh main@$(tailscale status | grep punk-ubuntu | awk '{print $1}')";
    sovserv = "ssh main@$(tailscale status | grep sovserv | awk '{print $1}')";
  };

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

  programs.direnv = { enable = true; nix-direnv.enable = true; };
  services.tailscale.enable = true;
  # # There is an outstanding bug with NetworkManager that causes NixOS rebuilds to fail sometimes, this is the workaround.
  # # See https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1658731959
  systemd.services.NetworkManager-wait-online = {
    serviceConfig = {
      ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
    };
  };
  system.stateVersion = "25.05";
  users.users.root.hashedPassword = "!";
  # virtualisa.libvirtd.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
    rootless.setSocketVariable = true;
  };

  ### Auto-update system daily
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--print-build-logs"
    ];
    dates = "12:30";
    randomizedDelaySec = "45min";
  };

  ### Auto-optimize storage
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "03:45" ]; # Optional; allows customizing optimisation schedule
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  ### Run garbage collection if storage is low
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';

}
