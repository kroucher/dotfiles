-- Set border of some LazyVim plugins to rounded
local BORDER_STYLE = "rounded"

return {
  {
    "which-key.nvim",
    opts = { window = { border = BORDER_STYLE } },
  },
  {
    "gitsigns.nvim",
    opts = { preview_config = { border = BORDER_STYLE } },
  },
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      -- Set LspInfo border
      require("lspconfig.ui.windows").default_options.border = BORDER_STYLE
      return opts
    end,
  },
  {
    "mason.nvim",
    opts = {
      ui = { border = BORDER_STYLE },
    },
  },
  {
    "noice.nvim",
    opts = {
      presets = { lsp_doc_border = true },
    },
  },
}
