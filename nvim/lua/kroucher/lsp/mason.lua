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

mason.setup()

mason_lspconfig.setup({
  ensure_installed = {
    "dockerls",
    "docker_compose_language_service",
    "cssls",
    "eslint",
    "html",
    "jsonls",
    "tsserver",
    "lua_ls",
    "prismals",
    "tailwindcss",
  },
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
})

mason_null_ls.setup({
  -- list of formatters & linters for mason to install
  ensure_installed = {
    "prettierd", -- ts/js formatter
    "eslint_d", -- ts/js linter
  },
  -- auto-install configured formatters & linters (with null-ls)
  automatic_installation = true,
})
