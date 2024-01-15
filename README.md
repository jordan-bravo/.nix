# Jordan's Nix Configurations

### Uses Flakes, Home Manager, and Nix Darwin (for MacOS hosts)

I have tried to put as much of the configuration as possible into Home Manager in order to be portable across different environments.

## Hosts

`tux`: My main personal laptop running NixOS and using Home Manager.  ISA: `x86_64-linux`

`thinky`: My work laptop, currently running Ubuntu 22.04 and using the Nix package manager and Home Manager. ISA: `x86_64-linux`

`mbp`: My former work laptop, a MacBook with M1 (ARM) chip running MacOS, using Nix-Darwin and Home Manager. No longer in use, config might be outdated. ISA: `aarch64-darwin`

`shared`: Configuration that can be shared across multiple hosts.

## TODO (High Level)

- (in progress) My [Neovim configuration](https://github.com/jordan-bravo/nvim) is currently not managed by Nix.  I plan to add all Neovim configuration to Nix.
- Add Hyprland on Linux hosts.
- Convert servers from Ubuntu to NixOS.

### Task List (Low Level)

- Zellij: remap ctrl-h (enters move mode) because it's used by neovim to move windows
- home-manager switch command leads to MediaKeys systemd service failing.
- Configure zsh autosuggest/autocomplete (which one? both?) to avoid using arrow keys for completion.
- Remove repetition by declaring username only once in flake.nix, then passing to other modules.

### Research Needed

- On non-NixOS systems, how to declaritively configure things not available in home manger?
    - Postgres/Redis <-- solution for Alta is to run these in containers
    - Docker <-- Possibly replace with Podman which doesn't require root and might be nixable
    - Flatpak <-- No way that I know of to declaritively configure Flatpaks

---

### Notes

Here is the console output of `sudo apt install -y podman` on Ubuntu 22.04:
```
❯ sudo apt install -y podman
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  buildah catatonit conmon containernetworking-plugins crun fuse-overlayfs golang-github-containernetworking-plugin-dnsname golang-github-containers-common golang-github-containers-image libyajl2 uidmap
Suggested packages:
  containers-storage docker-compose
The following NEW packages will be installed:
  buildah catatonit conmon containernetworking-plugins crun fuse-overlayfs golang-github-containernetworking-plugin-dnsname golang-github-containers-common golang-github-containers-image libyajl2 podman uidmap
0 upgraded, 12 newly installed, 0 to remove and 5 not upgraded.
Need to get 25.0 MB of archives.
After this operation, 109 MB of additional disk space will be used.
Get:1 http://us.archive.ubuntu.com/ubuntu jammy-updates/universe amd64 uidmap amd64 1:4.8.1-2ubuntu2.1 [22.4 kB]
Get:2 http://us.archive.ubuntu.com/ubuntu jammy/universe amd64 golang-github-containers-image all 5.16.0-3 [29.3 kB]
Get:3 http://us.archive.ubuntu.com/ubuntu jammy/universe amd64 golang-github-containers-common all 0.44.4+ds1-1 [28.1 kB]
Get:4 http://us.archive.ubuntu.com/ubuntu jammy/universe amd64 buildah amd64 1.23.1+ds1-2 [6,094 kB]
Get:5 http://us.archive.ubuntu.com/ubuntu jammy/universe amd64 catatonit amd64 0.1.7-1 [307 kB]
Get:6 http://us.archive.ubuntu.com/ubuntu jammy/universe amd64 conmon amd64 2.0.25+ds1-1.1 [35.1 kB]
Get:7 http://us.archive.ubuntu.com/ubuntu jammy/universe amd64 containernetworking-plugins amd64 0.9.1+ds1-1 [6,422 kB]
Get:8 http://us.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libyajl2 amd64 2.1.0-3ubuntu0.22.04.1 [21.0 kB]
Get:9 http://us.archive.ubuntu.com/ubuntu jammy/universe amd64 crun amd64 0.17+dfsg-1.1 [300 kB]
Get:10 http://us.archive.ubuntu.com/ubuntu jammy/universe amd64 fuse-overlayfs amd64 1.7.1-1 [44.7 kB]
Get:11 http://us.archive.ubuntu.com/ubuntu jammy/universe amd64 golang-github-containernetworking-plugin-dnsname amd64 1.3.1+ds1-2 [1,083 kB]
Get:12 http://us.archive.ubuntu.com/ubuntu jammy-updates/universe amd64 podman amd64 3.4.4+ds1-1ubuntu1.22.04.2 [10.6 MB]
Fetched 25.0 MB in 1s (17.8 MB/s)   
Selecting previously unselected package uidmap.
(Reading database ... 194741 files and directories currently installed.)
Preparing to unpack .../00-uidmap_1%3a4.8.1-2ubuntu2.1_amd64.deb ...
Unpacking uidmap (1:4.8.1-2ubuntu2.1) ...
Selecting previously unselected package golang-github-containers-image.
Preparing to unpack .../01-golang-github-containers-image_5.16.0-3_all.deb ...
Unpacking golang-github-containers-image (5.16.0-3) ...
Selecting previously unselected package golang-github-containers-common.
Preparing to unpack .../02-golang-github-containers-common_0.44.4+ds1-1_all.deb ...
Unpacking golang-github-containers-common (0.44.4+ds1-1) ...
Selecting previously unselected package buildah.
Preparing to unpack .../03-buildah_1.23.1+ds1-2_amd64.deb ...
Unpacking buildah (1.23.1+ds1-2) ...
Selecting previously unselected package catatonit.
Preparing to unpack .../04-catatonit_0.1.7-1_amd64.deb ...
Unpacking catatonit (0.1.7-1) ...
Selecting previously unselected package conmon.
Preparing to unpack .../05-conmon_2.0.25+ds1-1.1_amd64.deb ...
Unpacking conmon (2.0.25+ds1-1.1) ...
Selecting previously unselected package containernetworking-plugins.
Preparing to unpack .../06-containernetworking-plugins_0.9.1+ds1-1_amd64.deb ...
Unpacking containernetworking-plugins (0.9.1+ds1-1) ...
Selecting previously unselected package libyajl2:amd64.
Preparing to unpack .../07-libyajl2_2.1.0-3ubuntu0.22.04.1_amd64.deb ...
Unpacking libyajl2:amd64 (2.1.0-3ubuntu0.22.04.1) ...
Selecting previously unselected package crun.
Preparing to unpack .../08-crun_0.17+dfsg-1.1_amd64.deb ...
Unpacking crun (0.17+dfsg-1.1) ...
Selecting previously unselected package fuse-overlayfs.
Preparing to unpack .../09-fuse-overlayfs_1.7.1-1_amd64.deb ...
Unpacking fuse-overlayfs (1.7.1-1) ...
Selecting previously unselected package golang-github-containernetworking-plugin-dnsname.
Preparing to unpack .../10-golang-github-containernetworking-plugin-dnsname_1.3.1+ds1-2_amd64.deb ...
Unpacking golang-github-containernetworking-plugin-dnsname (1.3.1+ds1-2) ...
Selecting previously unselected package podman.
Preparing to unpack .../11-podman_3.4.4+ds1-1ubuntu1.22.04.2_amd64.deb ...
Unpacking podman (3.4.4+ds1-1ubuntu1.22.04.2) ...
Setting up uidmap (1:4.8.1-2ubuntu2.1) ...
Setting up libyajl2:amd64 (2.1.0-3ubuntu0.22.04.1) ...
Setting up golang-github-containers-image (5.16.0-3) ...
Setting up conmon (2.0.25+ds1-1.1) ...
Setting up containernetworking-plugins (0.9.1+ds1-1) ...
Setting up catatonit (0.1.7-1) ...
Setting up golang-github-containernetworking-plugin-dnsname (1.3.1+ds1-2) ...
Setting up fuse-overlayfs (1.7.1-1) ...
Setting up golang-github-containers-common (0.44.4+ds1-1) ...
Setting up buildah (1.23.1+ds1-2) ...
Setting up crun (0.17+dfsg-1.1) ...
Setting up podman (3.4.4+ds1-1ubuntu1.22.04.2) ...
Created symlink /etc/systemd/user/default.target.wants/podman.service → /usr/lib/systemd/user/podman.service.
Created symlink /etc/systemd/user/sockets.target.wants/podman.socket → /usr/lib/systemd/user/podman.socket.
Created symlink /etc/systemd/system/default.target.wants/podman.service → /lib/systemd/system/podman.service.
Created symlink /etc/systemd/system/sockets.target.wants/podman.socket → /lib/systemd/system/podman.socket.
Created symlink /etc/systemd/system/default.target.wants/podman-auto-update.service → /lib/systemd/system/podman-auto-update.service.
Created symlink /etc/systemd/system/timers.target.wants/podman-auto-update.timer → /lib/systemd/system/podman-auto-update.timer.
Created symlink /etc/systemd/system/default.target.wants/podman-restart.service → /lib/systemd/system/podman-restart.service.
Processing triggers for libc-bin (2.35-0ubuntu3.5) ...
Processing triggers for man-db (2.10.2-1) ...

```

