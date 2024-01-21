# ~/.nix/shared/zellij.nix

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      ui.pane_frames.rounded_corners = true;
      keybinds = {
        scroll = {
          "bind \"/\"" = {
            SwitchToMode = "EnterSearch";
            SearchInput = 0;
          };
        };
        shared_among = {
          _args = [ "search" "scroll" ];
          "bind \"End\"" = {
            ScrollToBottom = [ ];
          };
          "bind \"Home\"" = {
            ScrollToTop = [ ];
          };
        };
      };
      layout = {
        default_tab_template = {
          "pane borderless=true split_direction=\"vertical\"" = [ ];
        };
      };
    };
  };
}

/*
  keybinds {
      scroll {
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
  layout {
      default_tab_template {
          pane borderless=true
      }
  }
*/
