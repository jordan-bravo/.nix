# ~/.nix/shared/zellij.nix

{
  programs.zellij = {
    enable = false;
    enableZshIntegration = false;
    settings = {
      ui.pane_frames.rounded_corners = true;
      keybinds = {
        "unbind \"Ctrl b\"" = [];
        "unbind \"Ctrl h\"" = [];
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
pane_frames false
keybinds {
    move {
        bind "Ctrl x" { SwitchToMode "Normal"; }
    }
    normal {
        unbind "Ctrl h"
        unbind "Ctrl b"
        unbind "Ctrl o"
        }
    scroll {
        bind "/" {
            SwitchToMode "EnterSearch"
            SearchInput 0
        }
    }
    session {
        bind "Alt s" { SwitchToMode "Normal"; }
        unbind "Ctrl o"
    }
    shared_among "search" "scroll" {
        bind "End" "G" {
            ScrollToBottom
        }
        bind "Home" {
            ScrollToTop
        }
    }
    shared_except "session" "locked" {
        bind "Alt s" { SwitchToMode "Session"; }
        unbind "Ctrl o"
    }
    shared_except "move" "locked" {
        bind "Ctrl x" { SwitchToMode "Move"; }
    }
    // these are the defaults for entersearch
    // might want to change or add to them later
    entersearch {
        bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
        bind "Enter" { SwitchToMode "Search"; }
    }
}
ui {
    pane_frames {
        rounded_corners true
    }
}
*/
