# Maple Work (upstream: apps/maple-agent in MaplePrivacyLabs/Maple), the native
# GPUI successor to the Tauri "Maple" app in modules/home-manager/maple.nix.
#
# Built from source with upstream's own flake (input `maple-agent`). Upstream
# publishes Linux builds only as CI artifacts / a self-updating tar bundle, so
# there is nothing stable to fetch.
#
# A plain `nix build` of upstream's flake produces the "unpackaged" profile
# ("Maple Work Debug", app_id ...agent.debug, no hosted browser sign-in return).
# We set the same env as upstream's scripts/build-release.sh to get the real
# Prod profile instead. Prod's self-updater can't replace a read-only store path,
# so it is switched off; update with `nix flake update maple-agent`.
{ inputs, pkgs, ... }:

let
  bundleId = "cloud.opensecret.maple.agent";

  cuaSkills = pkgs.fetchFromGitHub {
    owner = "trycua";
    repo = "cua";
    rev = "2a3975570a885f45ef83f7e81bba54a01804ebd0";
    sparseCheckout = [ "libs/cua-driver/rust/Skills" ];
    hash = "sha256-rZ/zEsv1PZHMTd7GbP5c4zrIkouAJ8Z2A4Q0yxlLLn0=";
  };

  maple-agent = inputs.maple-agent.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    env = (old.env or { }) // {
      MAPLE_RELEASE_PROFILE = "prod";
      VITE_OPEN_SECRET_PCR_ENVIRONMENT = "production";
    };

    # Upstream's Nix package is broken since the cua-driver 0.38.0 bump: the
    # cua-driver-core crate include_str!s ../../../Skills/cua-driver/*.md,
    # outside its crate dir. Cargo's git checkout has those files, nixpkgs'
    # per-crate vendoring doesn't. From the writable vendor copy at
    # $NIX_BUILD_TOP/cargo-vendor-dir/<crate>/src it resolves to $NIX_BUILD_TOP/Skills
    # ($cargoDepsCopy is not visible to preBuild in the sandbox, so not used).
    # Keep `rev` in sync with cua-driver-core in apps/maple-agent/Cargo.lock;
    # drop this once upstream's own `nix build` works again.
    preBuild = (old.preBuild or "") + ''
      cp -r ${cuaSkills}/libs/cua-driver/rust/Skills "$NIX_BUILD_TOP/Skills"
    '';

    postFixup = (old.postFixup or "") + ''
      wrapProgram "$out/bin/maple-agent" --set MAPLE_DISABLE_UPDATE_CHECK 1
    '';

    # Mirrors the desktop entry upstream's scripts/linux-install.py writes; the
    # Icon/StartupWMClass must equal the bundle id, which GPUI uses as app_id.
    postInstall = (old.postInstall or "") + ''
      install -Dm444 ${inputs.maple-agent}/app/packaging/maple-agent.png \
        "$out/share/icons/hicolor/512x512/apps/${bundleId}.png"
      install -Dm444 ${desktopItem}/share/applications/${bundleId}.desktop \
        "$out/share/applications/${bundleId}.desktop"
    '';
  });

  desktopItem = pkgs.makeDesktopItem {
    name = bundleId;
    exec = "maple-agent %U";
    icon = bundleId;
    desktopName = "Maple Work";
    categories = [
      "Office"
      "Utility"
    ];
    startupWMClass = bundleId;
  };
in
{
  environment.systemPackages = [ maple-agent ];
}
