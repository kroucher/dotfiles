local status, packer = pcall(require, "packer")
if (not status) then
	print("Packer is not installed")
	return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)

	use 'wbthomason/packer.nvim'

	-- syntax highlighting
	use("nvim-treesitter/nvim-treesitter", {
		run = ":TSUpdate",
	})
	use('JoosepAlviste/nvim-ts-context-commentstring')

	use("p00f/nvim-ts-rainbow") -- bracket colorizer

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
			'williamboman/mason.nvim',
			run = function()
				pcall(vim.cmd, 'MasonUpdate')
			end,
		},
		{'williamboman/mason-lspconfig.nvim'}, -- Optional

		-- Autocompletion
		{'hrsh7th/nvim-cmp'},     -- Required
		{'hrsh7th/cmp-nvim-lsp'}, -- Required
		{'L3MON4D3/LuaSnip'},     -- Required
	}
}

use 'nvim-lualine/lualine.nvim' -- Statusline
use 'nvim-lua/plenary.nvim' -- Common utilities
use 'onsails/lspkind-nvim' -- vscode-like pictograms
use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words

use 'olivercederborg/poimandres.nvim' -- Theme
use 'lunarvim/darkplus.nvim' -- Theme
use 'folke/tokyonight.nvim' -- Theme
use { "bluz71/vim-moonfly-colors", as = "moonfly" }

use 'norcalli/nvim-colorizer.lua' -- colorizer for css

use 'github/copilot.vim' -- Copilot

use 'kyazdani42/nvim-web-devicons' -- File icons

use {
	'nvim-telescope/telescope.nvim',
	requires = { {'nvim-lua/plenary.nvim'} }
} -- Fuzzy finder

use 'nvim-telescope/telescope-file-browser.nvim' -- File browser
use ({'nvim-telescope/telescope-fzf-native.nvim', run = 'make'})
use 'windwp/nvim-autopairs' -- Auto pairs
use 'windwp/nvim-ts-autotag' -- Auto close and rename html tag
use 'glepnir/lspsaga.nvim' -- LSP UIs
use 'L3MON4D3/LuaSnip' -- Snippets
use 'jose-elias-alvarez/null-ls.nvim' -- LSP

-- explorer
use 'kyazdani42/nvim-tree.lua'    -- file explorer

use({ "akinsho/bufferline.nvim", tag = "*", requires = "nvim-tree/nvim-web-devicons" }) -- Bufferline

-- wakatime
use 'wakatime/vim-wakatime'

-- prettier
use 'MunifTanjim/prettier.nvim'

-- comment out lines
use {
	'numToStr/Comment.nvim',
	config = function()
		require('Comment').setup()
	end
}

use 'lewis6991/gitsigns.nvim' -- see git changes
use({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" })
use 'f-person/git-blame.nvim' -- see who wrote the lines

use 'mg979/vim-visual-multi'

end)
