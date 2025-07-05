{
  home.stateVersion = "25.05";

  imports = [
    ./git.nix
    ./ripgrep.nix
    ./zsh.nix
  ];

  programs.atuin.enable = true;
  programs.atuin.enableZshIntegration = true;
  programs.atuin.daemon.enable = true;
}
