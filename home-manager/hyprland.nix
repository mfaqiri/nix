{
  pkgs,
  inputs,
  ...
}: {
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    settings = {
      ipc = "on";
      splash = false;

      preload = [
        "/home/mfaqiri/Pictures/Wallpapers/japanese_house_1440x2560.png"
        "/home/mfaqiri/Pictures/Wallpapers/small_neighborhood_3840x2160.png"
        "/home/mfaqiri/Pictures/Wallpapers/woods_mountain.png"
      ];

      wallpaper = [
        "DP-2,/home/mfaqiri/Pictures/Wallpapers/japanese_house_1440x2560.png"
        "DP-1,/home/mfaqiri/Pictures/Wallpapers/small_neighborhood_3840x2160.png"
        "DP-3,/home/mfaqiri/Pictures/Wallpapers/woods_mountain.png"
      ];
    };
  };

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

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];

    extraConfig =
      /*
      hyprlang
      */
      ''
        exec-once = waybar

        workspace = 3, monitor:DP-2
        workspace = 2, monitor:DP-1
        workspace = 1, monitor:DP-3

                animations {
                           enabled = yes, please :)

                           # Default animations, see https://wiki.hypr.land/Configuring/Animations/ for more

                           bezier = easeOutQuint,0.23,1,0.32,1
                           bezier = easeInOutCubic,0.65,0.05,0.36,1
                           bezier = linear,0,0,1,1
                           bezier = almostLinear,0.5,0.5,0.75,1.0
                           bezier = quick,0.15,0,0.1,1

                           animation = global, 1, 10, default
                           animation = border, 1, 5.39, easeOutQuint
                           animation = windows, 1, 4.79, easeOutQuint
                           animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
                           animation = windowsOut, 1, 1.49, linear, popin 87%
                           animation = fadeIn, 1, 1.73, almostLinear
                           animation = fadeOut, 1, 1.46, almostLinear
                           animation = fade, 1, 3.03, quick
                           animation = layers, 1, 3.81, easeOutQuint
                           animation = layersIn, 1, 4, easeOutQuint, fade
                           animation = layersOut, 1, 1.5, linear, fade
                           animation = fadeLayersIn, 1, 1.79, almostLinear
                           animation = fadeLayersOut, 1, 1.39, almostLinear
                           animation = workspaces, 1, 1.94, almostLinear, fade
                           animation = workspacesIn, 1, 1.21, almostLinear, fade
                           animation = workspacesOut, 1, 1.94, almostLinear, fade
                       }

                       decoration {
                     rounding = 10
                     rounding_power = 2

                     # Change transparency of focused and unfocused windows
                     active_opacity = 1.0
                     inactive_opacity = 1.0

                     shadow {
                         enabled = true
                         range = 4
                         render_power = 3
                         color = rgba(1a1a1aee)
                     }

                     # https://wiki.hypr.land/Configuring/Variables/#blur
                     blur {
                         enabled = true
                         size = 3
                         passes = 1

                         vibrancy = 0.1696
                     }
                 }
      '';
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "fuzzel";

      plugin = {
        hyprtrails = {
          color = "rgba(ffaa00ff)";
        };
      };

      monitor = [
        "DP-3, 2560x1440@144, 0x0, 1"
        "DP-2, 2560x1440@60, 6400x0, 1, transform, 1"
        "DP-1, 3840x2160@144, 2560x0, 1"
      ];
      bind =
        [
          "$mod, B, exec, librewolf"
          "$mod, F, fullscreen"
          ", Print, exec, grimblast copy area"

          # Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
          "$mod, A, exec, $terminal"
          "$mod SHIFT, Q, killactive,"
          "$mod, M, exit,"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating,"
          "$mod, D, exec, $menu"
          "$mod, P, pseudo, # dwindle"
          "$mod, J, togglesplit, # dwindle"

          # Move focus with mod + vim keys
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, L, movewindow, r"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, J, movewindow, d"

          # Switch workspaces with mod + [0-9]
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # Move active window to a workspace with mod + SHIFT + [0-9]
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"

          # Example special workspace (scratchpad)
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
    };
  };
}
