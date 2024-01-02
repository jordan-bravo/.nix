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
    ripgrep.enable = true;
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
        charliermarsh.ruff
        ms-python.python
      ];
      userSettings = {
        "editor.lineNumbers" = "relative";
        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };
        "vscode-neovim.neovimClean" = true;
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
    ../shared/ssh.nix
    ../shared/wezterm.nix
    ../shared/zsh.nix
  ];

  home = {
    file = {
      # this is just here to remind me of the syntax to create files
      "myfile.json" = {
        enable = false;
        text = ''
          {
            "exampleKey": "exampleValue"
          }
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
      borgbackup # Deduplicating archiver with compression and encryption
      cargo # Rust package manager
      # dbeaver # SQL database client
      delta # A syntax-highlighting pager for git
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
      neovim # Text editor / IDE
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      nil # Language server for Nixlang
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
      signal-desktop # Signal desktop
      slack # Desktop client for Slack
      speedtest-go # CLI and Go API to Test Internet Speed using speedtest.net
      stylua # Lua code formatter
      tailwindcss-language-server # LSP functionality for Tailwind CSS
      trash-cli # Command line interface to the freedesktop.org trash can
      # trashy # CLI trash tool written in Rust # Note: currently has a bug that breaks tab completion
      vimPlugins.nvim-dap-ui # UI elements for the Debug Adapter Protocol in Neovim
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode
      watchman # Watches files and takes action when they change
      wget # File retriever
      yarn # Package manager for JavaScript
      zellij # A terminal workspace with batteries included
    ];
  };

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
    configFile = {
      ripgreprc = {
        enable = true;
        text = ''
          # Don't let ripgrep vomit really long lines to my terminal, and show a preview.
          --max-columns=150
          --max-columns-preview

          # Search hidden files / directories (e.g. dotfiles) by default
          --hidden

          # Ignore node_modules anywhere
          --glob=!**/node_modules/**

          # Ignore package-lock.json
          # --glob=!package-lock.json

          # Using glob patterns to include/exclude files or folders
          --glob=!.git/*
          --glob=!.venv/*
          --glob=!.cache/*
          --glob=!.mozilla/*
          --glob=!.infisical/*
          --glob=!.gnupg/*
          --glob=!.nix-defexpr/*
          --glob=!.node_repl_history
          --glob=!.npm/*
          --glob=!.pki/*
          --glob=!.thunderbird/*
          --glob=!.var/*
          --glob=!.config/BraveSoftware/Brave-Browser/Default/Extensions/*
          --glob=!.local/share/zsh/*
          
          # Ignore case when patter is all lowercase
          --smart-case

          # Don't respect ignore files (.gitignore, .ignore, etc.)
          --no-ignore
        '';
      };
    };
  };

}
