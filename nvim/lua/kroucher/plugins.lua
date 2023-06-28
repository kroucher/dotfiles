local foldIcon = ""
local hlgroup = "NonText"
local function foldTextFormatter(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = "  " .. foldIcon .. "  " .. tostring(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, hlgroup })
  return newVirtText
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- Dashboard
  {
    "goolord/alpha-nvim",
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  {
    "MunifTanjim/nui.nvim",
  },

  -- syntax highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  "p00f/nvim-ts-rainbow",
  -- autocompletion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lua",
  "andersevenrud/cmp-tmux",
  "David-Kunz/cmp-npm",
  "petertriho/cmp-git",

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",

  -- LSP - manage and install servers
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- LSP - configure LSP servers
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  { "glepnir/lspsaga.nvim", branch = "main" },
  "jose-elias-alvarez/null-ls.nvim",
  "jayp0521/mason-null-ls.nvim", -- bridges gap b/w mason & null-ls
  "onsails/lspkind-nvim",

  -- Typescript
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },

  -- LSP folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    opts = {
      provider_selector = function(_, ft, _)
        local lspWithOutFolding = { "markdown", "bash", "sh", "bash", "zsh", "css" }
        if vim.tbl_contains(lspWithOutFolding, ft) then
          return { "treesitter", "indent" }
        else
          return { "lsp", "indent" }
        end
      end,
      open_fold_hl_timeout = 500,
      fold_virt_text_handler = foldTextFormatter,
    },
  },

  -- lualine
  "nvim-lualine/lualine.nvim",

  -- Themes
  "olivercederborg/poimandres.nvim",
  "lunarvim/darkplus.nvim",
  "folke/tokyonight.nvim",
  "bluz71/vim-moonfly-colors",
  "karb94/neoscroll.nvim",
  -- CSS Colors
  "norcalli/nvim-colorizer.lua",

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
  },
  -- Add Copilot to CMP
  {
    "zbirenbaum/copilot-cmp",
  },

  -- Tmux integration
  {
    "aserowy/tmux.nvim",
    config = function()
      return require("tmux").setup()
    end,
  },

  -- Highlight patterns
  "echasnovski/mini.hipatterns",

  -- Shared Utils
  "nvim-lua/plenary.nvim",

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { { "nvim-lua/plenary.nvim" } },
  }, -- Fuzzy finder

  "nvim-telescope/telescope-file-browser.nvim", -- File browser
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  -- Autopairs
  "windwp/nvim-autopairs", -- Auto pairs
  "windwp/nvim-ts-autotag", -- Auto close and rename html tag

  -- File explorer
  "kyazdani42/nvim-tree.lua", -- file explorer

  -- Bufferline
  { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },

  -- wakatime
  "wakatime/vim-wakatime",

  -- prettier
  "prettier/vim-prettier",

  -- lua formatting
  "ckipp01/stylua-nvim",

  -- comment out lines
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  "JoosepAlviste/nvim-ts-context-commentstring",

  -- Git
  "lewis6991/gitsigns.nvim", -- see git changes
  { "TimUntersberger/neogit", dependencies = "nvim-lua/plenary.nvim" },
  "f-person/git-blame.nvim", -- see who wrote the lines
  "sindrets/diffview.nvim", -- see git diff

  -- Multi-cursor
  "mg979/vim-visual-multi",

  --Tailwind CMP
  "js-everts/cmp-tailwind-colors",

  {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
}

local opts = {
  ui = {
    border = "rounded",
  },
  install = {
    colorscheme = { "poimandres" },
  },
}

require("lazy").setup(plugins, opts)
