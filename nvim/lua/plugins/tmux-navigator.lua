return {
	"christoomey/vim-tmux-navigator",
	event = "VeryLazy",
	keys = {
		{ "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to the left pane" },
		{ "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to the down pane" },
		{ "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to the up pane" },
		{ "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to the right pane" },
	},
}
