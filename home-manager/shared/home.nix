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
          git:
            paging:
              pager: delta
        '';
      };
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "23.11";
    packages = with pkgs; [
      act # Run your GitHub Actions locally
      aerc # An email client for your terminal
      age # (Actually Good Encryption) A modern encryption tool with small explicit keys
      bottom # A cross-platform graphical process/system monitor with a customizable interface
      # busybox # Tiny versions of common UNIX utilities in a single small executable
      cargo # Rust package manager
      delta # A syntax-highlighting pager for git
      dhcping # Send DHCP request to find out if a DHCP server is running
      dig # DNS tool
      distrobox # Run containers of any Linux distro
      docker-compose # Docker Compose plugin for Docker
      dogdns # Command-line DNS client
      drawio # Diagram application
      du-dust # du + rust = dust. Like du but more intuitive
      duf # Disk Usage/Free Utility, a df alternative
      fd # A simple, fast and user-friendly alternative to find
      ffmpeg # A complete, cross-platform solution to record, convert and stream audio and video
      fira-code # Font
      gitui # Blazing fast terminal-ui for Git written in Rust
      glow # Render markdown on the CLI, with pizzazz!
      gnome-multi-writer # Tool for writing an ISO file to multiple USB devices at once
      go # The Go / Golang programming language
      httpie # Command line HTTP client whose goal is to make CLI human-friendly
      hyprpaper # Hyprland wallpaper program
      ivpn # VPN GUI
      ivpn-service # VPN background service
      killall # Tool to kill processes
      # kitty # Terminal emulator
      lsof # A tool to list open files
      # mise # (formerly rtx) Runtime/environment manager
      neofetch # Show system info
      neovim # Text editor / IDE
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      nix-index # A files database for nixpkgs
      nix-search-cli # Search packages from the command line
      nixpkgs-fmt # Formatter for Nixlang
      nodePackages.pnpm # Fast, disk space efficient package manager
      onefetch # Git repo summary
      pgcli # Command-line interface for PostgreSQL
      pkg-config # Required for borg mount
      procs # A modern replacement for ps written in Rust
      # pyenv # Simple Python version management
      scc # Code counter with complexity calculations and COCOMO estimates written in Go
      sad # CLI tool to search and replace
      sd # Intuitive find & replace CLI (sed alternative)
      sops # Secrets OPerationS
      speedtest-go # CLI and Go API to Test Internet Speed using speedtest.net
      speedtest-rs # Command line internet speedtest tool written in rust
      steam-run # Run commands in the same FHS environment that is used for Steam
      transmission # Bittorrent client
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
      zola # A fast static site generator with everything built-in

      # Used with Hyprland
      wofi

      # Neovim/Lazyvim dependencies nvim-dep
      basedpyright # Type checker for the Python language
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
      nixd # Nix langauge server # nvim-dep
      nixpkgs-fmt # nvim-dep
      nodejs_22 # Event-driven I/O framework for the V8 JavaScript engine # nvim-dep
      nodePackages.bash-language-server # A language server for Bash
      nodePackages.eslint # An AST-based pattern checker for JavaScript
      nodePackages.prettier # nvim-dep
      pyright # Python static type checker
      nodePackages.typescript # nvim-dep
      nodePackages.typescript-language-server # nvim-dep
      prettierd # Prettier daemon for faster formatting # nvim-dep
      # python312 # Python 3.12 # nvim-dep
      rustfmt # Rust formatter # nvim-dep
      ruff # An extremely fast Python linter # nvim-dep
      ruff-lsp # Ruff LSP for Python # nvim-dep
      stylua # Lua code formatter # nvim-dep
      tailwindcss-language-server # LSP functionality for Tailwind CSS # nvim-dep
      unzip # An extraction utility for archives compressed in .zip format # nvim-dep
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode # nvim-dep
      yaml-language-server # Language Server for YAML Files

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
    ../shared/neovim.nix
    ../shared/ripgrep.nix
    ../shared/zellij.nix
    ../shared/zsh.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Programs with little to no config are enabled here. 
  programs = {
    atuin.enable = true;
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
    fzf.enable = false;
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
          truncation_length = 5;
          truncation_symbol = ".../";
          repo_root_style = "purple";
        };
        gcloud = {
          disabled = true;
        };
      };
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
