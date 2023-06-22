local builtin = require "telescope.builtin"

local neogit_status, neogit = pcall(require, "neogit")
if not neogit_status then return end

-- TELESCOPE
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>re", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- navigate buffers
vim.keymap.set("n", "<S-l>", ":BufferNext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-h>", ":BufferPrevious<CR>", { noremap = true, silent = true })
-- close buffer
vim.keymap.set("n", "<leader>q", ":BufferWipeout<CR>", { noremap = true, silent = true })

-- NVIMTREE
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- CommentToggle
vim.api.nvim_set_keymap("n", "<leader>kc", ":Commentary<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>kc", ":Commentary<CR>", { noremap = true, silent = true })

-- ThePrimeagen
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- move selected lines down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- move selected lines up
vim.keymap.set("n", "n", "nzzzv") -- find next, center and unfold
vim.keymap.set("n", "N", "Nzzzv") -- find prev, center and unfold
vim.keymap.set("x", "p", [["_dP]]) -- paste over visual selection

-- NEOGIT
vim.keymap.set("n", "<leader>gs", ":Neogit<CR>", {})

-- Center Screen
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- find and replace
vim.keymap.set("n", "<leader>fr", "*``cgn", { noremap = true, silent = true })
