local Job = require("plenary.job")
local popup = require("plenary.popup")

-- Define the plugin namespace
local graphite = {}

-- Define a function to get the module path
local function get_module_path()
  -- Determine the module path based on your project's structure
  local module_path = "kroucher.graphite"
  return module_path
end

-- Define the completion function
function _G.graphite_complete(arg_lead, cmd_line, cursor_pos)
  -- Define a table of completion candidates
  local candidates = {
    "log_short",
    "branch_create",
    "commit_create",
    "commit_amend",
    "status",
    "restore",
    "repo_sync",
    "stack_submit",
    "downstack_get",
    "branch_checkout",
    "branch_up",
    "branch_down",
    "branch_bottom",
    "branch_top",
    "repo_init",
  }

  -- Filter the candidates based on the argument lead
  local matches = {}
  for _, candidate in ipairs(candidates) do
    if string.match(candidate, "^" .. arg_lead) then
      table.insert(matches, candidate)
    end
  end

  return matches
end

-- Define the Graphite command with autocompletion
vim.cmd(
  'command! -nargs=1 -complete=customlist,v:lua.graphite_complete Graphite lua require("'
    .. get_module_path()
    .. '")["gt_" .. <f-args>]()'
)

-- Define a function for each Graphite CLI command
function graphite.gt_log_short()
  local job = Job:new({
    command = "gt",
    args = { "log", "short" },
    on_exit = function(j)
      local output = j:result()
      vim.schedule(function()
        local win_id = popup.create(output, { width = 80, height = 20, border = {} })
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        vim.api.nvim_buf_set_keymap(
          buf_id,
          "n",
          "q",
          ":lua vim.api.nvim_win_close(0, false)<CR>",
          { noremap = true, silent = true }
        )
      end)
    end,
  })

  job:start()
end

function graphite.gt_status()
  local job = Job:new({
    command = "gt",
    args = { "status" },
    on_exit = function(j, return_val)
      local output = j:result()
      vim.schedule(function()
        local win_id = popup.create(output, { width = 80, height = 20, border = {} })
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        vim.api.nvim_buf_set_keymap(
          buf_id,
          "n",
          "q",
          ":lua vim.api.nvim_win_close(0, false)<CR>",
          { noremap = true, silent = true }
        )
      end)
    end,
  })

  job:start()
end

function graphite.gt_branch_checkout()
  -- Create a new terminal buffer
  local buf = vim.api.nvim_create_buf(true, false)

  -- Create a new window for the buffer
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 80,
    height = 20,
    col = 20,
    row = 10,
    border = "single",
  })

  -- Start the gt branch checkout command in the terminal buffer
  vim.fn.termopen("gt branch checkout", {
    on_exit = function()
      -- Close the window when the command exits
      vim.api.nvim_win_close(win, false)
      vim.api.nvim_buf_delete(buf, { force = true })
    end,
  })

  -- Enter terminal mode
  vim.cmd("startinsert")

  -- Set up an autocmd to close the new buffer and refresh the current buffer
  vim.cmd([[
    augroup GraphiteBranchCheckout
      autocmd!
      autocmd BufEnter * lua require('kroucher.graphite').handle_branch_checkout()
    augroup END
  ]])
end

function graphite.handle_branch_checkout()
  -- Get the current and previous buffer numbers
  local cur_buf = vim.api.nvim_get_current_buf()
  local prev_buf = vim.fn.bufnr("#")

  -- Close the previous buffer if it's not the current buffer
  if cur_buf ~= prev_buf then
    vim.api.nvim_buf_delete(prev_buf, { force = true })
  end

  -- Refresh the current buffer
  vim.cmd("e")

  -- Remove the autocmd
  vim.cmd("autocmd! GraphiteBranchCheckout")
end

-- Return the plugin namespace
return graphite
