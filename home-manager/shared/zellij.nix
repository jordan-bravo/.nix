# ~/.nix/shared/zellij.nix

{
  home.file = {
    zellij-config = {
      target = ".config/zellij/config.kdl";
      enable = true;
      text = ''
        pane_frames false
        keybinds {
            // these are the defaults for entersearch
            // might want to change or add to them later
            entersearch {
                bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
                bind "Enter" { SwitchToMode "Search"; }
            }
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
                bind "Home" "g" {
                    ScrollToTop
                }
            }
            shared_except "locked" {
                bind "Alt [" { PreviousSwapLayout; }
                bind "Alt ]" { NextSwapLayout; }
            }
            shared_except "move" "locked" {
                bind "Ctrl x" { SwitchToMode "Move"; }
            }
            shared_except "session" "locked" {
                bind "Alt s" { SwitchToMode "Session"; }
                unbind "Ctrl o"
            }
        }
        ui {
            pane_frames {
                rounded_corners true
            }
        }
      '';
    };
    zellij-layout = {
      target = ".config/zellij/layouts/default.kdl";
      enable = true;
      text = ''
        layout {
            pane size=1 borderless=true {
                plugin location="tab-bar"
            }
            pane
            // Uncomment to show status bar
            // pane size=2 borderless=true {
            //     plugin location="status-bar"
            // }

            tab_template name="ui" {
              pane size=1 borderless=true {
                  plugin location="tab-bar"
              }
              children
            }

            swap_tiled_layout name="vertical" {
                ui max_panes=5 {
                    pane split_direction="vertical" {
                        pane
                        pane { children; }
                    }
                }
                ui max_panes=8 {
                    pane split_direction="vertical" {
                        pane { children; }
                        pane { pane; pane; pane; pane; }
                    }
                }
                ui max_panes=12 {
                    pane split_direction="vertical" {
                        pane { children; }
                        pane { pane; pane; pane; pane; }
                        pane { pane; pane; pane; pane; }
                    }
                }
            }

            swap_tiled_layout name="horizontal" {
                ui max_panes=5 {
                    pane
                    pane
                }
                ui max_panes=8 {
                    pane {
                        pane split_direction="vertical" { children; }
                        pane split_direction="vertical" { pane; pane; pane; pane; }
                    }
                }
                ui max_panes=12 {
                    pane {
                        pane split_direction="vertical" { children; }
                        pane split_direction="vertical" { pane; pane; pane; pane; }
                        pane split_direction="vertical" { pane; pane; pane; pane; }
                    }
                }
            }

            swap_tiled_layout name="stacked" {
                ui min_panes=5 {
                    pane split_direction="vertical" {
                        pane
                        pane stacked=true { children; }
                    }
                }
            }


            swap_floating_layout name="staggered" {
                floating_panes
            }

            swap_floating_layout name="enlarged" {
                floating_panes max_panes=10 {
                    pane { x "5%"; y 1; width "90%"; height "90%"; }
                    pane { x "5%"; y 2; width "90%"; height "90%"; }
                    pane { x "5%"; y 3; width "90%"; height "90%"; }
                    pane { x "5%"; y 4; width "90%"; height "90%"; }
                    pane { x "5%"; y 5; width "90%"; height "90%"; }
                    pane { x "5%"; y 6; width "90%"; height "90%"; }
                    pane { x "5%"; y 7; width "90%"; height "90%"; }
                    pane { x "5%"; y 8; width "90%"; height "90%"; }
                    pane { x "5%"; y 9; width "90%"; height "90%"; }
                    pane focus=true { x 10; y 10; width "90%"; height "90%"; }
                }
            }

            swap_floating_layout name="spread" {
                floating_panes max_panes=1 {
                    pane {y "50%"; x "50%"; }
                }
                floating_panes max_panes=2 {
                    pane { x "1%"; y "25%"; width "45%"; }
                    pane { x "50%"; y "25%"; width "45%"; }
                }
                floating_panes max_panes=3 {
                    pane focus=true { y "55%"; width "45%"; height "45%"; }
                    pane { x "1%"; y "1%"; width "45%"; }
                    pane { x "50%"; y "1%"; width "45%"; }
                }
                floating_panes max_panes=4 {
                    pane { x "1%"; y "55%"; width "45%"; height "45%"; }
                    pane focus=true { x "50%"; y "55%"; width "45%"; height "45%"; }
                    pane { x "1%"; y "1%"; width "45%"; height "45%"; }
                    pane { x "50%"; y "1%"; width "45%"; height "45%"; }
                }
            }
        }
      '';
    };
  };
  programs.zellij = {
    enable = false;
    enableZshIntegration = false;
    settings = {
      ui.pane_frames.rounded_corners = true;
      keybinds = {
        "unbind \"Ctrl b\"" = [ ];
        "unbind \"Ctrl h\"" = [ ];
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
