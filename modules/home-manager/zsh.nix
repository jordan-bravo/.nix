# shared/zsh.nix
{ config, ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    dotDir = "${config.xdg.configHome}/zsh";
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [ "brackets" ];
    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };
    # envExtra = ''
    #   export LESSUTFCHARDEF=e000-f8ff:p,f0000-10ffff:p
    # '';
  };
}
