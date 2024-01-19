# ~/.nix/shared/home.nix

{ config, inputs, lib, pkgs, ... }:

# Note: if you uncomment the rust- analyzer section below, make sure to add flake-inputs to the function arguments above so it looks like this:
# { pkgs, flake-inputs, ... }:

# let
#   rust-analyzer = flake-inputs.fenix.packages.${pkgs.system}.rust-analyzer;
# in

let
  username = "jordan";
  homeDirectory =
    if pkgs.stdenv.isDarwin then
      "/Users/${username}"
    else
      "/home/${username}";
in
{
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
    fzf.enable = true;
    gh.enable = true;
    gpg.enable = true;
    home-manager.enable = true;
    jq.enable = true;
    lsd.enable = true;
    pyenv = {
      enable = true;
      # To manually activate pyenv in zsh, use the command:
      # eval "$(pyenv init -)"
      enableZshIntegration = false;
			rootDirectory = "${config.xdg.dataHome}/pyenv";
    };
    # Note: rtx was renamed to mise.  It's not yet in home manager.
    # rtx = {
    #   enableZshIntegration = true;
    #   settings = {
    #     settings = {
    #       legacy_version_file = false;
    #     };
    #   };
    # };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        directory = {
          truncate_to_repo = false;
        };
        gcloud = {
          disabled = true;
        };
      };
    };
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
        # charliermarsh.ruff
        ms-python.python
      ];
      userSettings = {
        "editor.fontFamily" = "FiraCode Nerd Font Mono";
        "editor.lineNumbers" = "relative";
        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };
        "keyboard.dispatch" = "keyCode";
        "vscode-neovim.neovimClean" = true;
        "window.menuBarVisibility" = "toggle";
        "workbench.startupEditor" = "none";
      };
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  # Programs with more extensive config are imported from separate modules.
  imports = [
    ../shared/git.nix
    ../shared/kitty.nix
    # ../shared/neovim.nix
    # ../shared/powerlevel10k.nix
    ../shared/ripgrep.nix
    ../shared/ssh.nix
    ../shared/wezterm.nix
    ../shared/zellij.nix
    ../shared/zsh.nix
  ];

  home = {
    file = {
      # This is here for syntax reference.
      example-file = {
        target = ".config/example-file/config.yaml";
        enable = false;
        text = ''
          Example:
            Your text goes here
        '';
      };
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    # stateVersion = "23.11";
    packages = [
      pkgs.aerc # An email client for your terminal
      pkgs.android-studio # The Official IDE for Android (stable channel)
      pkgs.android-tools # Android SDK platform tools
      pkgs.beekeeper-studio # SQL database client
      pkgs.bitcoind # Peer-to-peer electronic cash system
      pkgs.borgbackup # Deduplicating archiver with compression and encryption
      pkgs.cargo # Rust package manager
      # pkgs.dbeaver # SQL database client
      pkgs.delta # A syntax-highlighting pager for git
      pkgs.discord # All-in-one cross-platform voice and text chat for gamers
      pkgs.element-desktop # Matrix client
      pkgs.emmet-ls # Emmet support based on LSP
      pkgs.eslint_d # ESLint daemon for increased performance
      pkgs.fd # A simple, fast and user-friendly alternative to find
      pkgs.fira-code # Font
      pkgs.freetube # YouTube client
      pkgs.go # The Go / Golang programming language
      pkgs.gopls # Official language server for Go / Golang
      pkgs.heroku # Heroku CLI
      pkgs.lua-language-server # LSP language server for Lua
      pkgs.luajit # JIT compiler for Lua 5.1
      pkgs.luajitPackages.luacheck # A static analyzer & linter for Lua
      pkgs.mise # (formerly rtx) Runtime/environment manager
      pkgs.neofetch # Show system info
      # pkgs.neovim # Text editor / IDE
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
      pkgs.nil # Language server for Nixlang
      pkgs.nixd # Nix langauge server
      pkgs.nixpkgs-fmt # Formatter for Nixlang
      pkgs.nodePackages.eslint # An AST-based pattern checker for JavaScript
      pkgs.nodePackages.pnpm # Fast, disk space efficient package manager
      pkgs.nodePackages.prettier # Formatter for JavaScript and other languages
      pkgs.nodePackages.pyright # Python static type checker
      pkgs.nodePackages.typescript # TypeScript language
      pkgs.nodePackages.typescript-language-server # LSP for JS and TS
      pkgs.obsidian # Note-taking
      pkgs.onefetch # Git repo summary
      pkgs.pgcli # Command-line interface for PostgreSQL
      pkgs.# postman # API development environment
      pkgs.prettierd # Prettier daemon for faster formatting
      # inputs.nixpkgs-py27.legacyPackages.${pkgs.system}.python2
      (lib.hiPrio (inputs.nixpkgs-py27.legacyPackages.${pkgs.system}.python2.withPackages (ps: [ ps.certifi ps.pip ps.setuptools ps.virtualenv ]))) # pip2 for Python 2
      pkgs.python310 # 3.10.13
			# pkgs.python310Packages.setuptools # Utilities to facilitate the installation of Python packages
			# pkgs.python310Packages.virtualenv # A tool to create isolated Python environments
      # pkgs.python311Packages.black # Python code formatter
      # pkgs.python311Packages.debugpy # An implementation of the Debug Adapter Protocol for Python
      pkgs.rust-analyzer # Rust LSP
      # rustc # Rust compiler
      pkgs.rustfmt # Rust formatter
      pkgs.ruby_3_2 # Ruby language
      pkgs.ruff # An extremely fast Python linter
      pkgs.ruff-lsp # Ruff LSP for Python
      # rustup # Rust toolchain installer
      # sdkmanager # A drop-in replacement for sdkmanager from the Android SDK written in Python
      pkgs.scc # Code counter with complexity calculations and COCOMO estimates written in Go
      pkgs.signal-desktop # Signal desktop
      pkgs.slack # Desktop client for Slack
      pkgs.speedtest-go # CLI and Go API to Test Internet Speed using speedtest.net
      pkgs.speedtest-rs # Command line internet speedtest tool written in rust
      pkgs.stylua # Lua code formatter
      pkgs.tailwindcss-language-server # LSP functionality for Tailwind CSS
      pkgs.trash-cli # Command line interface to the freedesktop.org trash can
      # trashy # CLI trash tool written in Rust # Note: currently has a bug that breaks tab completion
      pkgs.vimPlugins.nvim-dap-ui # UI elements for the Debug Adapter Protocol in Neovim
      pkgs.vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode
      pkgs.watchman # Watches files and takes action when they change
      pkgs.wget # File retriever
      pkgs.yarn # Package manager for JavaScript

      # Packages for building Python
      # automake # GNU standard-compliant makefile generator
      # bzip2 # High-quality data compression program
      # findutils # GNU Find Utilities, the basic directory searching utilities of the GNU operating system
      # gcc # GNU Compiler Collection
      # gdbm # GNU dbm key/value database library
      # gnumake # A tool to control the generation of non-source files from sources
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
    ];
  };

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
  };

}
