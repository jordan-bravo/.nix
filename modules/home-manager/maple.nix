# ~/.nix/modules/home-manager/maple.nix
#
# Maple AI desktop app, repacked from upstream's AppImage.
#
# TEMPORARY WORKAROUND MODULE. Upstream's Linux AppImage ships several libraries
# without the runtime data they need and relies on the host to supply it. Two
# issues are filed against OpenSecretCloud/Maple (2026-08-20):
#
#   1. No glib-networking GIO module is bundled, so GIO has no TLS backend and
#      every HTTPS request fails. It surfaces at login as the very misleading
#      "Couldn't process attestation document: Load failed" ("Load failed" is
#      WebKit's generic fetch() network error, not an attestation problem).
#   2. GTK3 is broken in the bundle, so any file dialog aborts the whole process
#      -- e.g. Agent Mode's "Select a folder".
#
# Each defect is repaired in the AppDir at build time, so the app's own AppRun
# picks everything up with no environment overrides at runtime.
#
# Once upstream ships fixed AppImages, delete this file, drop its import from
# hosts/tux/home.nix, and switch to a plain appimageTools.wrapType2 (or whatever
# upstream packages themselves).
#
# To bump the version, change `version` and refresh the hash with:
#   nix store prefetch-file --hash-type sha256 \
#     https://github.com/OpenSecretCloud/Maple/releases/download/vX.Y.Z/Maple_X.Y.Z_amd64.AppImage
#
# After bumping, re-check that the two workarounds are still needed: if upstream
# has fixed them, the postExtract steps become harmless no-ops at best and can
# silently mask a regression at worst.

{ pkgs, lib, ... }:

let
  pname = "maple";
  version = "3.3.4";

  src = pkgs.fetchurl {
    url = "https://github.com/OpenSecretCloud/Maple/releases/download/v${version}/Maple_${version}_amd64.AppImage";
    hash = "sha256-G1Tgq6EOmqgxCWuAN8WnvvL7kgu8JNOG/X+xRXM3eDk=";
  };

  contents = pkgs.appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      chmod -R u+w "$out"

      # (1) TLS backend. apprun-hooks/linuxdeploy-plugin-gtk.sh points
      # GIO_EXTRA_MODULES at the AppDir root, so dropping the module there is
      # enough -- no GIO_MODULE_DIR override needed.
      install -Dm444 ${pkgs.glib-networking}/lib/gio/modules/libgiognutls.so \
        "$out/libgiognutls.so"

      # (2a) The bundled libgtk-3.so.0 has been ELF-rewritten by upstream's
      # packaging and can no longer load its own embedded GResources, so building
      # any composite-template widget aborts:
      #   Gtk:ERROR:gtkfilechooserwidget.c:8779:post_process_ui: assertion failed: (cells)
      # Only libgtk is replaced -- the bundled libgdk is deliberately left alone,
      # because libgtk-from-store + libgdk-from-bundle is the combination that was
      # actually tested.
      install -Dm555 "$(readlink -f ${pkgs.gtk3}/lib/libgtk-3.so.0)" \
        "$out/usr/lib/libgtk-3.so.0"

      # (2b) No GTK3 GSettings schemas are bundled, and a GTK4-era GNOME does not
      # provide them either, so the file chooser aborts with
      #   Settings schema 'org.gtk.Settings.FileChooser' is not installed
      # AppRun already points GSETTINGS_SCHEMA_DIR at this directory.
      install -Dm444 ${pkgs.gtk3}/share/gsettings-schemas/gtk+3-*/glib-2.0/schemas/gschemas.compiled \
        "$out/usr/share/glib-2.0/schemas/gschemas.compiled"
    '';
  };

  desktopItem = pkgs.makeDesktopItem {
    name = pname;
    exec = "${pname} %u";
    icon = pname;
    desktopName = "Maple";
    comment = "Maple AI - Private AI Chat";
    categories = [
      "Network"
      "Chat"
      "Utility"
    ];
    startupWMClass = "maple";
    mimeTypes = [ "x-scheme-handler/cloud.opensecret.maple" ];
  };

  maple = pkgs.appimageTools.wrapAppImage {
    inherit pname version contents;

    extraInstallCommands = ''
      cp -r --no-preserve=mode,ownership ${desktopItem}/share "$out/"

      for size in 32x32 128x128 256x256@2; do
        icon="${contents}/usr/share/icons/hicolor/$size/apps/maple.png"
        [ -e "$icon" ] || continue
        install -Dm444 "$icon" "$out/share/icons/hicolor/$size/apps/maple.png"
      done
    '';

    meta = {
      description = "Private AI chat client, repacked from upstream's AppImage with GIO/GTK fixes";
      homepage = "https://trymaple.ai";
      license = lib.licenses.mit;
      platforms = [ "x86_64-linux" ];
      mainProgram = "maple";
    };
  };
in
{
  home.packages = [ maple ];
}
