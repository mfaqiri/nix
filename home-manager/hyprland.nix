{pkgs, ...}: {
  programs.eww = {
        enable = true;
        enableZshIntegration = true;

    };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = ["--all"];
    plugins = with pkgs.hyprlandPlugins; [
      hypr-dynamic-cursors
      hyprbars
    ];

    extraConfig =
      /*
      hyprlang
      */
      ''
        exec-once = eww

       plugin:dynamic-cursors {

            # enables the plugin
            enabled = true

            # sets the cursor behaviour, supports these values:
            # tilt    - tilt the cursor based on x-velocity
            # rotate  - rotate the cursor based on movement direction
            # stretch - stretch the cursor shape based on direction and velocity
            # none    - do not change the cursors behaviour
            mode = tilt

            # minimum angle difference in degrees after which the shape is changed
            # smaller values are smoother, but more expensive for hw cursors
            threshold = 2

            # override the mode behaviour per shape
            # this is a keyword and can be repeated many times
            # by default, there are no rules added
            # see the dedicated `shape rules` section below!

            # for mode = rotate
            rotate {

                # length in px of the simulated stick used to rotate the cursor
                # most realistic if this is your actual cursor size
                length = 20

                # clockwise offset applied to the angle in degrees
                # this will apply to ALL shapes
                offset = 0.0
            }

            # for mode = tilt
            tilt {

                # controls how powerful the tilt is, the lower, the more power
                # this value controls at which speed (px/s) the full tilt is reached
                # the full tilt being 60° in both directions
                limit = 5000

                # relationship between speed and tilt, supports these values:
                # linear             - a linear function is used
                # quadratic          - a quadratic function is used (most realistic to actual air drag)
                # negative_quadratic - negative version of the quadratic one, feels more aggressive
                # see `activation` in `src/mode/utils.cpp` for how exactly the calculation is done
                function = negative_quadratic

                # time window (ms) over which the speed is calculated
                # higher values will make slow motions smoother but more delayed
                window = 100
            }

            # for mode = stretch
            stretch {

                # controls how much the cursor is stretched
                # this value controls at which speed (px/s) the full stretch is reached
                # the full stretch being twice the original length
                limit = 3000

                # relationship between speed and stretch amount, supports these values:
                # linear             - a linear function is used
                # quadratic          - a quadratic function is used
                # negative_quadratic - negative version of the quadratic one, feels more aggressive
                # see `activation` in `src/mode/utils.cpp` for how exactly the calculation is done
                function = quadratic

                # time window (ms) over which the speed is calculated
                # higher values will make slow motions smoother but more delayed
                window = 100
            }

            # configure shake to find
            # magnifies the cursor if its is being shaken
            shake {

                # enables shake to find
                enabled = true

                # use nearest-neighbour (pixelated) scaling when shaking
                # may look weird when effects are enabled
                nearest = true

                # controls how soon a shake is detected
                # lower values mean sooner
                threshold = 6.0

                # magnification level immediately after shake start
                base = 4.0
                # magnification increase per second when continuing to shake
                speed = 4.0
                # how much the speed is influenced by the current shake intensitiy
                influence = 0.0

                # maximal magnification the cursor can reach
                # values below 1 disable the limit (e.g. 0)
                limit = 0.0

                # time in millseconds the cursor will stay magnified after a shake has ended
                timeout = 2000

                # show cursor behaviour `tilt`, `rotate`, etc. while shaking
                effects = false

                # enable ipc events for shake
                # see the `ipc` section below
                ipc = false
            }

            # use hyprcursor to get a higher resolution texture when the cursor is magnified
            # see the `hyprcursor` section below
            hyprcursor {

                # use nearest-neighbour (pixelated) scaling when magnifing beyond texture size
                # this will also have effect without hyprcursor support being enabled
                # 0 / false - never use pixelated scaling
                # 1 / true  - use pixelated when no highres image
                # 2         - always use pixleated scaling
                nearest = true

                # enable dedicated hyprcursor support
                enabled = true

                # resolution in pixels to load the magnified shapes at
                # be warned that loading a very high-resolution image will take a long time and might impact memory consumption
                # -1 means we use [normal cursor size] * [shake:base option]
                resolution = -1

                # shape to use when clientside cursors are being magnified
                # see the shape-name property of shape rules for possible names
                # specifying clientside will use the actual shape, but will be pixelated
                fallback = clientside
            }
        }

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

      monitor = [
        "DP-1, 2560x1440@144, 3840x0, 1"
        "DP-2, 2560x1440@60, 6400x0, 1, transform, 1"
        "DP-3, 3840x2160, 0x0, 1"
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
