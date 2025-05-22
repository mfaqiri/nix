{ config, ... }: {
  programs.nvf.settings.vim = 
    {

    tabline.nvimBufferline.setupOpts.options = {
                tab_size = 2;

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
