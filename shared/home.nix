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
    ripgrep.enable = true;
    # rtx = {
    #   enable = true;
    #   enableZshIntegration = true;
    # };
    vscode = {
      enable = true;
      package = pkgs.vscodium;
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
    # packages = [
    #   rust-analyzer
    # ] ++ (with pkgs; [
    packages = with pkgs; [
      # cargo # Rust package manager
      delta # A syntax-highlighting pager for git
      element-desktop # Matrix client
      fd # A simple, fast and user-friendly alternative to find
      fira-code # Font
      freetube # YouTube client
      # kitty # Terminal
      lua-language-server # LSP language server for Lua
      luajit # JIT compiler for Lua 5.1
      luajitPackages.luacheck # A static analyzer & linter for Lua
      neofetch # Show system info
      neovim # Text editor
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      nil # Language server for Nixlang
      nixpkgs-fmt # Formatter for Nixlang
      nodePackages.prettier # Formatter for JavaScript and other languages
      nodePackages.prettier_d_slim # Prettier daemon for faster formatting
      nodePackages.pyright # Python static type checker
      nodePackages.typescript # TypeScript language
      nodePackages.typescript-language-server # LSP for JS and TS
      onefetch # Git repo summary
      obsidian # Note-taking
      poetry # Python dependency management and packaging made easy
      # postman # API development environment
      pyenv # Simple Python version management
      pyright # Static type checker for Python
      python311 # Python 3.11
      python311Packages.black # Python code formatter
      python311Packages.pip # Tool for installing Python packages
      python311Packages.python-lsp-ruff # Ruff linting plugin and LSP for Python
      ripgrep # Search tool
      # rust-analyzer # Rust LSP
      # rustc # Rust compiler
      # rustfmt # Rust formatter
      ruby_3_2 # Ruby language
      rustup # Rust toolchain installer
      slack # Desktop client for Slack
      stylua # Lua code formatter
      trash-cli # Command line interface to the freedesktop.org trash can
      # trashy # CLI trash tool written in Rust # Note: currently has a bug that breaks tab completion
      wget # File retriever
      yarn # Package manger for JavaScript
    # ]);
    ];
  };

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
  };

}
