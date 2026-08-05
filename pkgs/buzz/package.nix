# Buzz — Block's self-hostable workspace where humans and AI agents share the
# same rooms (Tauri + React desktop client). Packaged here because upstream ships
# only .deb/AppImage/dmg/exe and has no Nix packaging, and Buzz is not in nixpkgs.
# Upstream: https://github.com/block/buzz
{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  alsa-lib,
  cairo,
  gdk-pixbuf,
  glib,
  glib-networking,
  gst_all_1,
  gtk3,
  libsoup_3,
  openssl,
  symlinkJoin,
  webkitgtk_4_1,
}:

# Repack of the upstream .deb rather than the AppImage. The AppImage bundles its
# own GTK/WebKit/GStreamer stack via linuxdeploy, which is what needed the
# libelf/libffi/libzstd additions to appimage-run and the GStreamer plugin shim
# in ~/.local/share. The .deb bundles nothing (Depends: libwebkit2gtk-4.1-0,
# libgtk-3-0), so autoPatchelfHook links it against nixpkgs' own libraries and
# both workarounds become unnecessary.
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "buzz-desktop";
  version = "0.5.5";

  src = fetchurl {
    url = "https://github.com/block/buzz/releases/download/desktop-v${finalAttrs.version}/Buzz_${finalAttrs.version}_amd64.deb";
    hash = "sha256-S9EVpauoNt462ZWth9jLBNAr0KEzxw9kyiMlxlOAjc0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    cairo
    gdk-pixbuf
    glib
    gtk3
    libsoup_3
    openssl
    webkitgtk_4_1
    (lib.getLib stdenv.cc.cc) # libstdc++.so.6, libgcc_s.so.1
  ];

  installPhase = ''
    runHook preInstall

    # buzz-desktop plus six sidecars declared in tauri.conf.json: buzz (CLI),
    # buzz-acp, buzz-agent, buzz-backend-kubernetes, buzz-dev-mcp,
    # git-credential-nostr. Tauri resolves sidecars next to the main binary.
    install -Dm755 -t $out/bin usr/bin/*
    cp -r usr/share $out/

    runHook postInstall
  '';

  # WebKit reaches GStreamer fine here (unlike under the AppImage), but the
  # plugins in webkitgtk's own closure stop at the core set, so decoding the
  # bundled notification sounds fails with "Missing decoder: MPEG-4 AAC".
  # Note GST_PLUGIN_SYSTEM_PATH_1_0 *replaces* the default search path rather
  # than extending it — the join below must therefore carry the core plugins
  # too, not just the extras.
  #
  # Deliberately no pipewiresink. WebKit runs its web process inside a
  # bubblewrap sandbox that binds the PulseAudio socket but not
  # $XDG_RUNTIME_DIR/pipewire-0, so pipewiresink fails there with "Unable to
  # open pipewire remote. Error: Timeout was reached" and notification sounds
  # never play — while the same element works from an unsandboxed gst-launch.
  # Omitting it lets autoaudiosink fall to pulsesink, which reaches
  # pipewire-pulse.
  preFixup =
    let
      gstPlugins = symlinkJoin {
        name = "buzz-gst-plugins";
        paths = with gst_all_1; [
          # .out, not the default output — gstreamer's default is "bin", and the
          # plugins (libgstcoreelements.so: typefind, queue, capsfilter) are in "out".
          gstreamer.out
          gst-plugins-base # decodebin, appsink, appsrc
          gst-plugins-good # autoaudiosink, pulsesink
          gst-plugins-bad
          gst-libav # AAC and friends
        ];
      };
    in
    ''
      gappsWrapperArgs+=(
        --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
        --set GST_PLUGIN_SYSTEM_PATH_1_0 "${gstPlugins}/lib/gstreamer-1.0"
      )
    '';

  meta = {
    description = "Self-hostable workspace where humans and AI agents share the same rooms";
    homepage = "https://buzz.xyz";
    downloadPage = "https://github.com/block/buzz/releases";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "buzz-desktop";
  };
})
