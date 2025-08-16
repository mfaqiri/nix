{...}: {
  programs = {
    waybar = {
      enable = true;
      style =
        /*
        css
        */
        ''
          * {
            border: none;
            border-radius: 0;
            min-height: 0;
            font-family: JetBrainsMono Nerd Font;
            font-size: 13px;
          }

          window#waybar {
            background-color: #181825;
            transition-property: background-color;
            transition-duration: 0.5s;
          }

          window#waybar.hidden {
            opacity: 0.5;
          }

          #workspaces {
            background-color: transparent;
          }

          #workspaces button {
            all: initial;
            /* Remove GTK theme values (waybar #1351) */
            min-width: 0;
            /* Fix weird spacing in materia (waybar #450) */
            box-shadow: inset 0 -3px transparent;
            /* Use box-shadow instead of border so the text isn't offset */
            padding: 6px 18px;
            margin: 6px 3px;
            border-radius: 4px;
            background-color: #1e1e2e;
            color: #cdd6f4;
          }

          #workspaces button.active {
            color: #1e1e2e;
            background-color: #cdd6f4;
          }

          #workspaces button:hover {
            box-shadow: inherit;
            text-shadow: inherit;
            color: #1e1e2e;
            background-color: #cdd6f4;
          }

          #workspaces button.urgent {
            background-color: #f38ba8;
          }

          #memory,
          #cpu,
          #temperature,
          #backlight,
          #pulseaudio,
          #network,
          #clock,
          #tray {
            border-radius: 4px;
            margin: 6px 3px;
            padding: 6px 12px;
            background-color: #1e1e2e;
            color: #181825;
          }


          #custom-logo {
            padding-right: 7px;
            padding-left: 7px;
            margin-left: 5px;
            font-size: 15px;
            border-radius: 8px 0px 0px 8px;
            color: #1793d1;
          }

          #memory {
            background-color: #a6e3a1;
            color: #181825;
          }

          #temperature {
            background-color: #f38ba8;
          }

          #cpu {
            background-color: #16e3a3;
          }

          #backlight {
            background-color: #fab387;
          }

          #pulseaudio {
            background-color: #f9e27f;
            padding-right: 17px;
          }

          #network {
             background-color: #94e2d5;
             padding-right: 17px;
          }


          #clock {
            background-color: #cba6f7;
          }


          tooltip {
            border-radius: 8px;
            padding: 15px;
            background-color: #131822;
          }

          tooltip label {
            padding: 5px;
            background-color: #131822;
          }

        '';
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 42;
          spacing = 4;
          modules-left = ["hyprland/workspaces" "wlr/taskbar"];
          modules-center = ["clock"];
          modules-right = ["pulseaudio" "network" "temperature" "cpu" "memory"];

          "keyboard-state" = {
            numlock = true;
            capslock = true;
            format = "{name} {icon}";
            format-icons = {
              locked = "";
              unlocked = "";
            };
          };

          "network" = {
            interface = "enp8s0";
            format-ethernet = "  {ifname}";
            format-disconnected = "";
            tooltip-format-ethernet = "  {ifname}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
            tooltip-format-disconnected = "Disconnected";
            interval = 5;
            nospacing = 1;
          };

          "hyprland/workspaces" = {
            on-click = "activate";
            format = "{name} : {icon}";
            format-icons = {
              active = "";
              default = "";
            };
          };
          "scratchpad" = {
            format = "{icon} {count}";
            show-empty = false;
            format-icons = ["" ""];
            tooltip = true;
            tooltip-format = "{app}: {title}";
          };

          "clock" = {
            format = "  {:%I:%M %p}";
            format-alt = " {:%a, %d %b %Y}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "month";
              format = {
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
          };

          "pulseaudio" = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
          };

          "cpu" = {
            format = "{usage}% ";
            tooltip = false;
          };

          "memory" = {
            format = "{}% ";
          };

          "temperature" = {
            critical-threshold = 80;
            format = "{temperatureC}°C {icon}";
            format-icons = ["" "" ""];
          };
        };
      };
    };

    fuzzel = {
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
          background = "181825ff";
          text = "5050f9ff";
          selection = "af5f0bff";
          selection-text = "cdd6f4ff";
          border = "252d21ff";
        };
        border = {
          width = 2;
          radius = 8;
        };
      };
    };
  };
}
