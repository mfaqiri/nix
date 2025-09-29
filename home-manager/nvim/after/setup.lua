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

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Debug pytest (current file)",
    program = 'poetry',
    args = { 'run', 'pytest', '${file}', '-v' },
    console = 'integratedTerminal',
  },
  {
    type = 'python',
    request = 'launch',
    name = "Debug pytest (all tests)",
    program = 'poetry',
    args = { 'run', 'pytest', '-v' },
    console = 'integratedTerminal',
  },
}

