local Input = require "nui.input"
local Job = require "plenary.job"
local Popup = require "nui.popup"
local event = require("nui.utils.autocmd").event

-- Define the plugin namespace
local Graphite = {}

-- Define a function to get the module path
local function get_module_path()
  -- Determine the module path based on your project's structure
  local module_path = "kroucher.graphite"
  return module_path
end

function Graphite:create_input(title, on_submit)
  local input = Input({
    border = {
      style = "rounded",
      text = {
        top = title,
        top_align = "center",
      },
    },
    relative = "editor",
    position = "50%",
    size = {
      width = 40,
      height = 2,
    },
  }, {
    prompt = "> ",
    default_value = "",
    on_submit = on_submit,
    on_close = function()
      print "Input closed"
    end,
  })

  return input
end

function Graphite:create_window(title, hint)
  local popup = Popup({
    zindex = 10,
    border = {
      padding = { 1, 1, 1, 1 }, -- optional
      style = "rounded",
      text = { top = title, top_align = "center", bottom = hint, bottom_align = "center" },
    },
    relative = "editor",
    position = "50%",
    size = {
      width = "70%",
      height = "70%",
    },
    enter = true,
    focusable = true,
    buf_options = {
      modifiable = true,
      readonly = false,
    },
  })

  popup:mount()

  return popup
end

function Graphite:create_keybinds_window(title)
  local popup = Popup({
    border = {
      padding = { 1, 1, 1, 1 }, -- optional
      style = "rounded",
      text = { top = title, top_align = "center" },
    },
    relative = "editor",
    position = {
      row = "80%",
      col = "0%",
    },
    size = {
      width = "30%",
      height = "20%",
    },
    enter = true,
    focusable = true,
    buf_options = {
      modifiable = true,
      readonly = false,
    },
  })

  popup:mount()

  return popup
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
    if string.match(candidate, "^" .. arg_lead) then table.insert(matches, candidate) end
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
  downstack_get = { "downstack", "get" },
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
  -- Create a new window for the buffer
  local dashboard = Graphite:create_window "Graphite Dashboard"

  -- Set the buffer's lines to the keybind hints
  vim.api.nvim_buf_set_lines(dashboard.bufnr, 0, -1, false, {
    "Hint: [b]ranch | [C]hangelog | [d]ownstack | [l]og | [s]tatus | [u]pstack | [q]uit",
  })

  -- Key mappings
  dashboard:map("n", "b", ":lua require('kroucher.graphite').open_branch_keybinds_window()<CR>")
  dashboard:map("n", "C", ":lua require('kroucher.graphite'):gt_changelog()<CR>")
  dashboard:map("n", "l", ":lua require('kroucher.graphite').open_log_keybinds_window()<CR>")
  dashboard:map("n", "s", ":lua require('kroucher.graphite'):gt_status()<CR>")
  dashboard:map("n", "u", ":lua require('kroucher.graphite'):open_upstack_keybinds_window()<CR>")
  dashboard:map("n", "q", function()
    dashboard:unmount()
  end)
  dashboard:map("n", "d", ":lua require('kroucher.graphite').open_downstack_keybinds_window()<CR>")
end

-- Define a function to run a Graphite command
function Graphite:run_command(args)
  local job = Job:new({
    command = "gt",
    args = args,
    on_exit = function(j)
      local output = j:result()
      vim.schedule(function()
        -- Create a new window for the buffer
        local command = Graphite:create_window("gt_" .. table.concat(args, "_"), "[q] Return to Dashboard")

        -- Set the buffer's lines to the output of the command
        vim.api.nvim_buf_set_lines(command.bufnr, 0, -1, false, output)

        -- Set the buffer's options
        vim.api.nvim_buf_set_option(command.bufnr, "modifiable", false)
        vim.api.nvim_buf_set_option(command.bufnr, "bufhidden", "hide")

        -- Key mappings
        command:map("n", "q", function()
          if vim.fn.tabpagenr "$" == 1 and vim.fn.winnr "$" == 1 then
            vim.cmd "quit"
          else
            command:unmount()
          end
        end)
      end)
    end,
  })

  job:start()
end

-- Define a function to open the log keybinds window
function Graphite:open_log_keybinds_window()
  -- Create a new window for the buffer and store the window ID
  local log_window = Graphite:create_keybinds_window "gt log keybinds"

  -- Set the buffer's lines to the log keybinds
  vim.api.nvim_buf_set_lines(log_window.bufnr, 0, -1, false, {
    "Log keybinds:",
    "[<CR>] log",
    "[s] log short",
    "[l] log long",
  })

  -- Key mappings
  log_window:map("n", "q", function()
    if vim.fn.tabpagenr "$" == 1 and vim.fn.winnr "$" == 1 then
      vim.cmd "quit"
    else
      log_window:unmount()
    end
  end, { noremap = true, silent = true })

  log_window:map("n", "<CR>", function()
    Graphite:gt_log()
    log_window:unmount()
  end, { noremap = true, silent = true })

  log_window:map("n", "s", function()
    Graphite:gt_log_short()
    log_window:unmount()
  end, { noremap = true, silent = true })

  log_window:map("n", "l", function()
    Graphite:gt_log_long()
    log_window:unmount()
  end, { noremap = true, silent = true })
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
  -- Create a new window for the buffer and store the window ID
  local branch_window = Graphite:create_keybinds_window "gt branch"

  -- Set the buffer's lines to the branch keybinds
  vim.api.nvim_buf_set_lines(branch_window.bufnr, 0, -1, false, {
    "Branch keybinds:",
    "[<CR>] branch checkout",
    "[c] branch create",
    "[i] branch info",
    "[b] branch bottom",
    "[t] branch top",
    "[d] branch down",
    "[u] branch up",
  })
  -- Key mappings
  branch_window:map("n", "q", function()
    if vim.fn.tabpagenr "$" == 1 and vim.fn.winnr "$" == 1 then
      vim.cmd "quit"
    else
      vim.api.nvim_win_close(0, false)
    end
  end, { noremap = true, silent = true })

  branch_window:map("n", "<CR>", function()
    branch_window:unmount()
    Graphite:gt_branch_checkout()
  end, { noremap = true, silent = true })

  branch_window:map("n", "c", function()
    branch_window:unmount()
    Graphite:gt_branch_create()
  end, { noremap = true, silent = true })

  branch_window:map("n", "b", function()
    branch_window:unmount()
    Graphite:gt_branch_bottom()
  end, { noremap = true, silent = true })

  branch_window:map("n", "t", function()
    branch_window:unmount()
    Graphite:gt_branch_top()
  end, { noremap = true, silent = true })

  branch_window:map("n", "d", function()
    branch_window:unmount()
    Graphite:gt_branch_down()
  end, { noremap = true, silent = true })

  branch_window:map("n", "u", function()
    branch_window:unmount()
    Graphite:gt_branch_up()
  end, { noremap = true, silent = true })

  branch_window:map("n", "i", function()
    branch_window:unmount()
    Graphite:gt_branch_info()
  end, { noremap = true, silent = true })
end

function Graphite:open_upstack_keybinds_window()
  -- Create a new window for the buffer and store the window ID
  local upstack_window = Graphite:create_keybinds_window "gt upstack"

  -- Set the buffer's lines to the upstack keybinds
  vim.api.nvim_buf_set_lines(upstack_window.bufnr, 0, -1, false, {
    "Upstack keybinds:",
    "[r] restack",
    "[o] upstack onto",
  })

  -- Key mappings
  upstack_window:map("n", "q", function()
    if vim.fn.tabpagenr "$" == 1 and vim.fn.winnr "$" == 1 then
      vim.cmd "quit"
    else
      upstack_window:unmount()
    end
  end, { noremap = true, silent = true })

  upstack_window:map("n", "o", function()
    require("kroucher.graphite"):gt_upstack_onto()
  end, { noremap = true, silent = true })

  upstack_window:map("n", "r", function()
    require("kroucher.graphite"):gt_upstack_restack()
  end, { noremap = true, silent = true })
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
          local branch = line:match "[◯│◉─┘%s]+(.*)"
          if branch and #branch > 0 then
            -- Check if the branch is currently checked out
            if line:match "◉" then
              current_branch = branch
            else
              -- Add the line to the branches table
              table.insert(branches, line)
            end
          end
        end

        -- Create a new buffer
        local buf = Graphite:create_window(
          "upstack onto",
          "Use the arrow keys to navigate, press Enter to select a branch, and press q to close this window."
        )

        -- Set the buffer's lines to the branch names
        vim.api.nvim_buf_set_lines(buf.bufnr, 0, -1, false, branches)

        -- Key mappings
        buf:map(
          "n",
          "q",
          ":lua vim.api.nvim_win_close(0, false); vim.api.nvim_set_current_win("
            .. tostring(self.dashboard_win)
            .. ")<CR>"
        )
        buf:map(
          "n",
          "<CR>",
          ":lua require('kroucher.graphite'):upstack_onto_selected_branch('" .. current_branch .. "')<CR>"
        )
      end)
    end,
  })

  job:start()
end

function Graphite:open_downstack_keybinds_window()
  -- Create a new buffer
  local downstack_kb_buf = Graphite:create_keybinds_window "gt downstack"

  -- Set the buffer's lines to the downstack keybinds
  vim.api.nvim_buf_set_lines(downstack_kb_buf.bufnr, 0, -1, false, {
    "Downstack keybinds:",
    "[g] downstack get",
    -- Add more downstack commands here
  })

  -- Key mappings
  downstack_kb_buf:map(
    "n",
    "q",
    ":lua if vim.fn.tabpagenr('$') == 1 and vim.fn.winnr('$') == 1 then vim.cmd('quit') else vim.api.nvim_win_close(0, false) end<CR>"
  )
  downstack_kb_buf:map("n", "g", ":lua require('kroucher.graphite'):gt_downstack_get()<CR>")
  -- Add key mappings for more downstack commands here
end

function Graphite:upstack_onto_selected_branch(current_branch)
  -- Get the current line in the buffer
  local line = vim.api.nvim_get_current_line()

  -- Extract the branch name from the line
  local branch = line:match "[◯│◉─┘%s]+(.*)"

  -- Check if the selected branch is the current branch
  if branch == current_branch then
    print "Cannot upstack onto the current branch."
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

function Graphite:handle_branch_create(input)
  print(vim.inspect(input)) -- Add this line to print the input object

  -- Run the gt branch create command with the branch name
  local job = Job:new({
    command = "gt",
    args = { "branch", "create", input },
    on_exit = function(j)
      local output = j:result()
      local exit_code = j.code
      vim.schedule(function()
        if exit_code == 0 then
          -- The command succeeded, print a success message
          print("Successfully created branch: " .. input)
        else
          -- The command failed, print an error message
          print("Error creating branch: " .. input)
          print("Output: " .. table.concat(output, "\n"))
        end
      end)
    end,
  })

  job:start()
end

function Graphite:gt_branch_create()
  local input = self:create_input("Create Branch", function(value)
    self:handle_branch_create(value)
  end)

  input:mount()
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
          local branch = line:match "[◯│◉─┘%s]+(.*)"
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
        Graphite:create_window "gt branch checkout"

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
  local branch = line:match "[◯│◉─┘%s]+(.*)"

  -- Store the "(needs restack)" string if it exists
  local needs_restack = branch:match "%s*(%(needs restack%))"

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
