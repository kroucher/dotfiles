local neoscroll_status, neoscroll = pcall(require, "neoscroll")
if not neoscroll_status then
  return
end
local easing = "sine"
local zz_time_ms = 100
local jump_time_ms = 200

local mappings = {}

mappings["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", jump_time_ms, easing, "'center'" } }
mappings["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", jump_time_ms, easing, "'center'" } }

neoscroll.setup({
  mappings = mappings,
  hide_cursor = true, -- Hide cursor while scrolling
  stop_eof = true, -- Stop at <EOF> when scrolling downwards
  respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  performance_mode = false, -- Disable "Performance Mode" on all buffers.
  post_hook = function(info)
    if info ~= "center" then
      return
    end

    -- The `defer_fn` is a bit of a hack.
    -- We use it so that `neoscroll.init.scroll` will be false when we call `neoscroll.zz`
    -- As long as we don't input another neoscroll mapping in the timeout,
    -- we should be able to center the cursor.
    local defer_time_ms = 10
    vim.defer_fn(function()
      neoscroll.zz(zz_time_ms, easing)
    end, defer_time_ms)
  end,
})
