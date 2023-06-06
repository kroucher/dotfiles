-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

local status, packer = pcall(require, "packer")
if not status then
  print("Packer is not installed")
  return
end

vim.cmd([[packadd packer.nvim]])

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

packer.startup(function(use)
  use("wbthomason/packer.nvim")

  -- Dashboard
  use({
    "goolord/alpha-nvim",
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end,
  })

  -- syntax highlighting
  use("nvim-treesitter/nvim-treesitter", {
    run = ":TSUpdate",
  })

  use("p00f/nvim-ts-rainbow") -- bracket colorizer

  -- autocompletion
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")

  -- snippets
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  use("rafamadriz/friendly-snippets")

  -- LSP - manage and install servers
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")

  -- LSP - configure LSP servers
  use("neovim/nvim-lspconfig")
  use("hrsh7th/cmp-nvim-lsp")
  use({ "glepnir/lspsaga.nvim", branch = "main" })
  use("jose-elias-alvarez/null-ls.nvim")
  use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls
  use("onsails/lspkind-nvim")
  use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)

  -- LSP - diagnostics line
  use({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      -- Disable virtual_text since it's redundant due to lsp_lines.
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  })
  -- lualine
  use("nvim-lualine/lualine.nvim")

  -- Themes
  use("olivercederborg/poimandres.nvim")
  use("lunarvim/darkplus.nvim")
  use("folke/tokyonight.nvim")
  use({ "bluz71/vim-moonfly-colors", as = "moonfly" })
  use("karb94/neoscroll.nvim")
  -- CSS Colors
  use("norcalli/nvim-colorizer.lua")

  -- Copilot
  use({
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = true },
        panel = { enabled = false },
      })
    end,
  })
  -- Add Copilot to CMP
  use({
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  })

  -- Multiple Cursors
  use("terryma/vim-multiple-cursors")

  -- Tmux integration
  use({
    "aserowy/tmux.nvim",
    config = function()
      return require("tmux").setup()
    end,
  })

  -- Find and replace
  use("nvim-pack/nvim-spectre")

  -- Highlight patterns
  use("echasnovski/mini.hipatterns")

  -- Shared Utils
  use("kyazdani42/nvim-web-devicons")
  use("nvim-lua/plenary.nvim")

  -- Telescope
  use({
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
  }) -- Fuzzy finder

  use("nvim-telescope/telescope-file-browser.nvim") -- File browser
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

  -- Autopairs
  use("windwp/nvim-autopairs") -- Auto pairs
  use("windwp/nvim-ts-autotag") -- Auto close and rename html tag

  -- File explorer
  use("kyazdani42/nvim-tree.lua") -- file explorer

  -- Bufferline
  use({ "akinsho/bufferline.nvim", tag = "*", requires = "nvim-tree/nvim-web-devicons" }) -- Bufferline

  -- wakatime
  use("wakatime/vim-wakatime")

  -- prettier
  use("MunifTanjim/prettier.nvim")

  -- lua formatting
  use({ "ckipp01/stylua-nvim" })

  -- comment out lines
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })
  use("JoosepAlviste/nvim-ts-context-commentstring")

  -- Git
  use("lewis6991/gitsigns.nvim") -- see git changes
  use({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" })
  use("f-person/git-blame.nvim") -- see who wrote the lines
  use("sindrets/diffview.nvim") -- see git diff

  -- Multi-cursor
  use("mg979/vim-visual-multi")

  --Tailwind CMP
  use("js-everts/cmp-tailwind-colors")
end)
