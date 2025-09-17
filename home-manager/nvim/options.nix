{...}: {
  programs.nvf.settings.vim = {
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
      guicursor = "";

      nu = true;
      relativenumber = true;

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;

      smartindent = true;

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
