{
  home.stateVersion = "25.05";

  imports = [
    ./delta.nix
    ./git.nix
    ./ripgrep.nix
    ./zsh.nix
  ];

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    daemon.enable = false;
    settings = {
      enter_accept = true;
    };
  };
  programs.bottom.enable = true;
  programs.broot.enable = true;
}
