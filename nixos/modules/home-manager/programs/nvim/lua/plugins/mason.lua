return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = function(_, opts)
      opts.ensure_installed = {
        "beautysh",
        "codelldb",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "eslint-lsp",
        "hadolint",
        "js-debug-adapter",
        "json-lsp",
        "lua-language-server",
        "markdownlint",
        "marksman",
        "prettier",
        "shellcheck",
        "shfmt",
        "stylua",
        "tailwindcss-language-server",
        "taplo",
        "typescript-language-server",
        "yaml-language-server",
      }
      require("mason-lspconfig").setup_handlers({
        ["rust_analyzer"] = function() end,
      })
      return opts
    end,
  },
}
