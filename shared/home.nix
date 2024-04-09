# shared/home.nix

{ config, pkgs, ... }:

# let
#   username = "jordan";
#   homeDirectory =
#     if pkgs.stdenv.isDarwin then
#       "/Users/${username}"
#     else
#       "/home/${username}";
# in
{
  fonts.fontconfig.enable = true;
  home = {
    file = {
      # This is here for syntax reference.
      example-file = {
        target = ".config/example-file/config.yml";
        enable = false;
        text = ''
          Example:
            Your text goes here
        '';
      };
      lazygit-config = {
        target = ".config/lazygit/config.yml";
        enable = true;
        text = ''
          keybinding:
            universal:
              pullFiles: null
        '';
      };
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = with pkgs; [
      age # (Actually Good Encryption) A modern encryption tool with small explicit keys
      bottom # A cross-platform graphical process/system monitor with a customizable interface
      cargo # Rust package manager
      # dbeaver # SQL database client
      delta # A syntax-highlighting pager for git
      distrobox # Run containers of any Linux distro
      docker-compose # Docker Compose plugin for Docker
      dogdns # Command-line DNS client
      du-dust # du + rust = dust. Like du but more intuitive
      duf # Disk Usage/Free Utility, a df alternative
      # emmet-ls # Emmet support based on LSP
      fd # A simple, fast and user-friendly alternative to find
      fira-code # Font
      gitui # Blazing fast terminal-ui for Git written in Rust
      go # The Go / Golang programming language
      hyprpaper # Hyprland wallpaper program
      killall # Tool to kill processes
      kitty # Terminal emulator
      lsof # A tool to list open files
      # mise # (formerly rtx) Runtime/environment manager
      neofetch # Show system info
      neovim # Text editor / IDE
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      nixpkgs-fmt # Formatter for Nixlang
      # nodePackages.eslint # An AST-based pattern checker for JavaScript
      nodePackages.pnpm # Fast, disk space efficient package manager
      # nodePackages.prettier # Formatter for JavaScript and other languages
      # nodePackages.typescript # TypeScript language
      # nodePackages.typescript-language-server # LSP for JS and TS
      onefetch # Git repo summary
      # pgcli # Command-line interface for PostgreSQL
      pkg-config # Required for borg mount
      procs # A modern replacement for ps written in Rust
      scc # Code counter with complexity calculations and COCOMO estimates written in Go
      sd # Intuitive find & replace CLI (sed alternative)
      sops # Secrets OPerationS
      speedtest-go # CLI and Go API to Test Internet Speed using speedtest.net
      speedtest-rs # Command line internet speedtest tool written in rust
      steam-run # Run commands in the same FHS environment that is used for Steam
      trash-cli # Command line interface to the freedesktop.org trash can
      # trashy # CLI trash tool written in Rust # Note: currently has a bug that breaks tab completion
      tree # View directory tree structure
      vlock # Lock the TTY screen
      watchman # Watches files and takes action when they change
      waypipe # A network proxy for Wayland clients (applications)
      wget # File retriever
      xh # Friendly and fast tool for sending HTTP requests
      wl-clipboard # Wayland clipboard utilities, wl-copy and wl-paste
      yarn # Package manager for JavaScript
      yt-dlp # CLI tool to download YouTube videos
      zellij # Terminal multiplexer

      # Neovim/Lazyvim dependencies nvim-dep
      eslint_d # ESLint daemon for increased performance
      fzf # nvim-dep
      gcc # GNU Compiler Collection # nvim-dep # nvim-dep
      gnumake # A tool to control the generation of non-source files from sources # nvim-dep
      gopls # Official language server for Go / Golang # nvim-dep
      lazygit # Simple terminal UI for git commands # nvim-dep
      lua-language-server # LSP language server for Lua # nvim-dep
      luajit # JIT compiler for Lua 5.1 # nvim-dep
      luajitPackages.jsregexp # JavaScript (ECMA19) regular expressions for lua # nvim-dep
      luajitPackages.luacheck # A static analyzer & linter for Lua # nvim-dep
      nixd # Nix langauge server # nvim-dep
      nixpkgs-fmt # nvim-dep
      nodePackages.prettier # nvim-dep
      nodePackages.pyright # Python static type checker
      nodePackages.typescript # nvim-dep
      nodePackages.typescript-language-server # nvim-dep
      prettierd # Prettier daemon for faster formatting # nvim-dep
      python312 # Python 3.12 # nvim-dep
      rustfmt # Rust formatter # nvim-dep
      ruff # An extremely fast Python linter # nvim-dep
      ruff-lsp # Ruff LSP for Python # nvim-dep
      stylua # Lua code formatter # nvim-dep
      tailwindcss-language-server # LSP functionality for Tailwind CSS # nvim-dep
      unzip # An extraction utility for archives compressed in .zip format # nvim-dep
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode # nvim-dep

      # vimPlugins
      # vimPlugins.nvim-dap
      # vimPlugins.nvim-dap-ui
      # vimPlugins.nvim-dap-python
      # vimPlugins.nvim-dap-go
      # vimPlugins.nvim-dap-virtual-text
      # vimPlugins.telescope-dap-nvim

      # pkgs-neovim-094.neovim
    ];
  };

  # Programs with more extensive config are imported from separate modules.
  imports = [
    ../shared/git.nix
    ../shared/neovim.nix
    ../shared/ripgrep.nix
    ../shared/zellij.nix
    ../shared/zsh.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Programs with little to no config are enabled here. 
  programs = {
    atuin.enable = true;
    bat.enable = true;
    broot.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
    fzf.enable = false;
    gh.enable = true;
    gpg.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    lsd.enable = true;
    mise.enable = true;
    ssh = {
      enable = true;
      extraConfig = "IgnoreUnknown AddKeysToAgent,UseKeychain";
    };
    starship = {
      enable = true;
      settings = {
        directory = {
          truncate_to_repo = false;
        };
        gcloud = {
          disabled = true;
        };
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
  };

}
