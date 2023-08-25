# ~/.nix/mbp/home.nix

{ config, pkgs, ... }:

let
  username = "jordan";
  homeDirectory = "/Users/${username}";

in
{
  fonts.fontconfig.enable = true;
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    # (nerdfonts.override { fonts = [ "FiraCode" "NerdFontsSymbolsOnly" ]; })
    bat # Modern replacement for cat
    # delta # A syntax-highlighting pager for git
    fd # A simple, fast and user-friendly alternative to find
    fira-code # Font
    fontconfig # Font configuration
    fzf # Command line fuzzy finder
    gh # GitHub CLI
    # gnupg
    jq # JSON processor
    kitty # Terminal
    # lazygit
    lsd # The next gen ls command
    # neovim # Text editor
    onefetch
    ripgrep # Replacement for grep
    # wezterm # Terminal emulator
    # sl # Steam Locomotive run across your terminal when you type sl
    # nerdfonts # Patched fonts and icons
    # firefox # Web browser
    # brave # Web browser
    # wget # File retriever
    # git # Version control system
  ];

  # home.sessionVariables = {
  #   EDITOR = "nvim";
  # };

  programs = {
    home-manager.enable = true;
    git = {
     enable = true;
     delta = {
       enable = true;
     };
     # userName = "${myName}";
     # emailAddress = "${myEmailAddress}";
    };
    gpg.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    wezterm = {
      enable = true;
      extraConfig = ''
        -- Pull in the wezterm API
        local wezterm = require("wezterm")

        -- This table will hold the configuration.
        local config = {}

        -- In newer versions of wezterm, use the config_builder which will
        -- help provide clearer error messages
        if wezterm.config_builder then
                config = wezterm.config_builder()
        end

        -- This is where you actually apply your config choices

        -- For example, changing the color scheme:
        -- config.color_scheme = "Afterglow"

        -- Hide the OS window title bar
        config.window_decorations = "RESIZE"

        -- and finally, return the configuration to wezterm
        return config
      '';
    };
  };
}
