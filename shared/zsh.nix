# ~/.nix/shared/zsh.nix
{ pkgs, ... }:

{
  programs.zsh = {
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    initExtra = ''
      # If bat exists, use instead of cat
      type bat > /dev/null 2>&1 && alias cat=bat

      # If lsd exists, use instead of ls
      type lsd > /dev/null 2>&1 && alias ls=lsd

      # Keep prompt at bottom of terminal window
      printf '\n%.0s' {1..$LINES}
    '';
    localVariables = {
      PATH = "/opt/homebrew/bin:$PATH";
    };
    plugins = [
      {
        name = "zsh-autocomplete";
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "23.07.13";
          sha256 = "0NW0TI//qFpUA2Hdx6NaYdQIIUpRSd0Y4NhwBbdssCs=";
        };
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = ".p10k.zsh";
      }
    ];
    shellAliases = {
      cfg = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      cs = "cfg status";
      darr = "darwin-rebuild switch --flake ~/.nix";
      l = "ls -lAhF";
      la = "ls -AhF";
      htux = "cd ~/.nix/tux && nvim ~/.nix/tux/home.nix";
      hypc = "nvim ~/.config/hypr/hyprland.conf";
      kitc = "nvim ~/.config/kitty/kitty.conf";
      kits = "nvim ~/.config/kitty/session.conf";
      gexit = "gnome-session-quit --no-prompt";
      nixos = ''
        qemu-system-aarch64 \
          -monitor stdio \
          -machine virt \
          -accel hvf \
          -cpu host \
          -smp 4 \
          -m 8000 \
          -bios QEMU_EFI.fd \
          -device virtio-gpu-pci \
          -display default,show-cursor=on \
          -device qemu-xhci \
          -device usb-kbd \
          -device usb-tablet \
          -device intel-hda \
          -device hda-duplex \
          -drive file=nixos-23.05.raw,format=raw,if=virtio,cache=writethrough \
          -cdrom nixos-gnome-23.05.2979.fc944919f743-aarch64-linux.iso
      '';
      nixr = "sudo nixos-rebuild switch --flake ~/.nix";
      notify-piano = "play ~/Documents/piano.wav";
      s = "git status";
      sauce = "source $HOME/.config/zsh/.zshrc";
      sshk = "kitty +kitten ssh";
      vim = "nvim";
      waybarc = "nvim ~/.config/waybar/config.jsonc";
      waybars = "nvim ~/.config/waybar/style.css";
      yubi-add = "ssh-add -s /usr/local/lib/libykcs11.dylib";
    };
    syntaxHighlighting = {
      enable = true;
    };
  };
}
