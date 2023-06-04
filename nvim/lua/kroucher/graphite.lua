local Job = require("plenary.job")
local popup = require("plenary.popup")

-- Define the plugin namespace
local Graphite = {}

-- Define a function to get the module path
local function get_module_path()
  -- Determine the module path based on your project's structure
  local module_path = "kroucher.graphite"
  return module_path
end

-- Define the completion function
function _G:graphite_complete(arg_lead)
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
  'command! -nargs=* -complete=customlist,v:lua.graphite_complete Graphite lua require("'
    .. get_module_path()
    .. '").graphite_command(<f-args>)'
)

-- Define a function to handle the Graphite command
function Graphite:graphite_command(arg)
  if arg == nil then
    -- If no argument is passed, open the Graphite dashboard
    Graphite:launch_dashboard()
  else
    -- If an argument is passed, run the corresponding Graphite command
    local command = "gt_" .. arg
    if Graphite[command] then
      Graphite[command]()
    else
      print("Unknown command: " .. arg)
    end
  end
end

function Graphite:launch_dashboard()
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Create a new window for the buffer
  Graphite.dashboard_win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = vim.o.columns,
    height = vim.o.lines,
    row = 0,
    col = 0,
    border = "single",
  })

  -- Set the buffer's lines to the keybind hints
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "Hint: [b]ranch | [l]og | [s]tatus | [q]uit",
  })

  -- Set up a key mapping for the 'q' key to close the window or the tab if it's the last window
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "q",
    ":lua if vim.fn.tabpagenr('$') == 1 and vim.fn.winnr('$') == 1 then vim.cmd('quit') else vim.api.nvim_win_close(0, false) end<CR>",
    { noremap = true, silent = true }
  )

  -- Set up a key mapping for the 'l' key to open the log keybinds window
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "l",
    ':lua require("kroucher.graphite").open_log_keybinds_window()<CR>',
    { noremap = true, silent = true }
  )

  -- Set up a key mapping for the 's' key to run the gt_status command
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "s",
    ':lua require("kroucher.graphite"):gt_status()<CR>',
    { noremap = true, silent = true }
  )

  -- Set up a key mapping for the 'b' key to open the branch keybinds window
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "b",
    ':lua require("kroucher.graphite").open_branch_keybinds_window()<CR>',
    { noremap = true, silent = true }
  )
end

-- Define a function to run a Graphite command
function Graphite:run_command(args)
  local job = Job:new({
    command = "gt",
    args = args,
    on_exit = function(j)
      local output = j:result()
      vim.schedule(function()
        -- Create a new buffer
        local buf = vim.api.nvim_create_buf(false, true)

        -- Add blank lines and the message to the output
        table.insert(output, "")
        table.insert(output, "")
        table.insert(output, "Press 'q' to close this window.")

        -- Set the buffer's lines to the output of the command
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

        -- Create a new window for the buffer
        local win_id = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = 120,
          height = 20,
          col = 20,
          row = 10,
          border = "single",
        })

        -- Set the buffer's options
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")

        -- Set up a key mapping for the 'q' key to close the window
        vim.api.nvim_buf_set_keymap(
          buf,
          "n",
          "q",
          ":lua vim.api.nvim_win_close(0, false); vim.api.nvim_set_current_win("
            .. tostring(self.dashboard_win)
            .. ")<CR>",
          { noremap = true, silent = true }
        )
      end)
    end,
  })

  job:start()
end

-- Define a function to open the log keybinds window
function Graphite:open_log_keybinds_window()
  -- Create a new buffer
  local log_kb_buf = vim.api.nvim_create_buf(false, true)

  -- Set the buffer's lines to the log keybinds
  vim.api.nvim_buf_set_lines(log_kb_buf, 0, -1, false, {
    "Log keybinds:",
    "[<CR>] log",
    "[s] log short",
    "[l] log long",
  })

  -- Create a new window for the buffer and store the window ID
  Graphite.log_hint_win = vim.api.nvim_open_win(log_kb_buf, true, {
    relative = "editor",
    width = 30,
    height = 10,
    col = 20,
    row = 10,
    border = "single",
  })

  -- Set up a key mapping for the 'q' key to close the window or the tab if it's the last window
  vim.api.nvim_buf_set_keymap(
    log_kb_buf,
    "n",
    "q",
    ":lua if vim.fn.tabpagenr('$') == 1 and vim.fn.winnr('$') == 1 then vim.cmd('quit') else vim.api.nvim_win_close(0, false) end<CR>",
    { noremap = true, silent = true }
  )

  -- Set up key mappings for the log keybinds
  vim.api.nvim_buf_set_keymap(
    log_kb_buf,
    "n",
    "<CR>",
    ':lua require("kroucher.graphite"):gt_log()<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    log_kb_buf,
    "n",
    "s",
    ':lua require("kroucher.graphite"):gt_log_short()<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    log_kb_buf,
    "n",
    "l",
    ':lua require("kroucher.graphite"):gt_log_long()<CR>',
    { noremap = true, silent = true }
  )
end

-- Define a function for each Graphite CLI command
function Graphite:gt_status()
  self:run_command({ "status" })
end

function Graphite:gt_log()
  self:run_command({ "log" })
end

function Graphite:gt_log_short()
  self:run_command({ "log", "short" })
end

function Graphite:gt_log_long()
  self:run_command({ "log", "long" })
end

-- Define a function to open the branch keybinds window
function Graphite:open_branch_keybinds_window()
  -- Create a new buffer
  local branch_kb_buf = vim.api.nvim_create_buf(false, true)

  -- Set the buffer's lines to the branch keybinds
  vim.api.nvim_buf_set_lines(branch_kb_buf, 0, -1, false, {
    "Branch keybinds:",
    "[<CR>] branch checkout",
    "[c] branch create",
  })

  -- Create a new window for the buffer and store the window ID
  Graphite.branch_hint_win = vim.api.nvim_open_win(branch_kb_buf, true, {
    relative = "editor",
    width = 30,
    height = 10,
    col = 20,
    row = 10,
    border = "single",
  })

  -- Set up a key mapping for the 'q' key to close the window or the tab if it's the last window
  -- Set up a key mapping for the 'q' key to close the window
  vim.api.nvim_buf_set_keymap(
    branch_kb_buf,
    "n",
    "q",
    ":lua if vim.fn.tabpagenr('$') == 1 and vim.fn.winnr('$') == 1 then vim.cmd('quit') else vim.api.nvim_win_close(0, false) end<CR>",
    { noremap = true, silent = true }
  )

  -- Set up key mappings for the branch keybinds
  vim.api.nvim_buf_set_keymap(
    branch_kb_buf,
    "n",
    "<CR>",
    ':lua require("kroucher.graphite").gt_branch_checkout(require("kroucher.graphite"))<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    branch_kb_buf,
    "n",
    "c",
    ':lua require("kroucher.graphite").gt_branch_create(require("kroucher.graphite"))<CR>',
    { noremap = true, silent = true }
  )
end

function Graphite:gt_branch_checkout()
  local job = Job:new({
    command = "gt",
    args = { "log", "short" },
    on_exit = function(j)
      local output = j:result()
      vim.schedule(function()
        -- Parse the output to extract the branch names
        local branches = {}
        for _, line in ipairs(output) do
          local branch = line:match("[◯│◉─┘%s]+(.*)")
          if branch and #branch > 0 then
            -- Add the line to the branches table
            table.insert(branches, line)
          end
        end

        -- Add instructions to the branches table
        table.insert(branches, "")
        table.insert(branches, "")
        table.insert(
          branches,
          "Use the arrow keys to navigate, press Enter to select a branch, and press q to close this window."
        )

        -- Create a new buffer
        local buf = vim.api.nvim_create_buf(false, true)

        -- Set the buffer's lines to the branch names
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, branches)

        -- Create a new window for the buffer
        local win_id = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = 80,
          height = 20,
          col = 20,
          row = 10,
          border = "single",
        })

        -- Set the buffer's options
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")

        -- Set up a key mapping for the 'q' key to close the window
        vim.api.nvim_buf_set_keymap(
          buf,
          "n",
          "q",
          ":lua vim.api.nvim_win_close(0, false); vim.api.nvim_set_current_win("
            .. tostring(self.dashboard_win)
            .. ")<CR>",
          { noremap = true, silent = true }
        )

        -- Set up a key mapping for the 'Enter' key to checkout the selected branch and close the window
        vim.api.nvim_buf_set_keymap(
          buf,
          "n",
          "<CR>",
          ':lua require("kroucher.graphite"):checkout_selected_branch()<CR>',
          { noremap = true, silent = true }
        )
      end)
    end,
  })

  job:start()
end

function Graphite:checkout_selected_branch()
  -- Get the current line in the buffer
  local line = vim.api.nvim_get_current_line()

  -- Extract the branch name from the line
  local branch = line:match("[◯│◉─┘%s]+(.*)")

  -- Store the "(needs restack)" string if it exists
  local needs_restack = branch:match("%s*(%(needs restack%))")

  -- Remove the "(needs restack)" string from the branch name
  branch = branch:gsub("%s*%(needs restack%)", "")

  -- Run the gt branch checkout command with the branch name and capture its output and exit code
  local output = vim.fn.system("gt branch checkout " .. branch)
  local exit_code = vim.v.shell_error

  -- Check the exit code
  if exit_code == 0 then
    -- The command succeeded, print a message to the console
    print("Checked out branch: " .. branch .. " " .. (needs_restack or ""))
  else
    -- The command failed, print an error message to the console
    print("Error checking out branch: " .. branch)
    print("Output: " .. output)
  end

  -- Close the window
  vim.api.nvim_win_close(0, true)
end

-- Return the plugin namespace
return Graphite
