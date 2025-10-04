require('lspconfig').bashls.setup({
  filetypes = { "sh", "bash", "hyprlang" },
})


local port = os.getenv('GDScript_Port') or 6005
local cmd = vim.lsp.rpc.connect('127.0.0.1', port)
local pipe = '/tmp/godot.pipe'         -- I use /tmp/godot.pipe

if vim.loop.fs_stat(pipe) then
  vim.lsp.start({
    name = 'Godot',
    cmd = cmd,
    root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
    on_attach = function(client, bufnr)
      vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
    end
  })
end

-- Add Python configuration for poetry run pytest
local dap = require('dap')

-- Check if poetry exists before adding configurations

if vim.fn.executable('poetry') == 1 then
  table.insert(dap.configurations.python, {
    type = 'debugpy',
    request = 'launch',
    name = "Debug pytest (current file)",
    module = 'pytest',
    args = { '${file}', '-v' },
    console = 'integratedTerminal',
    pythonPath = function()
      -- Get the python path from poetry environment
      local handle = io.popen('poetry env info --path')
      local poetry_path = handle:read('*l')
      handle:close()
      return poetry_path .. '/bin/python'
    end,
  })

  table.insert(dap.configurations.python, {
    type = 'debugpy',
    request = 'launch',
    name = "Debug pytest (all tests)",
    module = 'pytest',
    args = { '-v' },
    console = 'integratedTerminal',
    pythonPath = function()
      local handle = io.popen('poetry env info --path')
      local poetry_path = handle:read('*l')
      handle:close()
      return poetry_path .. '/bin/python'
    end,
  })
end
