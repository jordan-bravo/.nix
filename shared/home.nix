{ pkgs, ... }:

{
  # Programs with little to no config required are enabled here. 
  programs = {
    bat.enable = true;
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
    ripgrep.enable = true;
    vscode.enable = true;
  };

  # Programs with extensive config are imported from separate modules.
  imports = [
    ../shared/git.nix
    ../shared/kitty.nix
    ../shared/neovim.nix
    ../shared/wezterm.nix
    ../shared/zsh.nix
  ];

  services = {
    copyq.enable = true;
  };

  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = "23.05";
    packages = with pkgs; [
      fd # A simple, fast and user-friendly alternative to find
      fira-code # Font
      nil # Language server for Nixlang
      nixpkgs-fmt # Formatter for Nixlang
      rustup # Rust toolchain installer. Rust required for Nix language server
      wget # File retriever
      # zsh-powerlevel10k # Zsh prompt theming
    ];
  };
}
