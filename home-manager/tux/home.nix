# ~/.nix/tux/home.nix

{ pkgs, ... }:

{
  # dconf = {
  #   settings = {
  #     "org/gnome/desktop/interface" = {
  #       # text-scaling-factor = 0.8; # BitLab LG
  #       # text-scaling-factor = 1.0; # Normal scaling
  #       # text-scaling-factor = 1.25; # Home Innocn
  #       # text-scaling-factor = 1.45; # tux built-in
  #       # text-scaling-factor = 1.75; # Larger
  #       text-scaling-factor = 2.0; # Double
  #     };
  #     "org/gnome/desktop/peripherals/mouse" = {
  #       speed = -0.8;
  #     };
  #     "org/gnome/desktop/peripherals/touchpad" = {
  #       speed = 0.25;
  #     };
  #     "org/virt-manager/virt-manager/connections" = {
  #       autoconnect = [ "qemu:///system" ];
  #       uris = [ "qemu:///system" ];
  #     };
  #     # "org/gnome/desktop/sound" = {
  #     #   allow-volume-above-100-percent = true;
  #     # };
  #   };
  # };
  # home = {
  #   packages = with pkgs; [
  #     atuin
  #   ];
  # };
  imports = [
    # ../shared/git.nix
    # ../shared/home.nix
    # ../shared/kitty.nix
    # ../shared/workstations.nix
    # ../shared/waybar.nix
    # ../shared/hyprland.nix
    # android-nixpkgs.hmModule {
    # }
  ];
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
  home.stateVersion = "25.05";
}
