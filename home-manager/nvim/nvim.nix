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
          schemastore = with pkgs.vimPlugins; {
            package = SchemaStore-nvim;
            setup = "";
          };
          nvim-ufo = with pkgs.vimPlugins; {
            package = nvim-ufo;
            setup = ''
              vim.o.foldcolumn = "1"
              vim.o.foldlevel = 99
              vim.o.foldlevelstart = 99
              vim.o.foldenable = true

              require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                  local ft_map = {
                    json  = { "treesitter", "indent" },
                    jsonc = { "treesitter", "indent" },
                  }
                  return ft_map[filetype] or { "lsp", "indent" }
                end,

                fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                  local newVirtText = {}
                  local suffix = ("  󰁂 %d lines"):format(endLnum - lnum)
                  local sufWidth = vim.fn.strdisplaywidth(suffix)
                  local targetWidth = width - sufWidth
                  local curWidth = 0

                  for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                      table.insert(newVirtText, chunk)
                    else
                      chunkText = truncate(chunkText, targetWidth - curWidth)
                      table.insert(newVirtText, { chunkText, chunk[2] })
                      break
                    end
                    curWidth = curWidth + chunkWidth
                  end

                  table.insert(newVirtText, { suffix, "MoreMsg" })
                  return newVirtText
                end,
              })

              vim.keymap.set("n", "zR", require("ufo").openAllFolds,         { desc = "Open all folds" })
              vim.keymap.set("n", "zM", require("ufo").closeAllFolds,        { desc = "Close all folds" })
              vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
              vim.keymap.set("n", "zm", require("ufo").closeFoldsWith,       { desc = "Close folds with" })
              vim.keymap.set("n", "zp", function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then vim.lsp.buf.hover() end
              end, { desc = "Peek fold" })
            '';
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
