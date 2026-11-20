# Jordan's Nix Configurations

### Uses Flakes, Home Manager, and Nix Darwin (for MacOS hosts)

I have tried to put as much of the configuration as possible into Home Manager in order to be portable across different environments.

## Hosts

(Hosts have Instruction Set Architecture of `x86_64-linux` unless specified otherwise)

### Desktops

`medserv`: Media server and desktop for viewing. OS: NixOS.

### Laptops

`tux`: My main personal laptop running NixOS and using Home Manager.

`pine`: My work laptop, currently running Pop OS with Cosmic desktop and using the Nix package manager, home-manager, and system-manager.

`mbp`: My former work laptop, a MacBook with M1 (ARM) chip running MacOS, using Nix-Darwin and Home Manager. No longer in use, config is likely outdated. ISA: `aarch64-darwin`

### Servers

`sovserv`: Self-sovereign data and services. OS: NixOS.

`finserv`: Nix-Bitcoin and related services. OS: NixOS.

### Other

`shared`: Configuration that can be shared across multiple hosts.

## TODO (High Level)

### medserv

- Install NixOS
- Configure tailscale, media viewer e.g. VLC, browser, GSConnect, etc.

### sovserv

- Matrix server (TODO)
- Gitea (TODO)
- Vaultwarden (TODO)
