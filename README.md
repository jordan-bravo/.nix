# Jordan's Nix Configurations

### Uses Flakes, Home Manager, and Nix Darwin (for MacOS hosts)

I have tried to put as much of the configuration as possible into Home Manager in order to be portable across different environments.

## Hosts

`tux`: My main personal laptop running NixOS.

`mbp`: My work laptop, a MacBook Pro with M1 (ARM) chip running MacOS.

`thinky`: Another work laptop, ThinkPad, currently running Ubuntu 22.04 and using the Nix package manager and Home Manager.

`shared`: Configuration that can be shared across multiple hosts.

## TODO (High Level)

- My [Neovim configuration](https://github.com/jordan-bravo/nvim) is currently not managed by Nix.  I plan to add all Neovim configuration to Nix.
- Add Hyprland on Linux hosts.
- Convert servers from Ubuntu to NixOS.

### Task List (Low Level)

- Tux: activating kitty scrollback buffer causes icons to turn into codes.
- Thinky: home manager switch command leads to MediaKeys systemd service failing.
- Configure zsh autosuggest/autocomplete (which one? both?) to avoid using arrow keys for completion.
- Remove repetition by declaring username only once in flake.nix, then passing to other modules.

### Research Needed

- On non-NixOS systems, how to declaritively configure things not available in home manger?
    - Postgres
    - Docker
    - Flatpak

