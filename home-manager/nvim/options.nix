{ ... }: {
  programs.nvf.settings.vim = {

    assistant.avante-nvim = {
      enable = true;

      setupOpts = {
        provider = "ollama";
        auto_suggestions_provider = "ollama"; # stops it defaulting to Claude

        providers = {
          ollama = {
            "__inherited_from" = "openai"; # needs quoting in Nix
            api_key_name = "";
            endpoint = "http://127.0.0.1:11434/v1";
            model = "gemma4:12b";
          };
        };

        behaviour = {
          auto_suggestions = false;
          auto_set_highlight_group = true;
          auto_set_keymaps = true;
          auto_apply_diff_after_generation = false;
          support_paste_from_clipboard = true;
        };

        windows = {
          position = "right";
          wrap = true;
          width = 35;
        };
      };
    };

    tabline.nvimBufferline.setupOpts.options = {
      tab_size = 2;
    };
    utility = {
      yazi-nvim.enable = true;

      outline = {
        aerial-nvim.enable = true;
      };

      ccc.enable = true;

      diffview-nvim.enable = true;

      icon-picker.enable = true;

      images = {
        image-nvim = {
          enable = true;

          setupOpts = {
            backend = "kitty";
          };
        };
      };

      motion = {
        flash-nvim.enable = true;
      };

      multicursors.enable = true;

      new-file-template.enable = true;

      nvim-biscuits.enable = true;

      preview = {
        glow.enable = true;
      };

      sleuth.enable = true;

      smart-splits.enable = true;

      surround.enable = true;

      yanky-nvim = {
        enable = true;
        setupOpts.ring.storage = "sqlite";
      };
    };

    options = {
      autoindent = true;
      guicursor = "";
      mouse = "a";

      nu = true;
      relativenumber = true;

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;

      wrap = false;

      swapfile = false;
      backup = false;

      #    undodir = "${config.users.users.mfaqiri.home}/.vim/undodir";
      #undofile = true;

      hlsearch = false;
      incsearch = true;

      termguicolors = true;

      scrolloff = 8;
      signcolumn = "yes";

      updatetime = 50;

      colorcolumn = "80";
    };
  };
}
