-- disable netrw at the very start of your init.lua (strongly advised by nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local autocmd = vim.api.nvim_create_autocmd
vim.g.mapleader = "\\"
require("kroucher.plugins")
require("kroucher.lsp")
require("kroucher.bufferline")
require("kroucher.dashboard")
require("kroucher.treesitter")
require("kroucher.nvim-tree-config")
require("kroucher.keymap")
require("kroucher.lualine")
require("kroucher.comment")
require("kroucher.gitsigns")
require("kroucher.autopairs")
require("kroucher.colors")
require("kroucher.ai.copilot")
require("kroucher.ai.chatgpt")
require("kroucher.telescope")
require("kroucher.nvim-cmp")
require("kroucher.neoscroll")
require("kroucher.hipatterns")
require("kroucher.graphite")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.cursorline = true

vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.timeoutlen = 400

vim.opt.undofile = true

vim.opt.updatetime = 50
vim.opt.writebackup = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.errorbells = false
vim.opt.termguicolors = true

local function open_nvim_tree(data)
  local directory = vim.fn.isdirectory(data.file) == 1
  if not directory then
    return
  end
  -- change to the directory
  vim.cmd.cd(data.file)
  -- open the tree
  require("nvim-tree.api").tree.open()
end

autocmd({ "VimEnter" }, { callback = open_nvim_tree })

vim.g.gitblame_date_format = "%r (%Y-%m-%d)"
vim.g.gitblame_message_template = "<author>, <date> • <summary>"

function Sad(line_nr, from, to, fname)
  vim.cmd(string.format("silent !sed -i '%ss/%s/%s/' %s", line_nr, from, to, fname))
end

function IncreasePadding()
  Sad("50", 0, 40, "~/.config/alacritty/alacritty.yml")
  Sad("51", 0, 40, "~/.config/alacritty/alacritty.yml")
end

function DecreasePadding()
  Sad("50", 20, 0, "~/.config/alacritty/alacritty.yml")
  Sad("51", 20, 0, "~/.config/alacritty/alacritty.yml")
end

vim.cmd([[
  augroup ChangeAlacrittyPadding
   au!
   au VimEnter * lua DecreasePadding()
   au VimLeavePre * lua IncreasePadding()
  augroup END
]])
