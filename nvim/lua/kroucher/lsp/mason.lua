local mason_status, mason = pcall(require, "mason")
if not mason_status then
  print("Mason not found")
  return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
  print("Mason lspconfig not found")
  return
end

local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
  print("Mason null-ls not found")
  return
end

local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
  print("lspconfig is not installed")
  return
end

mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    "dockerls",
    "docker_compose_language_service",
    "cssls",
    "eslint",
    "html",
    "jsonls",
    "lua_ls",
    "tailwindcss",
    "prismals",
  },
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      on_attach = require("kroucher.lsp.shared").on_attach,
      capabilities = require("kroucher.lsp.shared").capabilities,
    })
  end,
  ["lua_ls"] = function(server_name)
    require("lspconfig")[server_name].setup({
      on_attach = require("kroucher.lsp.shared").on_attach,
      capabilities = require("kroucher.lsp.shared").capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })
  end,
  ["tailwindcss"] = function(server_name)
    require("lspconfig")[server_name].setup({
      on_attach = require("kroucher.lsp.shared").on_attach,
      capabilities = require("kroucher.lsp.shared").capabilities,
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
            },
          },
        },
      },
    })
  end,
})

mason_null_ls.setup({
  -- list of formatters & linters for mason to install
  ensure_installed = {
    "prettier", -- ts/js formatter
    "eslint_d", -- ts/js linter
    "stylua",
  },
  -- auto-install configured formatters & linters (with null-ls)
  automatic_installation = true,
})
