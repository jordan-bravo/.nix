# .nix/modules/home-manager/wezterm.nix
{
  programs.wezterm = {
    enable = false;
    extraConfig = ''
      -- Pull in the wezterm API
      local wezterm = require('wezterm')

      -- This will hold the configuration.
      local config = wezterm.config_builder()

      -- This is where you actually apply your config choices.
      -- -----------------------------------------------------

      config.font_size = 12
      config.color_scheme = 'Vs Code Dark+ (Gogh)'
      config.font = wezterm.font('FiraCodeNerdFont')
      config.window_decorations = "NONE"

      -- -----------------------------------------------------
      -- Finally, return the configuration to wezterm:
      return config
    '';
  };
}
