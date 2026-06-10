# niri.nix
{ pkgs, ... }: {

  home.packages = with pkgs; [
    niri
    awww
    mako
    libnotify
    wl-clipboard
    krita
    xwayland-satellite
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "kitty";
        font = "JetBrains Mono:size=12";
        show-actions = "yes";
        lines = 15;
        width = 50;
      };
      colors = {
        background = "#181825ff";
        text = "#5050f9ff";
        selection = "#af5f0bff";
        selection-text = "'#cdd6f4ff";
        border = "#252d21ff";
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };

  xdg.configFile."niri/config.kdl".text = ''
    input {
      keyboard {
        repeat-delay 600
        repeat-rate 25
      }
      mouse {
        accel-profile "flat"
      }
      tablet {
        map-to-output "DP-1"
      }
    }

    output "DP-3" {
      mode "2560x1440@144"
      position x=0 y=0
      scale 1.0
    }
    output "DP-1" {
      mode "2560x1440@170"
      position x=2560 y=0
      scale 1.0
    }
    output "DP-2" {
      mode "2560x1440@60"
      position x=5120 y=0
      scale 1.0
      transform "90"
    }

    layout {
      gaps 8
      center-focused-column "never"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width { proportion 0.5; }

      focus-ring {
        width 2
        active-color "#33ccffee"
        inactive-color "#595959aa"
      }

      border {
        off
      }
    }

    animations {
      slowdown 1.0
    }

    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "awww-daemon"
    spawn-at-startup "sh" "-c" "sleep 1 && awww img --outputs DP-1 ~/Pictures/Wallpapers/small_neighborhood_3840x2160.png && awww img --outputs DP-2 ~/Pictures/Wallpapers/japanese_house_1440x2560.png && awww img --outputs DP-3 ~/Pictures/Wallpapers/woods_mountain.png"
    spawn-at-startup "xwayland-satellite"

    binds {
      Mod+A { spawn "kitty"; }
      Mod+B { spawn "librewolf"; }
      Mod+E { spawn "nautilus"; }
      Mod+D { spawn "fuzzel"; }

      Print { screenshot; }
      Shift+Print { screenshot-screen; }
      Alt+Print { screenshot-window; }

      Mod+Shift+Q { close-window; }
      Mod+F { fullscreen-window; }
      Mod+V { toggle-window-floating; }

      Mod+H { focus-column-left; }
      Mod+L { focus-column-right; }
      Mod+K { focus-window-up; }
      Mod+J { focus-window-down; }

      Mod+Shift+H { move-column-left; }
      Mod+Shift+L { move-column-right; }
      Mod+Shift+K { move-window-up; }
      Mod+Shift+J { move-window-down; }

      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }
      Mod+Shift+slash { show-hotkey-overlay; }
      Mod+Shift+C { spawn "sh" "-c" "niri msg action load-config-file ~/.config/niri/config.kdl"; }
      Mod+R { switch-preset-column-width; }

      Mod+I { consume-window-into-column; }
      Mod+O { expel-window-from-column; }

      Mod+Alt+H  { focus-monitor-left; }
      Mod+Alt+L { focus-monitor-right; }

      Mod+Shift+Alt+H  { move-column-to-monitor-left; }
      Mod+Shift+Alt+L { move-column-to-monitor-right; }

      Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }

      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }

      Mod+Shift+1 { move-window-to-workspace 1; }
      Mod+Shift+2 { move-window-to-workspace 2; }
      Mod+Shift+3 { move-window-to-workspace 3; }
      Mod+Shift+4 { move-window-to-workspace 4; }
      Mod+Shift+5 { move-window-to-workspace 5; }
      Mod+Shift+6 { move-window-to-workspace 6; }
      Mod+Shift+7 { move-window-to-workspace 7; }
      Mod+Shift+8 { move-window-to-workspace 8; }
      Mod+Shift+9 { move-window-to-workspace 9; }

      Mod+M { quit; }
    }
  '';
}
