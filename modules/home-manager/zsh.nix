# shared/zsh.nix
{ config, ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    dotDir = "${config.xdg.configHome}/zsh";
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [
      "main"
      "brackets"
    ];
    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };
    shellAliases = import ../shell-aliases.nix;
    # Shared init must run here (user .zshrc), not only in /etc/zshrc: it has to
    # come after the `bindkey -v` emitted by defaultKeymap, or the ^U binding
    # lands in the abandoned emacs keymap. On NixOS it also runs system-wide via
    # nixos-all.nix for root; running twice is harmless.
    initContent = builtins.readFile ../zsh-init.sh;
    # envExtra = ''
    #   export LESSUTFCHARDEF=e000-f8ff:p,f0000-10ffff:p
    # '';
  };
}
