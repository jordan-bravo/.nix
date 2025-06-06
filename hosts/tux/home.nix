{ ... }:

{
  home.stateVersion = "25.05";

  imports = [
    # ../shared/git.nix
    # ../shared/home.nix
    ../../modules/home-manager/kitty.nix
    # ../shared/workstations.nix
    # ../shared/waybar.nix
    # ../shared/hyprland.nix
    # android-nixpkgs.hmModule {
    # }
  ];

  services.copyq.enable = true;

  # programs.vscode = {
  #   enable = false;
  #   package = pkgs.vscodium;
  #   extensions = with pkgs.vscode-extensions; [
  #     asvetliakov.vscode-neovim
  #     yzane.markdown-pdf
  #     # charliermarsh.ruff
  #     # ms-python.python
  #     # ];
  #     # ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  #     #   {
  #     #     name = "roc-lang-unofficial";
  #     #     publisher = "ivandemchenko";
  #     #     version = "1.2.0";
  #     #     sha256 = "sha256-lMN6GlUM20ptg1c6fNp8jwSzlCzE1U0ugRyhRLYGPGE=";
  #     #   }
  #   ];
  #   userSettings = {
  #     "editor.fontFamily" = "Fira Code";
  #     "editor.lineNumbers" = "relative";
  #     "extensions.experimental.affinity" = {
  #       "asvetliakov.vscode-neovim" = 1;
  #     };
  #     "keyboard.dispatch" = "keyCode";
  #     "vscode-neovim.neovimClean" = true;
  #     "window.menuBarVisibility" = "toggle";
  #     "workbench.startupEditor" = "none";
  #   };
  # };
  # programs.zsh.initExtra = ''
  #   # Fix bug on NixOS with up arrow (nixos.wiki/wiki/Zsh)
  #   bindkey "''${key[Up]}" up-line-or-search
  # '';

  # systemd.user = {
  #   enable = false;
  #   services = {
  #     hyprland = {
  #       Unit = {
  #         Description = "Hyprland";
  #         After = [ "graphical-session-pre.target" ];
  #         BindsTo = [ "graphical-session.target" ];
  #         Documentation = [ "man:systemd.special" ];
  #         Requires = [ "basic.target" ];
  #         Wants = [ "graphical-session-pre.target" ];
  #       };
  #     };
  #   };
  # };
}
