local neoscroll_status, neoscroll = pcall(require, "neoscroll")
if not neoscroll_status then
  return
end

neoscroll.setup({
  mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
  hide_cursor = true, -- Hide cursor while scrolling
  stop_eof = true, -- Stop at <EOF> when scrolling downwards
  respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  easing_function = nil, -- Default easing function
  performance_mode = false, -- Disable "Performance Mode" on all buffers.
  post_hook = function()
    vim.cmd("normal! zz")
  end,
})
