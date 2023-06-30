local null_ls_status, null_ls = pcall(require, "null-ls")
if not null_ls_status then
  return
end
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier.with({
      filetypes = {
        "javascript",
        "typescript",
        "typescriptreact",
        "css",
        "scss",
        "html",
        "json",
        "yaml",
        "markdown",
        "graphql",
        "md",
        "txt",
      },
      only_local = "node_modules/.bin",
    }),
    null_ls.builtins.formatting.stylua.with({
      filetypes = {
        "lua",
      },
      args = { "--indent-width", "2", "--indent-type", "Spaces", "-" },
    }),
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            async = false,
            bufnr = bufnr,
            filter = function()
              -- client name should be null-ls or prismals
              return client.name == "null-ls" or client.name == "prismals"
            end,
          })
        end,
      })
    end
  end,
})
