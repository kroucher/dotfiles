return {
  "christoomey/vim-tmux-navigator",
  dependencies = {
    "RyanMillerC/better-vim-tmux-resizer",
  },
  event = "VeryLazy",
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to the left pane" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to the down pane" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to the up pane" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to the right pane" },
    {
      "<A-h>",
      "<cmd>TmuxResizeLeft<cr>",
      desc = "Resize the left pane",
    },
    {
      "<A-j>",
      "<cmd>TmuxResizeDown<cr>",
      desc = "Resize the down pane",
    },
    {
      "<A-k>",
      "<cmd>TmuxResizeUp<cr>",
      desc = "Resize the up pane",
    },
    {
      "<A-l>",
      "<cmd>TmuxResizeRight<cr>",
      desc = "Resize the right pane",
    },
  },
}
