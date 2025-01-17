-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--
-- A TAB character looks like 4 spaces
vim.o.tabstop        = 4
vim.o.shiftwidth     = 4
vim.o.softtabstop    = 4

-- Set highlight on search
vim.o.hlsearch       = true

-- Make line numbers default
vim.wo.number        = true

-- Enable mouse mode
vim.o.mouse          = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard      = 'unnamedplus'

-- Enable break indent
vim.o.breakindent    = true

-- Save undo history
vim.o.undofile       = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase     = true
vim.o.smartcase      = true

-- Keep sign column on by default
vim.wo.signcolumn    = 'yes'

-- Decrease update time
vim.o.updatetime     = 250
vim.o.timeoutlen     = 300

-- Set complete opt to have a better completion experience
vim.o.completeopt    = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors  = true

-- Highlight current line
vim.o.cursorline     = true

-- Show 100 symbols line
vim.o.colorcolumn    = '100'

-- Enable line wrap
vim.o.wrap           = true

-- Open splits on the right
vim.o.splitright     = true

-- Configure spellchecking
vim.o.spelllang      = 'en_us'
vim.o.spelloptions   = 'camel,noplainbuffer'
vim.o.spellcapcheck  = ''
vim.o.spell          = true

-- Clipboard hacks for WSL
local handle         = io.popen("uname -r")
local result         = handle:read("*a")
if not (handle == nil) then
  handle:close()
end

if string.find(result, "microsoft") then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
