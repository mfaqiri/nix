{...}: {

    programs = {
        waybar = {
            enable = true;
            settings = {
                mainBar = {
                layer = "top";
                position = "top";
                height = 30;
                spacing = 4;
                modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
                modules-center = [ "sway/window" "sway/scratchpad"  ];
                modules-right = [ "pulseaudio" "temperature" "cpu" "memory" "keyboard-state" "clock" ];

                "keyboard-state" = {
                    numlock = true;
                    capslock = true;
                    format = "{name} {icon}";
                    format-icons = {
                        locked = "";
                        unlocked = "";
                    };
                };

                "sway/workspaces" = {
                  disable-scroll = true;
                };
                "sway/scratchpad" = {
                    format = "{icon} {count}";
                    show-empty = false;
                    format-icons = ["" ""];
                    tooltip = true;
                    tooltip-format = "{app}: {title}";
                };


                "pulseaudio" = {
                    format =  "{volume}% {icon} {format_source}";
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

        fuzzel.enable = true;
    };

}
