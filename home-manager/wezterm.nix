{ ... }:
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;

    extraConfig = ''
      local wezterm = require 'wezterm'
      local act = wezterm.action
      local config = wezterm.config_builder()

      -- Font
      config.font = wezterm.font 'JetBrainsMono Nerd Font'
      config.font_size = 14

      -- Appearance
      config.window_background_opacity = 0.5
      config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }

      -- Wayland
      config.enable_wayland = true
      config.audible_bell = 'Disabled'

      -- Tabs
      config.hide_tab_bar_if_only_one_tab = true
      config.use_fancy_tab_bar = false

      -- Keybindings (matching your kitty config)
      config.keys = {
        -- Splits
        { key = 'b', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = 's', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
        { key = 'Enter', mods = 'CTRL|SHIFT', action = act.SpawnCommandInNewTab { cwd = wezterm.home_dir } },

        -- Window navigation
        { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
        { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
        { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
        { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },

        -- Window resizing
        { key = 'h', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Left', 5 } },
        { key = 'l', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Right', 5 } },
        { key = 'k', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Up', 5 } },
        { key = 'j', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Down', 5 } },

        -- Tabs
        { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = false } },
        { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
        { key = 'x', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = false } },

        -- Tab navigation by number
        { key = '1', mods = 'CTRL|SHIFT', action = act.ActivateTab(0) },
        { key = '2', mods = 'CTRL|SHIFT', action = act.ActivateTab(1) },
        { key = '3', mods = 'CTRL|SHIFT', action = act.ActivateTab(2) },
        { key = '4', mods = 'CTRL|SHIFT', action = act.ActivateTab(3) },
        { key = '5', mods = 'CTRL|SHIFT', action = act.ActivateTab(4) },
        { key = '6', mods = 'CTRL|SHIFT', action = act.ActivateTab(5) },
        { key = '7', mods = 'CTRL|SHIFT', action = act.ActivateTab(6) },
        { key = '8', mods = 'CTRL|SHIFT', action = act.ActivateTab(7) },
        { key = '9', mods = 'CTRL|SHIFT', action = act.ActivateTab(8) },
      }

      return config
    '';
  };
}
