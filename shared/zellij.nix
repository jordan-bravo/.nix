# ~/.nix/shared/zellij.nix

{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      ui.pane_frames.rounded_corners = true;
      keybinds = {
        search = {
          "bind \"/\"" = { 
            SwitchToMode = "EnterSearch"; 
            SearchInput = 0; 
          };
        };
        shared_among = {
          _args = [ "search" "scroll" ];
          "bind \"End\"" = {
            ScrollToBottom = [];
          };
          "bind \"Home\"" = {
            ScrollToTop = [];
          };
        };
      };
    };
  };
}

    /*
      keybinds {
          search {
              bind "/" { 
                  SwitchToMode "EnterSearch"
                  SearchInput 0
              }
          }

          shared_among "search" "scroll" {
              bind "End" { 
                ScrollToBottom
              }
              bind "Home" {
                ScrollToTop
              }
          }
      }
      ui {
          pane_frames {
              rounded_corners true
          }
      }
    */
