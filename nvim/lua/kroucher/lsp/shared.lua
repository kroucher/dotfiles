local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  print("Failed to load cmp_nvim_lsp")
  return
end

local M = {}

M.setup = function()
  local protocol = require("vim.lsp.protocol")
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  protocol.CompletionItemKind = {
    "", -- Text
    "", -- Method
    "", -- Function
    "", -- Constructor
    "", -- Field
    "", -- Variable
    "", -- Class
    "ﰮ", -- Interface
    "", -- Module
    "", -- Property
    "", -- Unit
    "", -- Value
    "", -- Enum
    "", -- Keyword
    "﬌", -- Snippet
    "", -- Color
    "", -- File
    "", -- Reference
    "", -- Folder
    "", -- EnumMember
    "", -- Constant
    "", -- Struct
    "", -- Event
    "ﬦ", -- Operator
    "", -- TypeParameter
  }
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 4, prefix = "●" },
    severity_sort = true,
  })

  vim.o.updatetime = 250
  vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

  vim.o.statuscolumn =
    '%=%l%s%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "▼" : "⏵") : " " }'

  vim.api.nvim_create_autocmd("BufRead", {
    callback = function()
      vim.filetype.add({
        filename = {
          [".env"] = "sh",
          [".envrc"] = "sh",
          ["*.env"] = "sh",
          ["*.envrc"] = "sh",
        },
      })
    end,
  })
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }

  vim.api.nvim_buf_set_keymap(bufnr, "n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gh", "<cmd>Lspsaga lsp_finder<CR>", opts) -- set loclist for diagnostics
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
  vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side

  local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
  vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup_format,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({
        bufnr = bufnr,
      })
    end,
  })
end

M.on_attach = function(client, bufnr)
  if client.name == "jsonls" then
    client.server_capabilities.documentFormattingProvider = false
  end
  lsp_keymaps(bufnr)
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

return M
