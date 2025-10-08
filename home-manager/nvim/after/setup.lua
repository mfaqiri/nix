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


  -- Define exactly which file extensions should get word processor mode
  local word_processor_files = {
    "*.txt",
    "*.text", 
    "*.doc",
    "*.rtf",
    -- Add any other extensions you want
  }
  
  -- Function to enable word processor mode
  local function setup_word_processor()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
    vim.opt_local.textwidth = 80
    vim.opt_local.colorcolumn = "80"
    
    -- Movement keybindings for this buffer only
    local opts = { buffer = true, silent = true }
    vim.keymap.set({'n', 'v'}, 'j', 'gj', opts)
    vim.keymap.set({'n', 'v'}, 'k', 'gk', opts)
    vim.keymap.set('n', '<leader>fp', 'gwap', opts)
  end
  
  -- Apply to specific file patterns
  vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = word_processor_files,
    callback = setup_word_processor
  })
