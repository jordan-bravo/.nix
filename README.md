# Jordan's Nix Configurations

### Uses Flakes, Home Manager, and Nix Darwin (for MacOS hosts)

I have tried to put as much of the configuration as possible into Home Manager in order to be portable across different environments.

## Hosts

`tux`: My main personal laptop running NixOS.

`mbp`: My work laptop, a MacBook Pro with M1 (ARM) chip running MacOS.

`shared`: Configuration that can be shared across all hosts.

## TODO

- [Neovim configuration](https://github.com/jordan-bravo/nvim) is currently not managed by Nix.  I plan to add all Neovim configuration to Nix.
- Add Hyprland on Linux hosts.
- Convert servers from Ubuntu to NixOS.
