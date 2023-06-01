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
  -- Run the gt branch checkout command non-interactively and capture its output
  -- Run the gt log short command non-interactively and capture its output
  local output = vim.fn.systemlist("gt log short")

  -- Parse the output to extract the branch names
  local branches = {}
  for _, line in ipairs(output) do
    local branch = line:match("[◯│◉─┘%s]+(.*)")
    if branch and #branch > 0 then
      -- Add the line to the branches table
      table.insert(branches, line)
    end
  end

  --Add instructions to the branches table

  -- Add instructions to the branches table
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
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = 80,
    height = 20,
    col = 20,
    row = 10,
    border = "single",
  })

  -- Set up a key mapping for the 'q' key to close the window
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })

  -- Set up a key mapping for the 'Enter' key to checkout the selected branch and close the window
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "<CR>",
    ':lua require("kroucher.graphite").checkout_selected_branch()<CR>',
    { noremap = true, silent = true }
  )
end

function graphite.checkout_selected_branch()
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

function graphite.gt_branch_create()
  -- Save the command line state
  vim.fn.inputsave()

  -- Open a prompt for the user to enter a new branch name
  local branch_name = vim.fn.input("Enter new branch name: ")

  -- Restore the command line state
  vim.fn.inputrestore()

  -- Check if the user entered a branch name
  if branch_name ~= "" then
    -- Run the gt branch create command with the entered name
    local output = vim.fn.system("gt branch create " .. branch_name)
    local exit_code = vim.v.shell_error

    -- Check the exit code
    if exit_code == 0 then
      -- The command succeeded, print a message to the console
      print("  ...Created new branch: " .. branch_name)
    else
      -- The command failed, print an error message to the console
      print("  ...Error creating new branch: " .. branch_name)
      print("Output: " .. output)
    end
  else
    -- The user did not enter a branch name, print a message to the console
    print("No branch name entered.")
  end
end

function graphite.gt_commit_create()
  -- Save the command line state
  vim.fn.inputsave()

  -- Open a prompt for the user to enter a commit message
  local commit_message = vim.fn.input("Enter commit message: ")

  -- Restore the command line state
  vim.fn.inputrestore()

  -- Check if the user entered a commit message
  if commit_message ~= "" then
    -- Wrap the commit message in quotation marks if it contains spaces
    if commit_message:find(" ") then
      commit_message = '"' .. commit_message .. '"'
    end

    -- Run the gt commit create command with the entered message
    local output = vim.fn.system("gt commit create -m " .. commit_message)
    local exit_code = vim.v.shell_error

    -- Check the exit code
    if exit_code == 0 then
      -- The command succeeded, print a message to the console
      print("  ...Created new commit: " .. commit_message)
    else
      -- The command failed, print an error message to the console
      print("  ...Error creating new commit: " .. commit_message)
      print("  ...Output: " .. output)
    end
  else
    -- The user did not enter a commit message, print a message to the console
    print("  ...No commit message entered.")
  end
end

function graphite.gt_commit_amend()
  -- Save the command line state
  vim.fn.inputsave()

  -- Open a prompt for the user to enter a new commit message
  local commit_message = vim.fn.input("Enter new commit message: ")

  -- Restore the command line state
  vim.fn.inputrestore()

  -- Check if the user entered a commit message
  if commit_message ~= "" then
    -- Wrap the commit message in quotation marks if it contains spaces
    if commit_message:find(" ") then
      commit_message = '"' .. commit_message .. '"'
    end

    -- Run the gt commit amend command with the entered message
    local output = vim.fn.system("gt commit amend -m " .. commit_message)
    local exit_code = vim.v.shell_error

    -- Check the exit code
    if exit_code == 0 then
      -- The command succeeded, print a message to the console
      print("  ...Amended commit with new message: " .. commit_message)
    else
      -- The command failed, print an error message to the console
      print("  ...Error amending commit: " .. commit_message)
      print("  ...Output: " .. output)
    end
  else
    -- The user did not enter a commit message, print a message to the console
    print("  ...No commit message entered.")
  end
end

-- Return the plugin namespace
return graphite
