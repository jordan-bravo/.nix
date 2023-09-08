# ~/.nix/shared/home.nix

{ pkgs, flake-inputs, ... }:

# let
#   rust-analyzer = flake-inputs.fenix.packages.${pkgs.system}.rust-analyzer;
# in

{
  fonts.fontconfig.enable = true;

  # Programs with little to no config are enabled here. 
  programs = {
    bat.enable = true;
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
    rtx = {
      enable = true;
      enableZshIntegration = true;
    };
    vscode.enable = true;
  };

  # Programs with extensive config are imported from separate modules.
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
      element-desktop # Matrix client
      fd # A simple, fast and user-friendly alternative to find
      fira-code # Font
      lua-language-server # Lua LSP
      neofetch # Show system info
      neovim # Text editor
      nil # Language server for Nixlang
      nixpkgs-fmt # Formatter for Nixlang
      onefetch # Git repo summary
      obsidian # Note-taking
      # rust-analyzer # Rust LSP
      # rustc # Rust compiler
      # rustfmt # Rust formatter
      rustup # Rust toolchain installer
      slack # Desktop client for Slack
      stylua # Lua code formatter
      trash-cli # Command line interface to the freedesktop.org trash can
      # trashy # CLI trash tool written in Rust # Note: currently has a bug that breaks tab completion
      wget # File retriever
    # ]);
    ];
  };
}
