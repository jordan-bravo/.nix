# ~/.nix/shared/home.nix

{ pkgs, ... }:

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
    };
    rtx = {
      enableZshIntegration = true;
      settings = {
        settings = {
          legacy_version_file = false;
        };
      };
    };
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
        "editor.lineNumbers" = "relative";
        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };
        "vscode-neovim.neovimClean" = true;
        "workbench.startupEditor" = "none";
        "editor.fontFamily" = "FiraCode Nerd Font Mono";
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
    packages = with pkgs; [
      aerc # An email client for your terminal
      android-studio # The Official IDE for Android (stable channel)
      android-tools # Android SDK platform tools
      beekeeper-studio # SQL database client
      bitcoind # Peer-to-peer electronic cash system
      borgbackup # Deduplicating archiver with compression and encryption
      cargo # Rust package manager
      # dbeaver # SQL database client
      delta # A syntax-highlighting pager for git
      discord # All-in-one cross-platform voice and text chat for gamers
      element-desktop # Matrix client
      emmet-ls # Emmet support based on LSP
      eslint_d # ESLint daemon for increased performance
      fd # A simple, fast and user-friendly alternative to find
      fira-code # Font
      freetube # YouTube client
      gnumake # A tool to control the generation of non-source files from sources
      go # The Go / Golang programming language
      gopls # Official language server for Go / Golang
      heroku # Heroku CLI
      lua-language-server # LSP language server for Lua
      luajit # JIT compiler for Lua 5.1
      luajitPackages.luacheck # A static analyzer & linter for Lua
      neofetch # Show system info
      # neovim # Text editor / IDE
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      nil # Language server for Nixlang
      nixd # Nix langauge server
      nixpkgs-fmt # Formatter for Nixlang
      nodePackages.eslint # An AST-based pattern checker for JavaScript
      nodePackages.pnpm # Fast, disk space efficient package manager
      nodePackages.prettier # Formatter for JavaScript and other languages
      nodePackages.pyright # Python static type checker
      nodePackages.typescript # TypeScript language
      nodePackages.typescript-language-server # LSP for JS and TS
      obsidian # Note-taking
      onefetch # Git repo summary
      pgcli # Command-line interface for PostgreSQL
      # postman # API development environment
      prettierd # Prettier daemon for faster formatting
      # python311Packages.black # Python code formatter
      python311Packages.debugpy # An implementation of the Debug Adapter Protocol for Python
      rust-analyzer # Rust LSP
      # rustc # Rust compiler
      rustfmt # Rust formatter
      ruby_3_2 # Ruby language
      ruff # An extremely fast Python linter
      ruff-lsp # Ruff LSP for Python
      # rustup # Rust toolchain installer
      # sdkmanager # A drop-in replacement for sdkmanager from the Android SDK written in Python
      scc # Code counter with complexity calculations and COCOMO estimates written in Go
      signal-desktop # Signal desktop
      slack # Desktop client for Slack
      speedtest-go # CLI and Go API to Test Internet Speed using speedtest.net
      speedtest-rs # Command line internet speedtest tool written in rust
      stylua # Lua code formatter
      tailwindcss-language-server # LSP functionality for Tailwind CSS
      trash-cli # Command line interface to the freedesktop.org trash can
      # trashy # CLI trash tool written in Rust # Note: currently has a bug that breaks tab completion
      vimPlugins.nvim-dap-ui # UI elements for the Debug Adapter Protocol in Neovim
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode
      watchman # Watches files and takes action when they change
      wget # File retriever
      yarn # Package manager for JavaScript
      # zellij # A terminal workspace with batteries included
    ];
  };

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
  };

}
