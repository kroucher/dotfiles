local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = "all",
  auto_install = true,
  sync_install = true,

  highlight = {
    enable = true,
    -- additional_vim_regex_highlighting = true,
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  autotag = {
    enable = true,
  },
})

vim.api.nvim_create_augroup("rainbow", {
  clear = true,
})

vim.api.nvim_create_autocmd({ "Filetype" }, {
  group = "rainbow",
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "rainbowcol1", {
      fg = "#ffd700",
    })
  end,
})

local colors = {
  TSRainbowRed = "#d0679d",
  TSRainbowOrange = "#ff9e64",
  TSRainbowGreen = "#5de4c7",
  TSRainbowYellow = "#fffac2",
  TSRainbowBlue = "#89ddff",
  TSRainbowViolet = "#fcc5e9",
  TSRainbowCyan = "#add7ff",
}
for i, color in pairs(colors) do
  vim.cmd("highlight " .. i .. " guifg=" .. color .. " ctermfg=White")
end

