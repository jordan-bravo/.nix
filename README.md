# Jordan's Nix Configurations

### Uses Flakes, Home Manager, and Nix Darwin (for MacOS hosts)

I have tried to put as much of the configuration as possible into Home Manager in order to be portable across different environments.

## Hosts

### Desktops

`medserv`: Media server and desktop for viewing. ISA: `x86_64-linux`

### Laptops

`tux`: My main personal laptop running NixOS and using Home Manager. ISA: `x86_64-linux`

`carby`: My backup personal laptop running NixOS and using Home Manager. ISA: `x86_64-linux`

`thinky`: My work laptop, currently running Ubuntu 22.04 and using the Nix package manager and Home Manager. ISA: `x86_64-linux`

`mbp`: My former work laptop, a MacBook with M1 (ARM) chip running MacOS, using Nix-Darwin and Home Manager. No longer in use, config might be outdated. ISA: `aarch64-darwin`

### Servers

`sovserv`: Self-sovereign data and services. ISA: `x86_64-linux`

`finserv`: Nix-Bitcoin and related services. ISA: `x86_64-linux`

### Other

`shared`: Configuration that can be shared across multiple hosts.

## TODO (High Level)

### carby/tux

- Add Hyprland

### finserv

- Install NixOS
- Configure nix-bitcoin flake

### medserv

- Install NixOS
- Configure tailscale, media viewer e.g. VLC, browser, GSConnect, etc.

### sovserv

- Personal portfolio website (TODO)
- Matrix server (TODO)
- Gitea (TODO)
- Obisidian Live Sync (TODO)
- Vaultwarden (TODO)

### Task List (Low Level)

- home-manager switch command leads to MediaKeys systemd service failing.
- Configure zsh autosuggest/autocomplete (which one? both?) to avoid using arrow keys for completion.
- Remove repetition by declaring username only once in flake.nix, then passing to other modules.

### Research Needed

- On non-NixOS systems, how to declaritively configure things not available in home manger?
I think the answer to this is [system-manager](https://github.com/numtide/system-manager)
    - Postgres/Redis <-- solution for Alta is to run these in containers
    - Docker <-- Possibly replace with Podman which doesn't require root and might be nixable
    - Flatpak <-- No way that I know of to declaritively configure Flatpaks
---

### Misc. Notes
