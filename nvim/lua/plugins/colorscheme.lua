return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      term_colors = false,
      transparent_background = true,
      integrations = {
        cmp = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
      },
      custom_highlights = function(colors)
        return {
          PackageInfoOutdatedVersion = { fg = colors.red },
          PackageInfoUptodateVersion = { fg = colors.surface2 },
        }
      end,
      styles = {
        comments = { "italic" },
        properties = { "italic" },
        functions = { "bold" },
        keywords = { "italic" },
        operators = { "bold" },
        conditionals = { "bold" },
        loops = { "bold" },
        booleans = { "bold", "italic" },
        numbers = {},
        types = {},
        strings = {},
        variables = {},
      },
    },
  },
}
