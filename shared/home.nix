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
  # Programs with little to no config are enabled here. 
  programs = {
    alacritty.enable = true;
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
    pyenv = {
      enable = false;
      # To manually activate pyenv in zsh, use the command:
      # eval "$(pyenv init -)"
      enableZshIntegration = false;
      rootDirectory = "${config.xdg.dataHome}/pyenv";
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
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
        # charliermarsh.ruff
        ms-python.python
        # ];
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "roc-lang-unofficial";
          publisher = "ivandemchenko";
          version = "1.2.0";
          sha256 = "sha256-lMN6GlUM20ptg1c6fNp8jwSzlCzE1U0ugRyhRLYGPGE=";
        }
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
    ../shared/neovim.nix
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
      zellij-config = {
        target = ".config/zellij/config.kdl";
        enable = true;
        text = ''
          pane_frames false
          keybinds {
              move {
                  bind "Ctrl x" { SwitchToMode "Normal"; }
              }
              normal {
                  unbind "Ctrl h"
                  unbind "Ctrl b"
                  unbind "Ctrl o"
                  }
              scroll {
                  bind "/" {
                      SwitchToMode "EnterSearch"
                      SearchInput 0
                  }
              }
              session {
                  bind "Alt s" { SwitchToMode "Normal"; }
                  unbind "Ctrl o"
              }
              shared_among "search" "scroll" {
                  bind "End" "G" {
                      ScrollToBottom
                  }
                  bind "Home" {
                      ScrollToTop
                  }
              }
              shared_except "session" "locked" {
                  bind "Alt s" { SwitchToMode "Session"; }
                  unbind "Ctrl o"
              }
              shared_except "move" "locked" {
                  bind "Ctrl x" { SwitchToMode "Move"; }
              }
              // these are the defaults for entersearch
              // might want to change or add to them later
              entersearch {
                  bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
                  bind "Enter" { SwitchToMode "Search"; }
              }
          }
          ui {
              pane_frames {
                  rounded_corners true
              }
          }
        '';
      };
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    packages = with pkgs; [
      act # Run your GitHub Actions locally
      aerc # An email client for your terminal
      audacity # Music player
      android-studio # The Official IDE for Android (stable channel)
      android-tools # Android SDK platform tools
      beekeeper-studio # SQL database client
      bitcoind # Peer-to-peer electronic cash system
      borgbackup # Deduplicating archiver with compression and encryption
      bottom # A cross-platform graphical process/system monitor with a customizable interface
      cargo # Rust package manager
      # dbeaver # SQL database client
      delta # A syntax-highlighting pager for git
      discord # All-in-one cross-platform voice and text chat for gamers
      dogdns # Command-line DNS client
      dpkg # The Debian package manager
      du-dust # du + rust = dust. Like du but more intuitive
      duf # Disk Usage/Free Utility, a df alternative
      element-desktop # Matrix client
      # emmet-ls # Emmet support based on LSP
      eslint_d # ESLint daemon for increased performance
      fd # A simple, fast and user-friendly alternative to find
      fira-code # Font
      freetube # YouTube client
      gitui # Blazing fast terminal-ui for Git written in Rust
      go # The Go / Golang programming language
      heroku # Heroku CLI
      librewolf # A fork of Firefox, focused on privacy, security, and freedom
      lsof # A tool to list open files
      # mise # (formerly rtx) Runtime/environment manager
      neofetch # Show system info
      neovide # A simple graphical user interface for Neovim
      neovim # Text editor / IDE
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      nest-cli # CLI tool for NestJS applications
      nixpkgs-fmt # Formatter for Nixlang
      # nodePackages.eslint # An AST-based pattern checker for JavaScript
      nodePackages.pnpm # Fast, disk space efficient package manager
      # nodePackages.prettier # Formatter for JavaScript and other languages
      # nodePackages.pyright # Python static type checker
      # nodePackages.typescript # TypeScript language
      # nodePackages.typescript-language-server # LSP for JS and TS
      obsidian # Note-taking # Weird bug in gnome on tux, can't see window
      onefetch # Git repo summary
      # pgcli # Command-line interface for PostgreSQL
      # postman # API development environment
      procs # A modern replacement for ps written in Rust
      python311 # Python 3.11
      python311Packages.base58 # Base58 and Base58Check implementation
      # rustc # Rust compiler
      ruby_3_2 # Ruby language
      # rustup # Rust toolchain installer
      # sdkmanager # A drop-in replacement for sdkmanager from the Android SDK written in Python
      scc # Code counter with complexity calculations and COCOMO estimates written in Go
      signal-desktop # Signal desktop
      slack # Desktop client for Slack
      speedtest-go # CLI and Go API to Test Internet Speed using speedtest.net
      speedtest-rs # Command line internet speedtest tool written in rust
      steam-run # Run commands in the same FHS environment that is used for Steam
      stylua # Lua code formatter
      # tailwindcss-language-server # LSP functionality for Tailwind CSS
      trash-cli # Command line interface to the freedesktop.org trash can
      # trashy # CLI trash tool written in Rust # Note: currently has a bug that breaks tab completion
      vim
      vorta # Desktop Backup Client for Borg
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode
      watchman # Watches files and takes action when they change
      wget # File retriever
      xh # Friendly and fast tool for sending HTTP requests
      yarn # Package manager for JavaScript
      zellij # Terminal multiplexer

      # Neovim/Lazyvim dependencies nvim-dep
      gcc # GNU Compiler Collection # nvim-dep # nvim-dep
      gnumake # A tool to control the generation of non-source files from sources # nvim-dep
      gopls # Official language server for Go / Golang # nvim-dep
      lazygit # Simple terminal UI for git commands # nvim-dep
      lua-language-server # LSP language server for Lua # nvim-dep
      luajit # JIT compiler for Lua 5.1 # nvim-dep
      luajitPackages.jsregexp # JavaScript (ECMA19) regular expressions for lua # nvim-dep
      luajitPackages.luacheck # A static analyzer & linter for Lua # nvim-dep
      prettierd # Prettier daemon for faster formatting
      rustfmt # Rust formatter # nvim-dep
      ruff # An extremely fast Python linter # nvim-dep
      ruff-lsp # Ruff LSP for Python #nvim-dep
      unzip # An extraction utility for archives compressed in .zip format

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

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
  };

}
