-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local whichkey = require("which-key")
local keymap = vim.keymap.set

keymap("v", "J", ":m '>+1<CR>gv=gv") -- move selected lines down
keymap("v", "K", ":m '<-2<CR>gv=gv") -- move selected lines up
keymap(
  "n",
  "<leader>cc",
  ':lua require("colorscheme").cycle_colorscheme()<CR>',
  { noremap = true, silent = true }
)

-- local chatGPTMappings = {
--   C = {
--     name = "ChatGPT",
--     c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
--     e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction" },
--     g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction" },
--     t = { "<cmd>ChatGPTRun translate<CR>", "Translate" },
--     k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords" },
--     d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring" },
--     a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests" },
--     o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code" },
--     s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize" },
--     f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs" },
--     x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code" },
--     r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit" },
--     l = {
--       "<cmd>ChatGPTRun code_readability_analysis<CR>",
--       "Code Readability Analysis",
--     },
--   },
-- }

-- whichkey.add(chatGPTMappings, { prefix = "<leader>", mode = { "n", "v" } })

local packageInfoMappings = {
  {
    "<leader>ps",
    "<cmd>PackageInfoShow<CR>",
    desc = "Show Package Info",
    mode = { "n" },
  },
  {
    "<leader>ph",
    "<cmd>PackageInfoHide<CR>",
    desc = "Hide Package Info",
    mode = { "n" },
  },
  {
    "<leader>pt",
    "<cmd>PackageInfoToggle<CR>",
    desc = "Toggle Package Info",
    mode = { "n" },
  },
  {
    "<leader>pu",
    "<cmd>PackageInfoUpdate<CR>",
    desc = "Update Package",
    mode = { "n" },
  },
  {
    "<leader>pd",
    "<cmd>PackageInfoDelete<CR>",
    desc = "Delete Package",
    mode = { "n" },
  },
  {
    "<leader>pi",
    "<cmd>PackageInfoInstall<CR>",
    desc = "Install Package",
    mode = { "n" },
  },
  {
    "<leader>pp",
    "<cmd>PackageInfoChangeVersion<CR>",
    desc = "Change Package Version",
    mode = { "n" },
  },
  {
    "<leader>p",
    group = "Package Info",
  },
}

-- Add the mappings using wk.add
whichkey.add(packageInfoMappings)

vim.keymap.set("i", "<Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
      "n",
      false
    )
  end
end, { desc = "Super Tab" })

vim.keymap.set("i", "<S-Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").previous()
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true),
      "n",
      false
    )
  end
end, { desc = "Super Shift Tab" })

-- Next and previous suggestion
vim.keymap.set("i", "<M-Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").next()
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<C-Tab>", true, false, true),
      "n",
      false
    )
  end
end, { desc = "Super n" })
