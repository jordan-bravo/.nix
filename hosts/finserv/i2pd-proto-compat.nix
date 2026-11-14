# nixpkgs rewrote its i2pd module to be `settings`-based (freeform i2pd.conf)
# and dropped the old `services.i2pd.proto.*` options without renames.
# nix-bitcoin master (which targets nixos-26.05) still uses them:
#   modules/netns-isolation.nix sets `proto.sam.address` and reads `proto.sam.port`
#   modules/bitcoind.nix        sets `proto.sam.enable` and reads `proto.sam.{address,port}`
# Even with both of those behind a disabled `mkIf`, evaluation fails with
# "The option `services.i2pd.proto' does not exist".
#
# So re-declare the old option tree here and forward it into `settings`.
# Remove this file once nix-bitcoin is updated for the new i2pd module.
{
  config,
  lib,
  ...
}:

let
  cfg = config.services.i2pd;

  # Old option name -> i2pd.conf section name plus the old nixpkgs defaults.
  endpoints = {
    http = {
      section = "http";
      address = "127.0.0.1";
      port = 7070;
    };
    httpProxy = {
      section = "httpproxy";
      address = "127.0.0.1";
      port = 4444;
    };
    socksProxy = {
      section = "socksproxy";
      address = "127.0.0.1";
      port = 4447;
    };
    sam = {
      section = "sam";
      address = "127.0.0.1";
      port = 7656;
    };
    bob = {
      section = "bob";
      address = "127.0.0.1";
      port = 2827;
    };
    i2cp = {
      section = "i2cp";
      address = "127.0.0.1";
      port = 7654;
    };
    i2pControl = {
      section = "i2pcontrol";
      address = "127.0.0.1";
      port = 7650;
    };
  };
in
{
  options.services.i2pd.proto = lib.mapAttrs (_: e: {
    enable = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = ''
        Whether to enable the ${e.section} endpoint.
        `null` leaves the `settings.${e.section}.enabled` default alone.
      '';
    };
    address = lib.mkOption {
      type = lib.types.str;
      default = e.address;
      description = "Bind address for the ${e.section} endpoint.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = e.port;
      description = "Bind port for the ${e.section} endpoint.";
    };
  }) endpoints;

  # Only `enabled` is forwarded at normal priority, to override the i2pd
  # module's own `mkDefault`. Address and port are `mkDefault`s so that a
  # direct `settings.<section>.{address,port}` definition still wins.
  config.services.i2pd.settings = lib.mkMerge (
    lib.mapAttrsToList (
      name: e:
      let
        proto = cfg.proto.${name};
      in
      {
        ${e.section} =
          {
            address = lib.mkDefault proto.address;
            port = lib.mkDefault proto.port;
          }
          // lib.optionalAttrs (proto.enable != null) { enabled = proto.enable; };
      }
    ) endpoints
  );
}
