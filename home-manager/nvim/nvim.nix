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

        navigation = {
          harpoon.enable = true;
        };

        extraPlugins = with pkgs.vimPlugins; {
          vim-godot = {
            package = vim-godot;
            setup = "event = 'VimEnter'";
          };
        };

        luaConfigPre =
          /*
          lua
          */
          ''
                   -- Suppress lspconfig deprecation at startup
              vim.deprecate = function(feature, alternative, version, plugin, backtrace)
                -- Block all lspconfig framework deprecation warnings
                if feature and feature:match("require.*lspconfig") then
                  return
                end
                if alternative and alternative:match("vim%.lsp%.config") then
                  return
                end
                if plugin and plugin:match("lspconfig") then
                  return
                end
                -- Let other deprecation warnings through (optional)
                -- Remove this section if you want to block ALL deprecation warnings
                vim.notify(
                  string.format("%s is deprecated, use %s instead. Feature will be removed in %s",
                    feature or "Feature",
                    alternative or "alternative",
                    version or "future version"
                  ),
                  vim.log.levels.WARN
                )
              end

               -- Override deprecated vim.highlight
            vim.highlight = vim.hl or vim.highlight

            -- Override vim.validate to suppress warnings
            local original_validate = vim.validate
            vim.validate = function(...)
              local args = {...}
              -- Handle both old and new calling conventions
              if #args == 1 and type(args[1]) == "table" then
                -- New style: vim.validate({name = {value, validator, msg}})
                return original_validate(args[1])
              else
                -- Old style being called, just validate silently
                local name, value, validator, optional_or_msg = ...
                if type(validator) == "function" then
                  return validator(value)
                elseif type(validator) == "string" then
                  return type(value) == validator
                end
                return true
              end
            end

            -- Also override vim.deprecate to suppress all deprecation warnings
            vim.deprecate = function() end
          '';
      };
    };
  };
}
