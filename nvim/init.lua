require("kroucher.options")
require("kroucher.autocmds")
require("kroucher.plugins")
require("kroucher.dashboard")
require("kroucher.lsp")
require("kroucher.bufferline")
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

vim.g.gitblame_date_format = "%r (%Y-%m-%d)"
vim.g.gitblame_message_template = "<author>, <date> • <summary>"

-- add local plugin to runtimepath
vim.cmd("set rtp+=/Users/danieldeveney/graphite.nvim/")

require("graphite")
