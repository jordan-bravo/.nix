{ lib, pkgs, ... }:

{
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";

    # System Manager is currently only supported on NixOS and Ubuntu. However, it can be used on other distributions by enabling the following:

    # system-manager.allowAnyDistro = true;

    environment = {
      etc = {
        "foo.conf".text = ''
          launch_the_rockets = true
        '';
      };
      systemPackages = [
        pkgs.hello
        # pkgs.tailscale
      ];
    };

    systemd.services = {
      # tailscaled = {
      #   enable = true;
      #   description = "Tailscale node agent";
      #   documentation = "https://tailscale.com/kb/";
      #   wants = [ "network-pre.target" ];
      #   after = [
      #     "network-pre.target"
      #     "NetworkManager.service"
      #     "systemd-resolved.service"
      #   ];
      #   serviceConfig = {
      #     Type = "notify";
      #   };
      #   wantedBy = [ "multi-user.target" ];
      # };
      foo = {
        enable = true;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        wantedBy = [ "system-manager.target" ];
        script = ''
          ${lib.getBin pkgs.hello}/bin/hello
          echo "We launched the rockets!"
        '';
      };
    };
  };
}

# Use the following command in ~/.nix
# sudo $(which system-manager) switch --flake '.'
# If you get the message: sudo: system-manager: command not found
# then run this command once and try again:
# nix profile install 'github:numtide/system-manager'

/*
  ❯ cat -p /etc/systemd/system/multi-user.target.wants/tailscaled.service
  [Unit]
  Description=Tailscale node agent
  Documentation=https://tailscale.com/kb/
  Wants=network-pre.target
  After=network-pre.target NetworkManager.service systemd-resolved.service

  [Service]
  EnvironmentFile=/etc/default/tailscaled
  ExecStart=/usr/sbin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/run/tailscale/tailscaled.sock --port=${PORT} $FLAGS
  ExecStopPost=/usr/sbin/tailscaled --cleanup

  Restart=on-failure

  RuntimeDirectory=tailscale
  RuntimeDirectoryMode=0755
  StateDirectory=tailscale
  StateDirectoryMode=0700
  CacheDirectory=tailscale
  CacheDirectoryMode=0750
  Type=notify

  [Install]
  WantedBy=multi-user.target
*/

/*
  ❯ cat -p /etc/systemd/system/multi-user.target.wants/containerd.service
  # Copyright The containerd Authors.
  #
  # Licensed under the Apache License, Version 2.0 (the "License");
  # you may not use this file except in compliance with the License.
  # You may obtain a copy of the License at
  #
  #     http://www.apache.org/licenses/LICENSE-2.0
  #
  # Unless required by applicable law or agreed to in writing, software
  # distributed under the License is distributed on an "AS IS" BASIS,
  # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  # See the License for the specific language governing permissions and
  # limitations under the License.

  [Unit]
  Description=containerd container runtime
  Documentation=https://containerd.io
  After=network.target local-fs.target

  [Service]
  ExecStartPre=-/sbin/modprobe overlay
  ExecStart=/usr/bin/containerd

  Type=notify
  Delegate=yes
  KillMode=process
  Restart=always
  RestartSec=5
  # Having non-zero Limit*s causes performance problems due to accounting overhead
  # in the kernel. We recommend using cgroups to do container-local accounting.
  LimitNPROC=infinity
  LimitCORE=infinity
  LimitNOFILE=infinity
  # Comment TasksMax if your systemd version does not supports it.
  # Only systemd 226 and above support this version.
  TasksMax=infinity
  OOMScoreAdjust=-999

  [Install]
  WantedBy=multi-user.target
 */

/*
  ❯ cat -p /etc/systemd/system/multi-user.target.wants/docker.service
  [Unit]
  Description=Docker Application Container Engine
  Documentation=https://docs.docker.com
  After=network-online.target docker.socket firewalld.service containerd.service time-set.target
  Wants=network-online.target containerd.service
  Requires=docker.socket

  [Service]
  Type=notify
  # the default is not to use systemd for cgroups because the delegate issues still
  # exists and systemd currently does not support the cgroup feature set required
  # for containers run by docker
  ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
  ExecReload=/bin/kill -s HUP $MAINPID
  TimeoutStartSec=0
  RestartSec=2
  Restart=always

  # Note that StartLimit* options were moved from "Service" to "Unit" in systemd 229.
  # Both the old, and new location are accepted by systemd 229 and up, so using the old location
  # to make them work for either version of systemd.
  StartLimitBurst=3

  # Note that StartLimitInterval was renamed to StartLimitIntervalSec in systemd 230.
  # Both the old, and new name are accepted by systemd 230 and up, so using the old name to make
  # this option work for either version of systemd.
  StartLimitInterval=60s

  # Having non-zero Limit*s causes performance problems due to accounting overhead
  # in the kernel. We recommend using cgroups to do container-local accounting.
  LimitNPROC=infinity
  LimitCORE=infinity

  # Comment TasksMax if your systemd version does not support it.
  # Only systemd 226 and above support this option.
  TasksMax=infinity

  # set delegate yes so that systemd does not reset the cgroups of docker containers
  Delegate=yes

  # kill only the docker process, not all processes in the cgroup
  KillMode=process
  OOMScoreAdjust=-500

  [Install]
  WantedBy=multi-user.target
*/

/*
  ❯ cat -p /etc/systemd/system/sockets.target.wants/docker.socket
  [Unit]
  Description=Docker Socket for the API

  [Socket]
  # If /var/run is not implemented as a symlink to /run, you may need to
  # specify ListenStream=/var/run/docker.sock instead.
  ListenStream=/run/docker.sock
  SocketMode=0660
  SocketUser=root
  SocketGroup=docker

  [Install]
  WantedBy=sockets.target
*/

