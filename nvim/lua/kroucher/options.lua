-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

-- Default options are not included
-- See: https://neovim.io/doc/user/vim_diff.html
-- [2] Defaults - *nvim-defaults*

local g = vim.g -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- General
-----------------------------------------------------------
g.mapleader = "\\" -- Map leader to backslash
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Copy/paste to system clipboard
opt.swapfile = false -- Don't use swapfile
opt.completeopt = "menuone,noinsert,noselect" -- Autocomplete options

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true -- Show line number
opt.showmatch = true -- Highlight matching parenthesis
opt.foldmethod = "marker" -- Enable folding (default 'foldmarker')
opt.foldcolumn = "1" -- Allocate 1 column for fold markers
opt.foldlevel = 99 -- Open all folds by default
opt.foldlevelstart = 99 -- Open all folds by default
opt.foldenable = true -- Enable folding
opt.splitright = true -- Vertical split to the right
opt.splitbelow = true -- Horizontal split to the bottom
opt.ignorecase = true -- Ignore case letters when search
opt.smartcase = true -- Ignore lowercase for the whole pattern
opt.linebreak = true -- Wrap on word boundary
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.laststatus = 3 -- Set global statusline
opt.cmdheight = 1 -- More space for displaying messages
opt.scrolloff = 8 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show signcolumn
opt.synmaxcol = 240 -- Max column for syntax highlight
opt.statuscolumn = '%=%l%s%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "▼" : "⏵") : " " }'

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 4 -- Shift 4 spaces when tab
opt.tabstop = 4 -- 1 tab == 4 spaces
opt.smartindent = true -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true -- Enable background buffers
opt.history = 100 -- Remember N lines in history
opt.undofile = true -- Enable persistent undo
opt.updatetime = 50 -- Faster completion
opt.writebackup = false -- Don't backup files
opt.errorbells = false -- Disable error bells
opt.lazyredraw = true -- Faster scrolling
opt.updatetime = 250 -- ms to wait for trigger an event
opt.timeoutlen = 400 -- Time to wait for a mapped sequence

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
opt.shortmess:append("sI")

-- -- Disable builtin plugins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end
