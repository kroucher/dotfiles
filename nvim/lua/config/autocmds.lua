-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
--
--
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- local tailwind_config_path_cache = nil
-- local custom_events = augroup("CustomEvents")
-- local opt_local = vim.opt_local
-- local treesitter = vim.treesitter
-- local lfs = require("lfs")
local autocmd = vim.api.nvim_create_autocmd

local function db_completion()
  ---@diagnostic disable-next-line: missing-fields
  require("cmp").setup.buffer({
    sources = { { name = "vim-dadbod-completion" } },
  })
end

vim.g.db_ui_save_location = vim.fn.stdpath("config")
  .. require("plenary.path").path.sep
  .. "db_ui"

autocmd("FileType", {
  pattern = {
    "sql",
  },
  command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
})

autocmd("FileType", {
  pattern = {
    "sql",
    "mysql",
    "plsql",
  },
  callback = function()
    vim.schedule(db_completion)
  end,
})

-- Disable Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    -- vim.highlight.on_yank()
  end,
})

-- local M = {}
--
-- -- Recursive function to find a file in a directory and its subdirectories
-- local function find_file_in_directory(target_file, directory)
--   for file in lfs.dir(directory) do
--     if file ~= "." and file ~= ".." then
--       local path = directory .. "/" .. file
--       local attr = lfs.attributes(path)
--       if attr.mode == "directory" then
--         local found_path = find_file_in_directory(target_file, path)
--         if found_path then
--           return found_path
--         end
--       elseif file == target_file then
--         return path
--       end
--     end
--   end
--   return nil
-- end
--
-- -- Function to find the tailwind.config.ts file starting from the current working directory
-- local function find_tailwind_config()
--   -- Return cached path if available
--   if tailwind_config_path_cache then
--     return tailwind_config_path_cache
--   end
--
--   local current_working_directory = vim.fn.getcwd()
--   tailwind_config_path_cache =
--     find_file_in_directory("tailwind.config.ts", current_working_directory)
--   return tailwind_config_path_cache
-- end
--
-- M.fold = function()
--   -- Exit early if this is not a Tailwind CSS project.
--   local config_path = find_tailwind_config()
--   if not config_path then
--     print("tailwind.config.ts not found in the project")
--     return
--   end
--
--   local ok, tailwind_config = pcall(io.open, config_path, "r")
--   if ok and tailwind_config then
--     tailwind_config:close()
--   -- Fall through.
--   else
--     print("Error opening file:", tailwind_config) -- Assuming tailwind_config is the error message
--     return
--   end
--
--   -- Enable 'conceallevel' option, this will do the actual hidding of HTML class
--   -- attributes.
--   opt_local.conceallevel = 2
--
--   local bufnr = vim.api.nvim_get_current_buf()
--   local conceal_ns = vim.api.nvim_create_namespace("class_conceal")
--   local language_tree = treesitter.get_parser(bufnr, "html")
--   local syntax_tree = language_tree:parse()
--   local root = syntax_tree[1]:root()
--
--   local query = [[
--     ((attribute
--       (attribute_name) @att_name (#eq? @att_name "className")
--       (quoted_attribute_value (attribute_value) @class_value) (#set! @class_value conceal "…")))
--   ]]
--
--   local ts_query
--   ok, ts_query = pcall(treesitter.query.parse, "html", query)
--   if not ok then
--     return
--   end
--
--   for _, captures, metadata in
--     ts_query:iter_matches(root, bufnr, root:start(), root:end_(), {})
--   do
--     local start_row, start_col, end_row, end_col = captures[2]:range()
--     -- This conditional prevents conceal leakage if the class attribute is erroneously formed.
--     if (end_row - start_row) == 0 then
--       vim.api.nvim_buf_set_extmark(bufnr, conceal_ns, start_row, start_col, {
--         end_line = end_row,
--         end_col = end_col,
--         conceal = metadata[2].conceal,
--       })
--     end
--   end
-- end
--
-- autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
--   group = custom_events,
--   pattern = { "*.astro", "*.html", "*.tsx" },
--   callback = function()
--     M.fold()
--   end,
-- })

autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("ts_fix_imports", { clear = true }),
  desc = "Add missing imports and remove unused imports for TS",
  pattern = { "*.ts", "*.tsx" },
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {
      only = { "source.addMissingImports.ts" },
    }
    local result =
      vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.kind == "source.addMissingImports.ts" then
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { "source.addMissingImports.ts" },
            },
          })
          vim.cmd("write")
        end
      end
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})

-- test
