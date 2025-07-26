{pkgs, ...}: {
  imports = [
    ./keymaps.nix
    ./options.nix
    ./languages.nix
  ];
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        navigation = {
          harpoon = {
            enable = true;
          };
        };
        binds = {
          cheatsheet.enable = true;
          whichKey.enable = true;
        };

        git = {
          enable = true;

          gitsigns = {
            enable = true;
            codeActions.enable = true;
          };
          vim-fugitive.enable = true;
        };

        theme = {
          enable = true;
          name = "onedark";
        };

        viAlias = false;
        vimAlias = true;

        autocomplete.nvim-cmp = {
          enable = true;
          mappings = {
            confirm = "<C-y>";
            next = "<C-j>";
            previous = "<C-k>";
          };
        };

        comments.comment-nvim.enable = true;

        debugger.nvim-dap.enable = true;

        statusline.lualine.enable = true;

        telescope.enable = true;

        extraPlugins = with pkgs.vimPlugins; {
          aerial = {
            package = aerial-nvim;
            setup =
              /*
              lua
              */
              "require('aerial').setup {}";
          };

          vim-godot = {
            package = vim-godot;
            setup =
              /*
              lua
              */
              ''event = "VimEnter"'';
          };
        };
      };
    };
  };
}
