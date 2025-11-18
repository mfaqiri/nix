-- Add Python configuration for poetry run pytest
vim.g.deprecation_warnings = false
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
    pythonPath = get_python_path(), -- Note: calling the function here, not passing the function
    cwd = '${workspaceFolder}',
  })

  table.insert(dap.configurations.python, {
    type = 'debugpy',
    request = 'launch',
    name = "Debug pytest (all tests)",
    module = 'pytest',
    args = { '-v' },
    console = 'integratedTerminal',
    pythonPath = get_python_path(), -- Note: calling the function here, not passing the function
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
  vim.keymap.set({ 'n', 'v' }, 'j', 'gj', opts)
  vim.keymap.set({ 'n', 'v' }, 'k', 'gk', opts)
  vim.keymap.set('n', '<leader>fp', 'gwap', opts)
end

-- Apply to specific file patterns
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = word_processor_files,
  callback = setup_word_processor
})

-- ============================================================================
-- MINIMAL GODOT SNIPPETS (No cmp reconfiguration)
-- ============================================================================

-- Only add snippets, don't reconfigure cmp
local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
  -- Silently fail if LuaSnip isn't available
  return
end

local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local c = luasnip.choice_node

-- Add GDScript snippets
luasnip.add_snippets("gdscript", {
  -- @onready with type annotation
  s("onr", {
    t("@onready var "),
    i(1, "node_name"),
    t(": "),
    c(2, {
      t("Node"),
      t("Node2D"),
      t("Node3D"),
      t("Control"),
      t("Button"),
      t("Label"),
      t("Sprite2D"),
      t("CharacterBody2D"),
      t("AnimationPlayer"),
    }),
    t(" = $"),
    i(3, "NodePath"),
    i(0),
  }),
  
  -- @onready simple
  s("on", {
    t("@onready var "),
    i(1, "node_name"),
    t(" = $"),
    i(2, "NodePath"),
    i(0),
  }),
  
  -- Function
  s("func", {
    t("func "),
    i(1, "name"),
    t("("),
    i(2),
    t("):"),
    t({"", "\t"}),
    i(0, "pass"),
  }),
  
  -- _ready
  s("ready", {
    t({"func _ready():", "\t"}),
    i(0, "pass"),
  }),
  
  -- _process
  s("proc", {
    t({"func _process(delta: float):", "\t"}),
    i(0, "pass"),
  }),
  
  -- _physics_process
  s("phys", {
    t({"func _physics_process(delta: float):", "\t"}),
    i(0, "pass"),
  }),
  
  -- Signal
  s("sig", {
    t("signal "),
    i(1, "signal_name"),
    i(0),
  }),
  
  -- Export
  s("exp", {
    t("@export var "),
    i(1, "name"),
    t(": "),
    i(2, "int"),
    t(" = "),
    i(3, "0"),
    i(0),
  }),
})

-- ============================================================================
-- GODOT FILE TYPE DETECTION
-- ============================================================================

vim.filetype.add({
  extension = {
    gd = "gdscript",
    tscn = "godot_resource",
    tres = "godot_resource",
    godot = "gdscript",
  },
})

-- GDScript settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gdscript",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = false
    vim.opt_local.commentstring = "# %s"
  end,
})

-- ============================================================================
-- GODOT NODE HELPER COMMAND
-- ============================================================================

vim.api.nvim_create_user_command('GodotNode', function(opts)
  local node_name = opts.args
  if node_name == "" then
    vim.notify("Usage: :GodotNode NodeName", vim.log.levels.ERROR)
    return
  end
  
  -- Convert to snake_case
  local var_name = node_name:gsub("(%u)", function(c) 
    return "_" .. c:lower() 
  end):gsub("^_", "")
  
  local line = string.format('@onready var %s: Node = $%s', var_name, node_name)
  vim.api.nvim_put({line}, 'l', true, true)
end, { nargs = 1, desc = "Insert @onready node reference" })
