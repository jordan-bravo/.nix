# sovserv/caddy.nix
{ pkgs, config, plugins, ... }:

with pkgs;

stdenv.mkDerivation rec {
  pname = "caddy";
  # https://github.com/NixOS/nixpkgs/issues/113520
  version = "latest";
  dontUnpack = true;
  meta.mainProgram = "caddy";

  nativeBuildInputs = [ git go xcaddy ];

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
  '';

  buildPhase =
    let
      pluginArgs = lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
    in
    ''
      runHook preBuild
      ${xcaddy}/bin/xcaddy build latest ${pluginArgs}
      runHook postBuild
    '';


  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv caddy $out/bin
    runHook postInstall
  '';
}
