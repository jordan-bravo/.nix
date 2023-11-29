# ~/.nix/shared/home.nix

{ pkgs, ... }:

# Note: if you uncomment the rust- analyzer section below, make sure to add flake-inputs to the function arguments above so it looks like this:
# { pkgs, flake-inputs, ... }:

# let
#   rust-analyzer = flake-inputs.fenix.packages.${pkgs.system}.rust-analyzer;
# in

let
  # username = config.users.users.jordan.name;
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
      # To enable pyenv zsh integration manually, use the command:
      # eval "$(pyenv init -)"
      enableZshIntegration = false;
    };
    ripgrep.enable = true;
    rtx = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        settings = {
          legacy_version_file = false;
        };
      };
    };
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
        charliermarsh.ruff # Not available in 23.05
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
    ../shared/ssh.nix
    ../shared/wezterm.nix
    ../shared/zsh.nix
  ];

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "23.05";
    packages = with pkgs; [
      borgbackup # Deduplicating archiver with compression and encryption
      cargo # Rust package manager
      delta # A syntax-highlighting pager for git
      element-desktop # Matrix client
      eslint_d # ESLint daemon for increased performance
      fd # A simple, fast and user-friendly alternative to find
      fira-code # Font
      freetube # YouTube client
      heroku # Heroku CLI
      lua-language-server # LSP language server for Lua
      luajit # JIT compiler for Lua 5.1
      luajitPackages.luacheck # A static analyzer & linter for Lua
      neofetch # Show system info
      neovim # Text editor
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      nil # Language server for Nixlang
      nixpkgs-fmt # Formatter for Nixlang
      nodePackages.eslint # An AST-based pattern checker for JavaScript
      nodePackages.prettier # Formatter for JavaScript and other languages
      nodePackages.pyright # Python static type checker
      nodePackages.typescript # TypeScript language
      nodePackages.typescript-language-server # LSP for JS and TS
      obsidian # Note-taking
      onefetch # Git repo summary
      pgcli # Command-line interface for PostgreSQL
      poetry # Python dependency management and packaging made easy
      # postman # API development environment
      prettierd # Prettier daemon for faster formatting
      python311 # A high-level dynamically-typed programming language
      python311Packages.black # Python code formatter
      python311Packages.pip # Tool for installing Python packages
      # python311Packages.python-lsp-ruff # Ruff linting plugin and LSP for Python
      ripgrep # Search tool
      # rust-analyzer # Rust LSP
      # rustc # Rust compiler
      # rustfmt # Rust formatter
      ruby_3_2 # Ruby language
      ruff # An extremely fast Python linter
      ruff-lsp # Ruff LSP for Python
      # rustup # Rust toolchain installer
      slack # Desktop client for Slack
      stylua # Lua code formatter
      trash-cli # Command line interface to the freedesktop.org trash can
      # trashy # CLI trash tool written in Rust # Note: currently has a bug that breaks tab completion
      wget # File retriever
      yarn # Package manager for JavaScript
      zellij # A terminal workspace with batteries included
      
    ];
  };

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
  };

}
