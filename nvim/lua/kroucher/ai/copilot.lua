local copilot_status, copilot = pcall(require, "copilot")
if not copilot_status then return end

copilot.setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

require("copilot_cmp").setup()

vim.keymap.set("i", "<Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, { desc = "Super Tab" })

vim.keymap.set("i", "<S-Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").previous()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
  end
end, { desc = "Super Shift Tab" })

-- Next and previous suggestion
vim.keymap.set("i", "<M-Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").next()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-Tab>", true, false, true), "n", false)
  end
end, { desc = "Super n" })
