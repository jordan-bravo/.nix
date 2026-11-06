# Maple Work (upstream: apps/maple-agent in MaplePrivacyLabs/Maple), the native
# GPUI successor to the Tauri "Maple" chat app (no longer installed here).
#
# Repacked from upstream's prebuilt Prod Linux bundle. It isn't on GitHub
# releases (those are Maple Chat only); the app's own update feed points at it:
#   curl -s https://updates.maple.ai/agent/stable/linux/latest.json
# To update: take `version`, the bundle `path` and its `sha256` from that feed's
# `manifest` (hex sha256; `nix hash convert --hash-algo sha256 <hex>` for SRI).
# Building from source instead (upstream's flake) takes ~25 min per bump because
# of fat LTO with codegen-units=1, and needed a vendoring fix for cua-driver.
#
# Prod's self-updater can't replace a read-only store path, so it is switched off.
{ pkgs, lib, ... }:

let
  bundleId = "cloud.opensecret.maple.agent";

  maple-agent = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "maple-agent";
    version = "0.0.18";

    src = pkgs.fetchurl {
      url = "https://updates.maple.ai/agent/stable/releases/${finalAttrs.version}/maple-agent-prod-${finalAttrs.version}-568f790-linux-x86_64.tar.gz";
      hash = "sha256-Zjxh3rRnnwPMy97vjuojZ0Kjq6Uva6+CUarBoX/YmpI=";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      makeWrapper
    ];

    # Linked libraries. The bundle ships its own copies in usr/lib; these are
    # used instead so they match the rest of the system.
    buildInputs = with pkgs; [
      alsa-lib
      libxcb
      libxkbcommon
      libx11
      libxi
    ];

    # GPUI and the embedded Cua driver dlopen these, so ELF scanning misses
    # them (list from upstream's flake). autoPatchelf adds them to RUNPATH
    # rather than LD_LIBRARY_PATH, which would leak into the agent's shell tools.
    runtimeDependencies = with pkgs; [
      addDriverRunpath.driverLink
      libglvnd
      libxkbcommon
      vulkan-loader
      wayland
      libxtst
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 usr/bin/maple-agent "$out/bin/maple-agent"
      mkdir -p "$out/share"
      cp -r usr/share/applications usr/share/icons "$out/share/"

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram "$out/bin/maple-agent" --set MAPLE_DISABLE_UPDATE_CHECK 1
    '';

    meta = {
      description = "Native Maple desktop app built with GPUI";
      homepage = "https://github.com/MaplePrivacyLabs/Maple/tree/master/apps/maple-agent";
      license = lib.licenses.mit;
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "maple-agent";
    };
  });
in
{
  environment.systemPackages = [ maple-agent ];
}
