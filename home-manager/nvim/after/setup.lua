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

if vim.fn.executable('poetry') == 1 then
  local function get_python_path()
    -- Get the actual python executable path from poetry
    local handle = io.popen('poetry run which python 2>/dev/null')
    if handle then
      local python_path = handle:read('*l')
      handle:close()
      if python_path and python_path ~= '' and vim.fn.executable(python_path) == 1 then
        return python_path
      end
    end
    -- Fallback to system python
    return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
  end

  table.insert(dap.configurations.python, {
    type = 'debugpy',
    request = 'launch',
    name = "Debug pytest (current file)",
    module = 'pytest',
    args = { '${file}', '-v' },
    console = 'integratedTerminal',
    pythonPath = get_python_path(),  -- Note: calling the function here, not passing the function
    cwd = '${workspaceFolder}',
  })

  table.insert(dap.configurations.python, {
    type = 'debugpy',
    request = 'launch',
    name = "Debug pytest (all tests)",
    module = 'pytest',
    args = { '-v' },
    console = 'integratedTerminal',
    pythonPath = get_python_path(),  -- Note: calling the function here, not passing the function
    cwd = '${workspaceFolder}',
  })
end
