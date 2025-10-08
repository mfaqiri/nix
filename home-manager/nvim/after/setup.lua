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


-- Arduino filetype detection
vim.filetype.add({
  extension = {
    ino = "arduino",
  },
})

-- Arduino-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
  pattern = "arduino",
  callback = function()
    local opts = { buffer = 0 }
    vim.keymap.set('n', '<leader>ac', ':!arduino-cli compile -b arduino:avr:uno %<CR>', opts)
    vim.keymap.set('n', '<leader>au', ':!arduino-cli upload -b arduino:avr:uno -p /dev/ttyACM0 %<CR>', opts)
  end,
})
