# lenny/home.nix

{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home = {
    packages = with pkgs; [
      git # Distributed version control system
      git-crypt # Transparent file encryption in git
      kanata # Tool to improve keyboard comfort and usability with advanced customization
      neovim # Text editor / IDE
      nixgl.nixGLIntel # Helps some Nix packages run on non-NixOS
      udiskie # Removable disk automounter for udisks

      # Neovim dependencies nvim-dep
      delve # Debugger for the Go programming language
      dockerfile-language-server-nodejs # A language server for Dockerfiles # nvim-dep
      emmet-ls # Emmet support based on LSP # nvim-dep
      eslint_d # ESLint daemon for increased performance # nvim-dep
      fzf # nvim-dep
      # gcc # GNU Compiler Collection # nvim-dep # nvim-dep
      # gnumake # A tool to control the generation of non-source files from sources # nvim-dep
      gopls # Official language server for Go / Golang # nvim-dep
      hadolint # Dockerfile Linter JavaScript API # nvim-dep
      lazygit # Simple terminal UI for git commands # nvim-dep
      lua-language-server # LSP language server for Lua # nvim-dep
      luajit # JIT compiler for Lua 5.1 # nvim-dep
      luajitPackages.jsregexp # JavaScript (ECMA19) regular expressions for lua # nvim-dep
      luajitPackages.luacheck # A static analyzer & linter for Lua # nvim-dep
      marksman # Language Server for markdown # nvim-dep
      markdownlint-cli # Command line interface for MarkdownLint
      nil # Nix langauge server # nvim-dep
      nixd # Nix langauge server # nvim-dep
      nixpkgs-fmt # Formatter for Nixlang # nvim-dep
      nodejs_22 # Event-driven I/O framework for the V8 JavaScript engine # nvim-dep
      nodePackages.bash-language-server # A language server for Bash
      nodePackages.eslint # An AST-based pattern checker for JavaScript
      nodePackages.prettier # nvim-dep
      python312Packages.debugpy # Implementation of the Debug Adapter Protocol for Python
      pyright # Python static type checker # nvim-dep
      nodePackages.typescript # nvim-dep
      nodePackages.typescript-language-server # nvim-dep
      prettierd # Prettier daemon for faster formatting # nvim-dep
      # python312 # Python 3.12 # nvim-dep
      rustfmt # Rust formatter # nvim-dep
      ruff # An extremely fast Python linter # nvim-dep
      ruff-lsp # Ruff LSP for Python # nvim-dep
      rust-analyzer # Modular compiler frontend for the Rust language
      stylua # Lua code formatter # nvim-dep
      tailwindcss-language-server # LSP functionality for Tailwind CSS # nvim-dep
      unzip # An extraction utility for archives compressed in .zip format # nvim-dep
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode # nvim-dep
      yaml-language-server # Language Server for YAML Files
    ];
    homeDirectory = "/home/${config.home.username}";
    sessionVariables = {
      GTK_THEME = "Adwaita:dark";
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "24.11";
    username = "jordan";
  };
  imports = [
    ../shared/fuzzel.nix
    ../shared/git.nix
    # ../shared/home.nix
    # ../shared/kanata.nix
    ../shared/kanshi.nix
    ../shared/ripgrep.nix
    # ../shared/workstations.nix
    # ../shared/zellij.nix
    # ../shared/zsh.nix
  ];
  # nixpkgs.config.allowUnfree = true;
  # programs.zsh.profileExtra = ''
  #   export XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"
  # '';
  programs = {
    atuin = {
      enable = true;
      settings = {
        enter_accept = false;
      };
    };
    bash = {
      enable = true;
      enableCompletion = true;
      # bashrcExtra = ''
      #   # Add ssh key, suppress output
      #   ssh-add "$HOME/.ssh/ssh_id_ed25519_jordan@bravo" 1> /dev/null 2>&1
      # '';
      historyControl = [ "erasedups" ];
      shellAliases = {
        gexit = "gnome-session-quit --no-prompt";
        hms = "home-manager switch --flake ~/.nix#$(hostname)";
        jv = "NVIM_APPNAME=jvim nvim";
        jvim = "NVIM_APPNAME=jvim nvim";
        l = "ls -hAlF";
        ll = "ls -hlF";
        la = "ls -hAF";
        mise-activate = "eval \"$(~/.local/bin/mise activate zsh)\"";
        nr = "sudo nixos-rebuild switch --flake ~/.nix";
        s = "git status";
        sc = "v ~/.config/sway/config";
        sshk = "kitty +kitten ssh";
        td = "sudo tailscale down";
        te = "sudo tailscale up --exit-node=us-atl-wg-001.mullvad.ts.net --exit-node-allow-lan-access=true --accept-dns=false --operator=$USER";
        tu = "sudo tailscale up --exit-node= --exit-node-allow-lan-access=false --accept-dns=false --operator=$USER";
        ts = "tailscale status";
        v = "nvim";
        waybarc = "nvim ~/.config/waybar/config.jsonc";
        waybars = "nvim ~/.config/waybar/style.css";
        yubi-add = "ssh-add -s /usr/local/lib/libykcs11.dylib";

        # Connect to machines on tailnet
        medserv = "waypipe ssh main@$(tailscale status | grep medserv | awk '{print $1}')";
        finserv = "waypipe ssh main@$(tailscale status | grep finserv | awk '{print $1}')";
        sovserv = "waypipe ssh main@$(tailscale status | grep sovserv | awk '{print $1}')";
      };
    };
    bat = {
      enable = true;
      config = {
        theme = "Visual Studio Dark+";
      };
    };
    broot.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
    gh.enable = true;
    # gpg.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    lsd.enable = true;
    mise.enable = false;
    # ssh = {
    #   enable = true;
    #   # extraConfig = "IgnoreUnknown AddKeysToAgent,UseKeychain";
    #   addKeysToAgent = "yes";
    #   # extraConfig = ''
    #   #   IdentityFile ~/.ssh/ssh_id_ed25519_jordan_bravo
    #   #   IdentitiesOnly yes
    #   # '';
    # };
    starship = {
      enable = true;
      enableBashIntegration = true;
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
    # yazi = {
    #   enable = true; # disabled because broken by latest update to nixpkgs on Nov 3rd
    #   enableZshIntegration = true;
    # };
    # zoxide = {
    #   enable = true;
    # };
  };
  # programs.zsh.initExtra = ''
  #   # Add ssh key, suppress output
  #   ssh-add "$HOME/.ssh/ssh_id_ed25519_jordan@bravo"
  #   # Mise
  #   # export PATH=$HOME/.local/bin:$PATH
  #   # eval "$(mise activate zsh)"
  # '';

  # services = {
  #   copyq.enable = true;
  # };
  targets.genericLinux.enable = true;
  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
  };
}


