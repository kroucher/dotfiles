return {
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("kanagawa").setup({
  --       theme = "lotus",
  --       transparent = true,
  --     })
  --     vim.cmd("colorscheme kanagawa")
  --   end,
  -- },
  -- {
  -- "scottmckendry/cyberdream.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("cyberdream").setup({
  --       transparent = true,
  --       italic_comments = true,
  --       hide_fillchars = true,
  --       borderless_telescope = false,
  --     })
  --     vim.cmd("colorscheme cyberdream")
  --   end,
  -- },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfox",
    },
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Default options
      require("nightfox").setup({
        options = {
          -- Compiled file's destination location
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled", -- Compiled file suffix
          transparent = true, -- Disable setting background
          terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
          dim_inactive = false, -- Non focused panes set to alternative background
          module_default = true, -- Default enable value for modules
          colorblind = {
            enable = false, -- Enable colorblind support
            simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
            severity = {
              protan = 0, -- Severity [0,1] for protan (red)
              deutan = 0, -- Severity [0,1] for deutan (green)
              tritan = 0, -- Severity [0,1] for tritan (blue)
            },
          },
          styles = { -- Style to be applied to different syntax groups
            comments = "italic", -- Value is any valid attr-list value `:help attr-list`
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            keywords = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
          },
          inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = false,
            search = false,
          },
          modules = { -- List of various plugins and additional options
            -- ...
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })

      -- setup must be called before loading
      vim.cmd("colorscheme nightfox")
    end,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({})
    end,
  },

  -- {
  --   "oxfist/night-owl.nvim",
  --   lazy = false,
  --   priority = 1000,
  -- },
  -- {
  --   "olivercederborg/poimandres.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("poimandres").setup({
  --       bold_vert_split = false, -- use bold vertical separators
  --       dim_nc_background = true, -- dim 'non-current' window backgrounds
  --       disable_background = true, -- disable background
  --       disable_float_background = false, -- disable background for floats
  --       disable_italics = false, -- disable italics
  --     })
  --   end,
  -- },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      term_colors = false,
      transparent_background = true,
      integrations = {
        cmp = true,
        neogit = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        mason = true,
        dap = true,
        dap_ui = true,
        telescope = {
          enabled = true,
        },
        which_key = true,
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
