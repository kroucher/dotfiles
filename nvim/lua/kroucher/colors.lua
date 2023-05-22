vim.opt.termguicolors = true
-- setup colorizer
require("colorizer").setup()

vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})

