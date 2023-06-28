-- setup colorizer
require("colorizer").setup()

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- theme
require("poimandres").setup({
  bold_vert_split = false, -- use bold vertical separators
  dim_nc_background = true, -- dim 'non-current' window backgrounds
  disable_background = true, -- disable background
  disable_float_background = true, -- disable background for floats
  disable_italics = false, -- disable italics
})

vim.cmd([[colorscheme poimandres]])

-- webdev icons
require("nvim-web-devicons").setup({
  override = {
    zsh = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh",
    },
  },
  color_icons = true,
  default = true,
  strict = true,
  override_by_filename = {
    [".gitignore"] = {
      icon = "",
      color = "#f1502f",
      name = "Gitignore",
    },
  },
  override_by_extension = {
    ["log"] = {
      icon = "",
      color = "#81e043",
      name = "Log",
    },
  },
})
