{pkgs, ...}: {
  programs.nvf.settings.vim = {
    # Add gdformat for GDScript formatting
    extraPackages = with pkgs; [
      gdtoolkit_4  # Provides gdformat and gdlint
    ];

    # GDScript-specific keybindings
    keymaps = [
      # Run current scene in Godot
      {
        key = "<leader>gr";
        mode = "n";
        action = ":!godot --path $(git rev-parse --show-toplevel 2>/dev/null || pwd) %:p<CR>";
        silent = false;
      }
      
      # Open scene in Godot editor
      {
        key = "<leader>go";
        mode = "n";
        action = ":!godot --path $(git rev-parse --show-toplevel 2>/dev/null || pwd) --editor %:p &<CR><CR>";
        silent = false;
      }
      
      # Format current GDScript file
      {
        key = "<leader>gf";
        mode = "n";
        action = ":!gdformat %<CR>:e<CR>";
        silent = false;
      }
      
      # Lint current GDScript file
      {
        key = "<leader>gl";
        mode = "n";
        action = ":!gdlint %<CR>";
        silent = false;
      }
      
      # Insert @onready node (will prompt for name)
      {
        key = "<leader>gn";
        mode = "n";
        action = ":GodotNode ";
        silent = false;
      }
    ];
  };
}
