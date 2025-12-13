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
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    plugins = [];

    extraConfig = ''
      # Monitors
      monitor = DP-3, 2560x1440@144, 0x0, 1
      monitor = DP-2, 2560x1440@60, 6400x0, 1, transform, 1
      monitor = DP-1, 3840x2160@144, 2560x0, 1

      # Workspaces
      workspace = 3, monitor:DP-2
      workspace = 2, monitor:DP-1
      workspace = 1, monitor:DP-3

      windowrulev2 = stayfocused, title:^()$,class:^(steam)$
      windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$


      # Animations
      animations {
        enabled = yes

        bezier = easeOutQuint, 0.23, 1, 0.32, 1
        bezier = easeInOutCubic, 0.65, 0.05, 0.36, 1
        bezier = linear, 0, 0, 1, 1
        bezier = almostLinear, 0.5, 0.5, 0.75, 1.0
        bezier = quick, 0.15, 0, 0.1, 1

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

      # Decoration
      decoration {
        rounding = 10

        active_opacity = 1.0
        inactive_opacity = 1.0

        shadow {
          enabled = true
          range = 4
          render_power = 3
          color = rgba(1a1a1aee)
        }

        blur {
          enabled = true
          size = 3
          passes = 1
        }
      }

      # General
      general {
        gaps_in = 5
        gaps_out = 10
        border_size = 2
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)

        layout = master

        resize_on_border = true
        extend_border_grab_area = 15
      }

      # Input
      input {
        follow_mouse = 1
        force_no_accel = true
        special_fallthrough = true

        tablet {
          transform = 0
          output = DP-3
          relative_input = false
        }
      }

      # Misc
      misc {
        vfr = true
        vrr = 1
        disable_hyprland_logo = true
        disable_splash_rendering = true
        always_follow_on_dnd = true
        layers_hog_keyboard_focus = true
        animate_manual_resizes = false
        animate_mouse_windowdragging = false
        enable_swallow = true
        swallow_regex = ^(kitty|alacritty|foot)$
        focus_on_activate = true
      }

      # Mouse bindings - CRITICAL FOR MOVING WINDOWS WITH MOUSE
      bindm = ALT, mouse:272, movewindow
      bindm = SHIFT CONTROL ALT, mouse:272, killactive
      bindm = ALT, mouse:273, resizewindow
      bindm = CONTROL ALT, mouse:273, togglefloating
    '';

    settings = {
      env = [
        "WAYLAND_DISPLAY,wayland-1"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
      ];

      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "fuzzel";

      exec-once = [
        # Start graphical session (this will start all WantedBy=graphical-session.target services)
        "systemctl restart home-manager-mfaqiri.service"
        "exec waybar"
      ];

      bind =
        [
          "$mod, B, exec, librewolf"
          "$mod, F, fullscreen"
          ", Print, exec, grimblast copy area"

          "$mod, A, exec, $terminal"
          "$mod SHIFT, Q, killactive,"
          "$mod SHIFT ALT, Q, exec, hyprctl kill"
          "$mod, M, exit,"
          "$mod, E, exec, $fileManager"
          "$mod, V, togglefloating,"
          "$mod, D, exec, $menu"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"

          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, L, movewindow, r"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, J, movewindow, d"

          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"

          "$mod, G, togglegroup"
          "$mod, TAB, changegroupactive, f"
          "$mod SHIFT, TAB, changegroupactive, b"
          "$mod SHIFT CONTROL, H, moveintogroup, l"
          "$mod SHIFT CONTROL, L, moveintogroup, r"
          "$mod SHIFT CONTROL, K, moveintogroup, u"
          "$mod SHIFT CONTROL, J, moveintogroup, d"
          "$mod ALT, G, moveoutofgroup"
          "$mod CONTROL, L, lockgroups, toggle"

          "$mod SHIFT, V, exec, ~/.local/bin/mpv-hdr.sh"

          # Gamescope on 4K monitor
          "$mod, F1, exec, ~/.local/bin/steam-gamescope-4k.sh"
          
          # Gamescope on TV
          "$mod, F2, exec, ~/.local/bin/steam-gamescope-tv.sh"
        ]
        ++ (
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
        "col.border_active" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.border_inactive" = "rgba(595959aa)";

        groupbar = {
          enabled = true;
          font_size = 10;
          height = 14;
          "col.active" = "rgba(33ccffee)";
          "col.inactive" = "rgba(595959aa)";
          text_color = "rgba(ffffffff)";
          render_titles = true;
          scrolling = true;
        };
      };
    };
  };
}
