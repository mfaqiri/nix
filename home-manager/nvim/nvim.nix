{ pkgs, ... }:
{
  imports = [
    ./keymaps.nix
    ./options.nix
    ./languages.nix
    ./godot.nix
  ];
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        assistant.avante-nvim = {
          enable = true;
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
        telescope.enable = true;

        viAlias = false;
        vimAlias = true;

        # IMPORTANT: Enable snippets
        snippets.luasnip = {
          enable = true;
          # Ensure these are also set
          setupOpts = {
            enable_autosnippets = true;
            store_selection_keys = "<Tab>";
          };
        };

        autocomplete.nvim-cmp = {
          enable = true;
        };

        comments.comment-nvim.enable = true;

        debugger.nvim-dap.enable = true;

        statusline.lualine = {
          enable = true;
          icons.enable = true;
        };

        navigation = {
          harpoon.enable = true;
        };

        extraPlugins = with pkgs.vimPlugins; {
          vim-godot = {
            package = vim-godot;
            setup = "event = 'VimEnter'";
          };
          friendly-snippets = with pkgs.vimPlugins; {
            package = friendly-snippets;
            setup = "event = 'VimEnter'";
          };
        };

        # Add friendly-snippets for common snippets

        luaConfigPre = /* lua */ ''
                      -- Add gdformat to null-ls for LSP formatting support
          local null_ls_ok, null_ls = pcall(require, "null-ls")
          if null_ls_ok then
            null_ls.setup({
              sources = {
                null_ls.builtins.formatting.gdformat,
              },
            })
          end
        '';

        visuals = {
          nvim-web-devicons.enable = true; # This is crucial
          fidget-nvim.enable = true;
          indent-blankline.enable = true;
        };
      };
    };
  };
}
