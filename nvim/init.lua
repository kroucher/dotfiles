-- disable netrw at the very start of your init.lua (strongly advised by nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local autocmd = vim.api.nvim_create_autocmd

require("kroucher.plugins")
require("kroucher.mason-config")
require("kroucher.typescript")
require("kroucher.bufferline")
require("kroucher.treesitter")
require("kroucher.nvim-tree-config")
require("kroucher.keymap")
require("kroucher.lualine")
require("kroucher.comment")
require("kroucher.gitsigns")
require("kroucher.lsp")
require("kroucher.autopairs")
require("kroucher.colors")
require("kroucher.null-ls")
require("kroucher.telescope")

vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

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
