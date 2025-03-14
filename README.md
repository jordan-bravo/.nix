# Jordan's Nix Configurations

### Uses Flakes, Home Manager, and Nix Darwin (for MacOS hosts)

I have tried to put as much of the configuration as possible into Home Manager in order to be portable across different environments.

## Hosts

(Hosts have Instruction Set Architecture of `x86_64-linux` unless specified otherwise)

### Desktops

`medserv`: Media server and desktop for viewing. OS: NixOS.

### Laptops

`tux`: My main personal laptop running NixOS and using Home Manager.

`thinky`: My work laptop, currently running Ubuntu and using the Nix package manager and Home Manager.

`mbp`: My former work laptop, a MacBook with M1 (ARM) chip running MacOS, using Nix-Darwin and Home Manager. No longer in use, config is likely outdated. ISA: `aarch64-darwin`

### Servers

`sovserv`: Self-sovereign data and services. OS: NixOS.

`finserv`: Nix-Bitcoin and related services. OS: NixOS.

### Other

`shared`: Configuration that can be shared across multiple hosts.

## TODO (High Level)

### tux

- Configure Hyprland on tux

### finserv

- Figure out how to connect electrs to liquidd. Note: use [esplora](https://github.com/Blockstream/esplora?tab=readme-ov-file#how-to-run-the-explorer-for-liquid-mainnet)
- Figure out how to connect mempool to liquidd

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

- Configure zsh autosuggest/autocomplete (which one? both?) to avoid using arrow keys for completion.
- Remove repetition by declaring username only once in flake.nix, then passing to other modules.

### Research Needed

- On non-NixOS systems, how to declaritively configure things not available in home manger?
  I think the answer to this is [system-manager](https://github.com/numtide/system-manager) - Postgres/Redis <-- solution for Alta is to run these in containers - Docker <-- Possibly replace with Podman which doesn't require root and might be nixable - Flatpak <-- Research declarative flatpak

---

### Misc. Notes
