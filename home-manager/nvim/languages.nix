{pkgs, ...}: {
  programs.nvf = {
    settings.vim = {
      # Add packages for document processing
      extraPackages = with pkgs; [
        hunspell
        hunspellDicts.en_US
        pandoc # For document conversion if needed
      ];
      lsp = {
        enable = true;

        servers = {
          gdscript = {
            # Use Godot as the language server
            cmd = ["godot" "--headless" "--lsp-port" "6005"];
            filetypes = ["gdscript"];
            rootDir = ''vim.lsp.config.util.root_pattern("project.godot", ".git")'';
            settings = {
              # Godot-specific settings
            };
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

        csharp.enable = true;

        css.enable = true;

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
      };
    };
  };
}
