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

        autocomplete.nvim-cmp.enable = true;

        comments.comment-nvim.enable = true;

        debugger.nvim-dap.enable = true;

        statusline.lualine.enable = true;

        telescope.enable = true;
        navigation = {
            harpoon.enable = true;
                };

        extraPlugins = with pkgs.vimPlugins; {
          aerial = {
            package = aerial-nvim;
            setup = "require('aerial').setup {}";
          };

          harpoon = {
            package = harpoon;
            setup = "require('harpoon').setup {}";
            after = ["aerial"]; # place harpoon configuration after aerial
          };

          vim-godot = {
            package = vim-godot;
            setup = "event = 'VimEnter'";
          };
        };
      };
    };
  };
}
