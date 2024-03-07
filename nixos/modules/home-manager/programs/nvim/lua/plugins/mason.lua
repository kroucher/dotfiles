return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
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
      },
    },
  },
}
