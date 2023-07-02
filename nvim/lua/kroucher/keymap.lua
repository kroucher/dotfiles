local builtin = require("telescope.builtin")

local neogit_status, _ = pcall(require, "neogit")
if not neogit_status then
  return
end

local keymap = vim.keymap.set

-- TELESCOPE
keymap("n", "<leader>ff", builtin.find_files, {})
keymap("n", "<leader>re", builtin.oldfiles, {})
keymap("n", "<leader>fg", builtin.live_grep, {})
keymap("n", "<leader>fb", builtin.buffers, {})
keymap("n", "<leader>fh", builtin.help_tags, {})

-- navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true })
keymap("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true })
keymap("n", "<leader>q", ":bdelete<CR>", { noremap = true, silent = true })

-- NVIMTREE
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- ThePrimeagen
keymap("v", "J", ":m '>+1<CR>gv=gv") -- move selected lines down
keymap("v", "K", ":m '<-2<CR>gv=gv") -- move selected lines up
keymap("n", "n", "nzzzv") -- find next, center and unfold
keymap("n", "N", "Nzzzv") -- find prev, center and unfold
keymap("x", "p", [["_dP]]) -- paste over visual selection

-- NEOGIT
keymap("n", "<leader>gs", ":Neogit<CR>", {})

-- Center Screen
keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- find and replace
keymap("n", "<leader>fr", "*``cgn", { noremap = true, silent = true })

-- Run plenary test
keymap("n", "<leader>t", ":lua require('plenary.test_harness'):test_directory()<CR>", { noremap = true, silent = true })
