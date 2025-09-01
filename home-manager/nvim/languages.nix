{pkgs, ...}: {
  programs.nvf.settings.vim = {
    lsp.enable = true;

    luaConfigRC.myconfig =
      /* lua */ ''

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        lspconfig = require('lspconfig')
        lspconfig.gdscript.setup(capabilities)
        lspconfig.cmake.setup(capabilities)



        local port = os.getenv('GDScript_Port') or 6005
        local cmd = vim.lsp.rpc.connect('127.0.0.1', port)
        local pipe = '/tmp/godot.pipe' -- I use /tmp/godot.pipe

        vim.lsp.start({
          name = 'Godot',
          cmd = cmd,
          root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
          on_attach = function(client, bufnr)
            vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
          end
        })

      '';

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableDAP = true;

      assembly.enable = true;

      bash.enable = true;

      clang.enable = true;

      csharp.enable = true;

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
    };
  };
}
