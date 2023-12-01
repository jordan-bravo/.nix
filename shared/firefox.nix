# ~/.nix/shared/firefix.nix

{ config, pkgs, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.jordan = {
      search = {
        default = "Startpage";  
        privateDefault = "Startpage";
        engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };
          "Startpage" = {
            urls = [{ template = "https://www.startpage.com/search?q={searchTerms}"; }];
            iconUpdateURL = "https://www.startpage.com/sp/cdn/favicons/favicon--default.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@s" ];
          };
        };
      };
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        darkreader
        ublock-origin
        vimium-c
      ];
      settings = {
        "dom.security.https_only_mode" = true;
      };
    };
  };
}
