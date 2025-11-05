{...}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };

    enableGitIntegration = true;

    shellIntegration.enableZshIntegration = true;

    keybindings = {
      "ctrl+shift" = "kitty_mod";

      "kitty_mod+h" = "move_window left";
      "kitty_mod+j" = "move_window bottom";
      "kitty_mod+k" = "move_window top";
      "kitty_mod+l" = "move_window right";
      "kitty_mod+t" = "new_tab";
      "kitty_mod+w" = "close_tab";
      "ctrl+tab" = "next_tab";
      "kitty_mod+tab" = "previous_tab";


      # === WINDOW NAVIGATION ===
      # Directional movement
      "kitty_mod+x" = "close_window";
      "alt+h" = "neighboring_window left";
      "alt+j" = "neighboring_window down";
      "alt+k" = "neighboring_window up";
      "alt+l" = "neighboring_window right";


      "kitty_mod+enter" = "new_window";
      "kitty_mod+b" = "launch --location=vsplit";
      "kitty_mod+s" = "launch --location=hsplit";

            # Tab navigation by number
      "kitty_mod+1" = "goto_tab 1";
      "kitty_mod+2" = "goto_tab 2";
      "kitty_mod+3" = "goto_tab 3";
      "kitty_mod+4" = "goto_tab 4";
      "kitty_mod+5" = "goto_tab 5";
      "kitty_mod+6" = "goto_tab 6";
      "kitty_mod+7" = "goto_tab 7";
      "kitty_mod+8" = "goto_tab 8";
      "kitty_mod+9" = "goto_tab 9";

            # Window Resizing
      "ctrl+shift+alt+h" = "resize_window narrower";
      "ctrl+shift+alt+l" = "resize_window wider";
      "ctrl+shift+alt+k" = "resize_window taller";
      "ctrl+shift+alt+j" = "resize_window shorter";
      
      # Layout Management
      "ctrl+shift+z" = "toggle_layout stack";
      "ctrl+shift+space" = "next_layout";
    };

    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_opacity = "0.5";
      background_blur = 5;
      symbol_map = let
        mappings = [
          "U+23FB-U+23FE"
          "U+2B58"
          "U+E200-U+E2A9"
          "U+E0A0-U+E0A3"
          "U+E0B0-U+E0BF"
          "U+E0C0-U+E0C8"
          "U+E0CC-U+E0CF"
          "U+E0D0-U+E0D2"
          "U+E0D4"
          "U+E700-U+E7C5"
          "U+F000-U+F2E0"
          "U+2665"
          "U+26A1"
          "U+F400-U+F4A8"
          "U+F67C"
          "U+E000-U+E00A"
          "U+F300-U+F313"
          "U+E5FA-U+E62B"
        ];
      in
        (builtins.concatStringsSep "," mappings) + " PowerlineSymbols";
    };
  };
}
