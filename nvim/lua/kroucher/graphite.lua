local Job = require("plenary.job")

-- Define the plugin namespace
local Graphite = {}

-- Define a function to get the module path
local function get_module_path()
  -- Determine the module path based on your project's structure
  local module_path = "kroucher.graphite"
  return module_path
end

function Graphite:create_window(buf, width, height, col, row)
  return vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    border = "single",
  })
end

function Graphite:set_keymap(buf, key, command)
  vim.api.nvim_buf_set_keymap(buf, "n", key, command, { noremap = true, silent = true })
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

Graphite.commands = {
  changelog = { "changelog" },
  log = { "log" },
  log_short = { "log", "short" },
  log_long = { "log", "long" },
  branch_info = { "branch", "info" },
  branch_create = { "branch", "create" },
  branch_top = { "branch", "top" },
  branch_bottom = { "branch", "bottom" },
  branch_up = { "branch", "up" },
  branch_down = { "branch", "down" },
  commit_create = { "commit", "create" },
  commit_amend = { "commit", "amend" },
  status = { "status" },
  upstack_onto = { "upstack", "onto" },
  upstack_restack = { "upstack", "restack" },
}

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
  Graphite.dashboard_win = Graphite:create_window(buf, vim.o.columns, vim.o.lines, 0, 0)

  -- Set the buffer's lines to the keybind hints
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "Hint: [b]ranch | [C]hangelog | [l]og | [s]tatus | [u]pstack | [e]xit",
  })

  -- Key mappings
  Graphite:set_keymap(buf, "b", ":lua require('kroucher.graphite').open_branch_keybinds_window()<CR>")
  Graphite:set_keymap(buf, "C", ":lua require('kroucher.graphite'):gt_changelog()<CR>")
  Graphite:set_keymap(buf, "l", ":lua require('kroucher.graphite').open_log_keybinds_window()<CR>")
  Graphite:set_keymap(buf, "s", ":lua require('kroucher.graphite'):gt_status()<CR>")
  Graphite:set_keymap(buf, "u", ":lua require('kroucher.graphite'):open_upstack_keybinds_window()<CR>")
  Graphite:set_keymap(buf, "e", ":lua require('kroucher.graphite').close_dashboard_window()<CR>")
end

-- Define a function to close the dashboard window
function Graphite.close_dashboard_window()
  -- Check if the current window is the last window
  local is_last_window = vim.fn.tabpagenr("$") == 1 and vim.fn.winnr("$") == 1

  -- Close the window if it's not the last window, otherwise close the tab
  if not is_last_window then
    vim.api.nvim_win_close(0, false)
  else
    vim.cmd("tabclose")
  end
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

        table.insert(output, 1, "[q]uit")
        table.insert(output, 2, "")

        -- Set the buffer's lines to the output of the command
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

        -- Create a new window for the buffer
        Graphite:create_window(buf, 120, 20, 20, 10)

        -- Set the buffer's options
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")

        -- Key mappings
        Graphite:set_keymap(
          buf,
          "q",
          ":lua vim.api.nvim_win_close(0, false); vim.api.nvim_win_close("
            .. tostring(self.log_hint_win)
            .. ", false); vim.api.nvim_win_close("
            .. tostring(self.upstack_hint_win)
            .. ", false); vim.api.nvim_win_close("
            .. tostring(self.branch_hint_win)
            .. ", false); vim.api.nvim_set_current_win("
            .. tostring(self.dashboard_win)
            .. ")<CR>"
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
  Graphite.log_hint_win = Graphite:create_window(log_kb_buf, 30, 10, 20, 10)

  -- Key mappings
  Graphite:set_keymap(
    log_kb_buf,
    "q",
    ":lua if vim.fn.tabpagenr('$') == 1 and vim.fn.winnr('$') == 1 then vim.cmd('quit') else vim.api.nvim_win_close(0, false) end<CR>"
  )
  Graphite:set_keymap(log_kb_buf, "<CR>", ":lua require('kroucher.graphite'):gt_log()<CR>")
  Graphite:set_keymap(log_kb_buf, "s", ":lua require('kroucher.graphite'):gt_log_short()<CR>")
  Graphite:set_keymap(log_kb_buf, "l", ":lua require('kroucher.graphite'):gt_log_long()<CR>")
end

-- Define a function for each Graphite CLI command
function Graphite:gt_status()
  self:run_command(Graphite.commands.status)
end

function Graphite:gt_log()
  self:run_command(Graphite.commands.log)
end

function Graphite:gt_log_short()
  self:run_command(Graphite.commands.log_short)
end

function Graphite:gt_log_long()
  self:run_command(Graphite.commands.log_long)
end

function Graphite:gt_branch_bottom()
  self:run_command(Graphite.commands.branch_bottom)
end

function Graphite:gt_branch_top()
  self:run_command(Graphite.commands.branch_top)
end

function Graphite:gt_branch_down()
  self:run_command(Graphite.commands.branch_down)
end

function Graphite:gt_branch_up()
  self:run_command(Graphite.commands.branch_up)
end

function Graphite:gt_branch_info()
  self:run_command(Graphite.commands.branch_info)
end

function Graphite:gt_changelog()
  self:run_command(Graphite.commands.changelog)
end

function Graphite:gt_upstack_restack()
  self:run_command(Graphite.commands.upstack_restack)
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
    "[i] branch info",
    "[b] branch bottom",
    "[t] branch top",
    "[d] branch down",
    "[u] branch up",
  })

  -- Create a new window for the buffer and store the window ID
  Graphite.branch_hint_win = Graphite:create_window(branch_kb_buf, 30, 10, 20, 10)

  -- Key mappings
  Graphite:set_keymap(
    branch_kb_buf,
    "q",
    ":lua if vim.fn.tabpagenr('$') == 1 and vim.fn.winnr('$') == 1 then vim.cmd('quit') else vim.api.nvim_win_close(0, false) end<CR>"
  )
  Graphite:set_keymap(branch_kb_buf, "<CR>", ":lua require('kroucher.graphite'):gt_branch_checkout()<CR>")
  Graphite:set_keymap(branch_kb_buf, "c", ":lua require('kroucher.graphite'):gt_branch_create()<CR>")
  Graphite:set_keymap(branch_kb_buf, "b", ":lua require('kroucher.graphite'):gt_branch_bottom()<CR>")
  Graphite:set_keymap(branch_kb_buf, "t", ":lua require('kroucher.graphite'):gt_branch_top()<CR>")
  Graphite:set_keymap(branch_kb_buf, "d", ":lua require('kroucher.graphite'):gt_branch_down()<CR>")
  Graphite:set_keymap(branch_kb_buf, "u", ":lua require('kroucher.graphite'):gt_branch_up()<CR>")
  Graphite:set_keymap(branch_kb_buf, "i", ":lua require('kroucher.graphite'):gt_branch_info()<CR>")
  Graphite:set_keymap(branch_kb_buf, "l", ":lua require('kroucher.graphite'):gt_branch_create()<CR>")
end

function Graphite:open_upstack_keybinds_window()
  -- Create a new buffer
  local upstack_kb_buf = vim.api.nvim_create_buf(false, true)

  -- Set the buffer's lines to the upstack keybinds
  vim.api.nvim_buf_set_lines(upstack_kb_buf, 0, -1, false, {
    "Upstack keybinds:",
    "[r] restack",
    "[o] upstack onto",
  })

  -- Create a new window for the buffer and store the window ID
  Graphite.upstack_hint_win = Graphite:create_window(upstack_kb_buf, 30, 10, 20, 10)

  -- Key mappings
  Graphite:set_keymap(
    upstack_kb_buf,
    "q",
    ":lua if vim.fn.tabpagenr('$') == 1 and vim.fn.winnr('$') == 1 then vim.cmd('quit') else vim.api.nvim_win_close(0, false) end<CR>"
  )
  Graphite:set_keymap(upstack_kb_buf, "o", ":lua require('kroucher.graphite'):gt_upstack_onto()<CR>")
  Graphite:set_keymap(upstack_kb_buf, "r", ":lua require('kroucher.graphite'):gt_upstack_restack()<CR>")
end

function Graphite:gt_upstack_onto()
  local job = Job:new({
    command = "gt",
    args = Graphite.commands.log_short,
    on_exit = function(j)
      local output = j:result()
      vim.schedule(function()
        -- Parse the output to extract the branch names
        local branches = {}
        local current_branch
        for _, line in ipairs(output) do
          local branch = line:match("[◯│◉─┘%s]+(.*)")
          if branch and #branch > 0 then
            -- Check if the branch is currently checked out
            if line:match("◉") then
              current_branch = branch
            else
              -- Add the line to the branches table
              table.insert(branches, line)
            end
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
        Graphite:create_window(buf, 80, 20, 20, 10)

        -- Set the buffer's options
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")

        -- Key mappings
        Graphite:set_keymap(
          buf,
          "q",
          ":lua vim.api.nvim_win_close(0, false); vim.api.nvim_set_current_win("
            .. tostring(self.dashboard_win)
            .. ")<CR>"
        )
        Graphite:set_keymap(
          buf,
          "<CR>",
          ":lua require('kroucher.graphite'):upstack_onto_selected_branch('" .. current_branch .. "')<CR>"
        )
      end)
    end,
  })

  job:start()
end

function Graphite:upstack_onto_selected_branch(current_branch)
  -- Get the current line in the buffer
  local line = vim.api.nvim_get_current_line()

  -- Extract the branch name from the line
  local branch = line:match("[◯│◉─┘%s]+(.*)")

  -- Check if the selected branch is the current branch
  if branch == current_branch then
    print("Cannot upstack onto the current branch.")
    return
  end

  -- -- Run the gt upstack onto command with the branch name and capture its output and exit code
  -- local output = vim.fn.system("gt upstack onto " .. branch)
  local output = vim.fn.system(Graphite.commands.upstack_onto .. " " .. branch)
  local exit_code = vim.v.shell_error

  -- Check the exit code
  if exit_code == 0 then
    -- The command succeeded, print a message to the console
    print("Ran upstack onto on branch: " .. branch)
  else
    -- The command failed, print an error message to the console
    print("Error running upstack onto on branch: " .. branch)
    print("Output: " .. output)
  end

  -- Close the window
  vim.api.nvim_win_close(Graphite.upstack_hint_win, true)
  vim.api.nvim_win_close(0, true)

  -- Set the focus back to the dashboard window
  vim.api.nvim_set_current_win(self.dashboard_win)

  -- Set the buffer options for the dashboard
  local buf = vim.api.nvim_win_get_buf(self.dashboard_win)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
end

function Graphite:gt_branch_create()
  -- Prompt the user for the name of the new branch
  local branch_name = vim.fn.input("Enter the name of the new branch: ")

  -- Run the gt branch create command with the branch name
  local job = Job:new({
    command = "gt",
    args = { "branch", "create", branch_name },
    on_exit = function(j)
      local output = j:result()
      local exit_code = j.code
      print("Exit code: " .. exit_code)
      vim.schedule(function()
        if exit_code == 0 then
          -- The command succeeded, print a success message
          print("Successfully created branch: " .. branch_name)
        else
          -- The command failed, print an error message
          print("Error creating branch: " .. branch_name)
          print("Output: " .. table.concat(output, "\n"))
        end

        -- Close the branch hint window
        vim.api.nvim_win_close(self.branch_hint_win, false)
      end)
    end,
  })

  job:start()
end

function Graphite:gt_branch_checkout()
  local job = Job:new({
    command = "gt",
    args = Graphite.commands.log_short,
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
        Graphite:create_window(buf, 80, 20, 20, 10)

        -- Set the buffer's options
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")

        -- Key mappings
        Graphite:set_keymap(
          buf,
          "q",
          ":lua vim.api.nvim_win_close(0, false); vim.api.nvim_set_current_win("
            .. tostring(self.dashboard_win)
            .. ")<CR>"
        )
        Graphite:set_keymap(buf, "<CR>", ":lua require('kroucher.graphite'):checkout_selected_branch()<CR>")
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
