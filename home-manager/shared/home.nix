# shared/home.nix

{ config, pkgs, ... }:

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
          git:
            paging:
              pager: delta
        '';
      };
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "25.05";
    packages = with pkgs; [
      # act # Run your GitHub Actions locally
      # aerc # An email client for your terminal
      # age # (Actually Good Encryption) A modern encryption tool with small explicit keys
      # asciiquarium # Enjoy the mysteries of the sea from the safety of your own terminal!
      # bitwarden-cli # Secure and free password manager for all of your devices
      # bottom # A cross-platform graphical process/system monitor with a customizable interface
      # browsh # Fully-modern text-based browser, rendering to TTY and browsers
      # busybox # Tiny versions of common UNIX utilities in a single small executable
      # cargo # Rust package manager
      # dante # Circuit-level SOCKS client/server that can be used to provide convenient and secure network connectivity # aerc-dep
      delta # A syntax-highlighting pager for git
      # dhcping # Send DHCP request to find out if a DHCP server is running
      dig # DNS tool
      distrobox # Run containers of any Linux distro
      docker-compose # Docker Compose plugin for Docker
      dogdns # Command-line DNS client
      # drawio # Diagram application
      du-dust # aka dust. du + rust = dust. Like du but more intuitive
      duf # Disk Usage/Free Utility, a df alternative
      fd # A simple, fast and user-friendly alternative to find
      ffmpeg # A complete, cross-platform solution to record, convert and stream audio and video
      fastfetch # Like neofetch, but much faster because written in C
      git-crypt # Transparent file encryption in git
      gitui # Blazing fast terminal-ui for Git written in Rust
      # glow # Render markdown on the CLI, with pizzazz!
      gnome-multi-writer # Tool for writing an ISO file to multiple USB devices at once
      # go # The Go / Golang programming language
      # httpie # Command line HTTP client whose goal is to make CLI human-friendly
      # ivpn # VPN GUI
      # killall # Tool to kill processes
      # kitty # Terminal emulator
      lsof # A tool to list open files
      neovim # Text editor / IDE
      # nix-index # A files database for nixpkgs
      # nix-search-cli # Search packages from the command line
      nodePackages.pnpm # Fast, disk space efficient package manager
      onefetch # Git repo summary
      # pass # Stores, retrieves, generates, and synchronizes passwords securely
      # pipx # Install and run Python applications in isolated environments
      # pgcli # Command-line interface for PostgreSQL
      procs # A modern replacement for ps written in Rust
      protobuf # Google's data interchange format. lndk build dependency.
      # pyenv # Simple Python version management
      # quarto # Open-source scientific and technical publishing system built on Pandoc
      # scc # Code counter with complexity calculations and COCOMO estimates written in Go
      # sad # CLI tool to search and replace
      sd # Intuitive find & replace CLI (sed alternative)
      sops # Secrets OPerationS
      speedtest-go # CLI and Go API to Test Internet Speed using speedtest.net
      # speedtest-rs # Command line internet speedtest tool written in rust
      # steam-run # Run commands in the same FHS environment that is used for Steam
      trash-cli # Command line interface to the freedesktop.org trash can
      # trashy # CLI trash tool written in Rust # Note: currently has a bug that breaks tab completion
      tree # View directory tree structure
      # uv # Extremely fast Python package installer and resolver, written in Rust
      vlock # Lock the TTY screen
      # watchman # Watches files and takes action when they change
      waypipe # A network proxy for Wayland clients (applications)
      # wget # File retriever
      # xh # Friendly and fast tool for sending HTTP requests
      # w3m # Text-mode web browser # aerc-dep
      # wl-clipboard # Wayland clipboard utilities, wl-copy and wl-paste
      # yarn # Package manager for JavaScript
      yt-dlp # CLI tool to download YouTube videos
      zellij # Terminal multiplexer
      # zola # A fast static site generator with everything built-in

      # Neovim dependencies nvim-dep
      # basedpyright # Type checker for the Python language
      # delve # Debugger for the Go programming language
      # dockerfile-language-server-nodejs # A language server for Dockerfiles # nvim-dep
      # emmet-ls # Emmet support based on LSP # nvim-dep
      # eslint_d # ESLint daemon for increased performance # nvim-dep
      # fzf # nvim-dep
      # gcc # GNU Compiler Collection # nvim-dep # nvim-dep
      # gnumake # A tool to control the generation of non-source files from sources # nvim-dep
      # gopls # Official language server for Go / Golang # nvim-dep
      # hadolint # Dockerfile Linter JavaScript API # nvim-dep
      # lazygit # Simple terminal UI for git commands # nvim-dep
      # lua-language-server # LSP language server for Lua # nvim-dep
      # luajit # JIT compiler for Lua 5.1 # nvim-dep
      # luajitPackages.jsregexp # JavaScript (ECMA19) regular expressions for lua # nvim-dep
      # luajitPackages.luacheck # A static analyzer & linter for Lua # nvim-dep
      # marksman # Language Server for markdown # nvim-dep
      # markdownlint-cli # Command line interface for MarkdownLint
      # nil # Nix langauge server # nvim-dep
      # nixd # Nix langauge server # nvim-dep
      # nixpkgs-fmt # Formatter for Nixlang # nvim-dep
      # nodejs_22 # Event-driven I/O framework for the V8 JavaScript engine # nvim-dep
      # nodePackages.bash-language-server # A language server for Bash
      # nodePackages.eslint # An AST-based pattern checker for JavaScript
      # nodePackages.prettier # nvim-dep
      # python312Packages.debugpy # Implementation of the Debug Adapter Protocol for Python
      # pyright # Python static type checker # nvim-dep
      # nodePackages.typescript # nvim-dep
      # nodePackages.typescript-language-server # nvim-dep
      # prettierd # Prettier daemon for faster formatting # nvim-dep
      # python312 # Python 3.12 # nvim-dep
      # rustfmt # Rust formatter # nvim-dep
      # ruff # An extremely fast Python linter # nvim-dep
      # ruff-lsp # Ruff LSP for Python # nvim-dep
      # rust-analyzer # Modular compiler frontend for the Rust language
      # stylua # Lua code formatter # nvim-dep
      # tailwindcss-language-server # LSP functionality for Tailwind CSS # nvim-dep
      # unzip # An extraction utility for archives compressed in .zip format # nvim-dep
      # vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode # nvim-dep
      # yaml-language-server # Language Server for YAML Files

      # Dependencies of openfortivpn
      # autoconf # Part of the GNU Build System
      # automake # GNU standard-compliant makefile generator
      # openssl # A cryptographic library that implements the SSL and TLS protocols

      # Dependencies of python 2.7 for customer-api-legacy
      # libffi # Foreign function call interface library
      # lzlib # Data compression library providing in-memory LZMA compression and decompression functions, including integrity checking of the decompressed data
      # ncurses # Free software emulation of curses in SVR4 and more
      # readline # Library for interactive line editing
      # sqlite # Self-contained, serverless, zero-configuration, transactional SQL database engine
      # tk # Widget toolkit that provides a library of basic elements for building a GUI in many different programming languages
      # xml2 # Tools for command line processing of XML, HTML, and CSV
      # xmlsec # XML Security Library in C based on libxml2
      # xz # General-purpose data compression software, successor of LZMA
      # zlib # Lossless data-compression library

      # vimPlugins
      #
      #
      # dap related:
      #
      # vimPlugins.nvim-dap
      # vimPlugins.nvim-dap-ui
      # vimPlugins.nvim-dap-python
      # vimPlugins.nvim-dap-go
      # vimPlugins.nvim-dap-virtual-text
      # vimPlugins.telescope-dap-nvim
      #
      # vimPlugins.nvim-treesitter
      # vimPlugins.nvim-treesitter.withAllGrammars

      # pkgs-neovim-094.neovim
    ];
  };

  # Programs with more extensive config are imported from separate modules.
  imports = [
    ../shared/git.nix
    # ../shared/neovim.nix
    ../shared/ripgrep.nix
    ../shared/zellij.nix
    ../shared/zsh.nix
  ];

  # nixpkgs.config.allowUnfree = true;

  # Programs with little to no config are enabled here.
  programs = {
    atuin = {
      enable = true;
    };
    bat = {
      enable = true;
      config.theme = "Visual Studio Dark+";
    };
    broot.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
    gh.enable = true;
    gpg.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    lsd.enable = true;
    mise.enable = false;
    ssh = {
      enable = true;
      # extraConfig = "IgnoreUnknown AddKeysToAgent,UseKeychain";
      addKeysToAgent = "yes";
      # extraConfig = ''
      #   IdentityFile ~/.ssh/ssh_id_ed25519_jordan_bravo
      #   IdentitiesOnly yes
      # '';
    };
    starship = {
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
    yazi = {
      enable = true; # disabled because broken by latest update to nixpkgs on Nov 3rd
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
    };
  };

  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
  };

}
