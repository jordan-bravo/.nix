# ~/.nix/shared/home.nix

{ config, pkgs, ... }:

let
  username = "jordan";
  homeDirectory =
    if pkgs.stdenv.isDarwin then
      "/Users/${username}"
    else
      "/home/${username}";
in
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
      killall # Tool to kill processes
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
      procs # A modern replacement for ps written in Rust
      scc # Code counter with complexity calculations and COCOMO estimates written in Go
      sd # Intuitive find & replace CLI (sed alternative)
      speedtest-go # CLI and Go API to Test Internet Speed using speedtest.net
      speedtest-rs # Command line internet speedtest tool written in rust
      steam-run # Run commands in the same FHS environment that is used for Steam
      trash-cli # Command line interface to the freedesktop.org trash can
      # trashy # CLI trash tool written in Rust # Note: currently has a bug that breaks tab completion
      tree # View directory tree structure
      vim
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
      gcc # GNU Compiler Collection # nvim-dep # nvim-dep
      gnumake # A tool to control the generation of non-source files from sources # nvim-dep
      gopls # Official language server for Go / Golang # nvim-dep
      lazygit # Simple terminal UI for git commands # nvim-dep
      lua-language-server # LSP language server for Lua # nvim-dep
      luajit # JIT compiler for Lua 5.1 # nvim-dep
      luajitPackages.jsregexp # JavaScript (ECMA19) regular expressions for lua # nvim-dep
      luajitPackages.luacheck # A static analyzer & linter for Lua # nvim-dep
      nodePackages.pyright # Python static type checker
      prettierd # Prettier daemon for faster formatting
      rustfmt # Rust formatter # nvim-dep
      ruff # An extremely fast Python linter # nvim-dep
      ruff-lsp # Ruff LSP for Python #nvim-dep
      stylua # Lua code formatter
      tailwindcss-language-server # LSP functionality for Tailwind CSS
      unzip # An extraction utility for archives compressed in .zip format
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode

      # vimPlugins
      # vimPlugins.nvim-dap
      # vimPlugins.nvim-dap-ui
      # vimPlugins.nvim-dap-python
      # vimPlugins.nvim-dap-go
      # vimPlugins.nvim-dap-virtual-text
      # vimPlugins.telescope-dap-nvim



      # Packages for building Python
      # automake # GNU standard-compliant makefile generator
      # bzip2 # High-quality data compression program
      # findutils # GNU Find Utilities, the basic directory searching utilities of the GNU operating system
      # gdbm # GNU dbm key/value database library
      # libffi # A foreign function call interface library
      # libnsl # Client interface library for NIS(YP) and NIS+
      # libuuid # A set of system utilities for Linux
      # ncurses # Free software emulation of curses in SVR4 and more
      # openssl # A cryptographic library that implements the SSL and TLS protocols
      # gnupatch # GNU Patch, a program to apply differences to files
      # readline # Library for interactive line editing
      # sqlite # A self-contained, serverless, zero-configuration, transactional SQL database engine
      # tk # A widget toolkit that provides a library of basic elements for building a GUI in many different programming languages
      # xz # A general-purpose data compression software, successor of LZMA
      # zlib # For building Python

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


  # Programs with little to no config are enabled here. 
  programs = {
    bat.enable = true;
    broot = {
      enable = true;
      enableZshIntegration = true;
    };
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
    # pyenv = {
    #   enable = false;
    #   # To manually activate pyenv in zsh, use the command:
    #   # eval "$(pyenv init -)"
    #   enableZshIntegration = false;
    #   rootDirectory = "${config.xdg.dataHome}/pyenv";
    # };
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
    configHome = "${homeDirectory}/.config";
  };

}
