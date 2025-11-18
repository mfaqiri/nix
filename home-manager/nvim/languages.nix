{pkgs, ...}: {
  programs.nvf = {
    settings.vim = {
      # Add packages for document processing
      extraPackages = with pkgs; [
        hunspell
        hunspellDicts.en_US
        pandoc # For document conversion if needed
      ];

      # Add this section for treesitter
      treesitter = {
        enable = true;
        grammars = [
          pkgs.vimPlugins.nvim-treesitter.builtGrammars.gdscript
          pkgs.vimPlugins.nvim-treesitter.builtGrammars.godot_resource
          # Add any other grammars you need
        ];
      };

      lsp = {
        enable = true;

        servers = {
          gdscript = {
            # Use Godot as the language server
            cmd = ["nc" "localhost" "6005"];
            filetypes = ["gdscript" "gdscript3"];
            rootDir = ''vim.lsp.config.util.root_pattern("project.godot", ".git")'';
            settings = {
              # Godot-specific settings
              enable = true;
            };

            # Add on_attach configuration for better integration
            onAttach.function = ''
              -- Godot-specific LSP settings
              vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

              -- Buffer-local keymaps for LSP
              local opts = { buffer = bufnr, silent = true }
              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
              vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts)
              vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
              vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

              -- Add to your luaConfigRC
              local telescope = require('telescope.builtin')

              -- Search for node definitions
              vim.keymap.set('n', '<leader>gn', function()
                telescope.grep_string({
                  search = '@onready var',
                })
              end, { desc = 'Find @onready nodes' })

              -- Add to luaConfigRC
              vim.api.nvim_create_user_command('GodotNode', function(opts)
                local node_name = opts.args
                local line = '@onready var ' .. node_name:lower() .. ': Node = $' .. node_name
                vim.api.nvim_put({line}, 'l', true, true)
              end, { nargs = 1 })
            '';
          };
          neocmake = {};
          arduino_language_server = {
            cmd = ["arduino-language-server"];
            filetypes = ["arduino"];
            rootDir = ''vim.lsp.config.util.root_pattern("*.ino", ".git")'';
          };
          bashls = {};
        };
      };

      luaConfigPost = "${builtins.readFile ./after/setup.lua}";

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableDAP = true;

        assembly.enable = true;

        bash.enable = true;

        clang.enable = true;

        css.enable = true;
        css.format.package = pkgs.nodePackages.prettier;

        go.enable = true;

        html.enable = true;

        java.enable = true;

        lua.enable = true;

        markdown = {
          enable = true;

          extensions.render-markdown-nvim.enable = true;
        };

        nix.enable = true;

        php.enable = true;

        python.enable = true;

        rust.enable = true;

        sql.enable = true;

        tailwind.enable = true;

        ts.enable = true;
        ts.format.package = pkgs.nodePackages.prettier;

        yaml.enable = true;
      };
    };
  };
}
