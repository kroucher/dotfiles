local lsp_config = require("lspconfig")

lsp_config.lua_ls.setup({
  commands = {
    Format = {
      function()
        require("stylua-nvim").format_file()
      end,
    },
  },
  ...,
})

lsp_config.tsserver.setup({})
