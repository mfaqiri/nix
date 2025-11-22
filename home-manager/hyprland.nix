{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    libnotify
  ];

  services = {
    mako = {
      enable = true;
      # Correct format for home-manager mako settings
      settings = {
        background-color = "#2e3440";
        text-color = "#eceff4";
        border-color = "#88c0d0";
        progress-color = "over #5e81ac";
        default-timeout = 5000;
        ignore-timeout = false;
      };
    };

    hyprpaper = {
      enable = true;

      settings = {
        ipc = "on";
        splash = false;

        windowrulev2 = [
          # Steam fixes
          "stayfocused, title:^()$,class:^(steam)$"
          "minsize 1 1, title:^()$,class:^(steam)$"

          # Steam overlay and popups
          "float, class:^(steam)$,title:^(Friends List)$"
          "float, class:^(steam)$,title:^(Steam Settings)$"
          "float, class:^(steam)$,title:^(Steam - News)$"

          # This is critical - fixes the vertical offset
          "suppressevent fullscreen, class:^(Godot)$"
          "suppressevent maximize, class:^(Godot)$"

          # Prevent focus issues
          "nofocus, class:^(Godot)$,title:^(popup)$"
          "noinitialfocus, class:^(Godot)$,floating:1"
          "stayfocused, class:^(Godot)$,title:^(Godot)$"

          # Popup positioning
          "float, class:^(Godot)$,title:^(popup)$"
          "noborder, class:^(Godot)$,title:^(popup)$"
          "noshadow, class:^(Godot)$,title:^(popup)$"
          "noanim, class:^(Godot)$,title:^(popup)$"

          # File dialogs
          "float, class:^(Godot)$,title:^(Save).*$"
          "float, class:^(Godot)$,title:^(Open).*$"
          "float, class:^(Godot)$,title:^(Create).*$"
          "float, class:^(Godot)$,title:^(Select).*$"
        ];

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
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    systemd.variables = ["--all"];
    plugins = [
      #inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];

    extraConfig =
      /*
      hyprlang
      */
      ''
          exec-once = waybar
          exec-once = mako

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
           }


          # Fix input capture for Steam overlay
        input {
            follow_mouse = 1
            force_no_accel = true

            # Important for Steam overlay
            special_fallthrough = true

            tablet {
              transform = 0
              output = DP-3
              relative_input = false
            }
        }

        misc {
            vfr = true                    # Variable refresh rate
            vrr = 1                      # Variable refresh rate mode

            # These help with Steam overlay
            disable_hyprland_logo = true
            disable_splash_rendering = true

            # Focus behavior that helps overlays
            always_follow_on_dnd = true
            layers_hog_keyboard_focus = true

            # Animation performance
            animate_manual_resizes = false
            animate_mouse_windowdragging = false

            # Window behavior
            enable_swallow = true
            swallow_regex = ^(kitty|alacritty|foot)$
        }
      '';
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "fuzzel";

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

          # Example special workspace (scratchpad)
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
          # Create a new group (tabbed container)
          "$mod, G, togglegroup"

          # Navigate between tabs in a group
          "$mod, TAB, changegroupactive, f" # Next tab
          "$mod SHIFT, TAB, changegroupactive, b" # Previous tab

          # Move windows into/out of groups (directional)
          "$mod SHIFT CONTROL, H, moveintogroup, l" # Move into group on left
          "$mod SHIFT CONTROL, L, moveintogroup, r" # Move into group on right
          "$mod SHIFT CONTROL, K, moveintogroup, u" # Move into group above
          "$mod SHIFT CONTROL, J, moveintogroup, d" # Move into group below

          "$mod ALT, G, moveoutofgroup" # Remove from group

          # Lock/unlock group (prevent accidental changes)
          "$mod CONTROL, L, lockgroups, toggle"
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
      group = {
        # Tabbed layout styling
        "col.border_active" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.border_inactive" = "rgba(595959aa)";

        groupbar = {
          # Tab bar appearance
          enabled = true;
          font_size = 10;
          height = 14;

          # Tab colors
          "col.active" = "rgba(33ccffee)";
          "col.inactive" = "rgba(595959aa)";

          text_color = "rgba(ffffffff)";

          # Render tabs as individual buttons
          render_titles = true;
          scrolling = true;
        };
      };
    };
  };
}
