return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" } })
      end,
      mode = { "n", "v" },
      desc = "Format Injected Langs",
    },
  },
  opts = function()
    local opts = {
      format = {
        timeout_ms = 3000,
        lsp_fallback = true,
        async = false,
        quiet = false,
      },
      formatters_by_ft = {
        css = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        scss = { "prettier" },
        sh = { "beautysh" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
        zsh = { "shfmt" },
      },
      formatters = {
        prettier = {
          exe = "prettier",
          args = function()
            local args = { "--stdin-filepath", "$FILENAME" }
            require("conform.formatters.prettier").args = function(_, ctx)
              local prettier_roots = {
                ".prettierrc",
                ".prettierrc.json",
                "prettier.config.js",
                "prettier.config.cjs",
              }

              local localPrettierConfig = vim.fs.find(prettier_roots, {
                upward = true,
                path = ctx.dirname,
                type = "file",
              })[1]

              local globalPrettierConfig = vim.fs.find(prettier_roots, {
                path = vim.fn.stdpath("config"),
                type = "file",
              })[1]

              local disableGlobalPrettierConfig =
                os.getenv("DISABLE_GLOBAL_PRETTIER_CONFIG")

              -- Project config takes precedence over global config
              if localPrettierConfig then
                vim.list_extend(args, { "--config", localPrettierConfig })
              elseif
                globalPrettierConfig and not disableGlobalPrettierConfig
              then
                vim.list_extend(args, { "--config", globalPrettierConfig })
              end

              local hasTailwindPrettierPlugin =
                vim.fs.find("node_modules/prettier-plugin-tailwindcss", {
                  upward = true,
                  path = ctx.dirname,
                  type = "directory",
                })[1]

              if hasTailwindPrettierPlugin then
                vim.list_extend(
                  args,
                  { "--plugin", "prettier-plugin-tailwindcss" }
                )
              end
              return args
              -- print(vim.inspect(args))
            end
            return args
          end,
        },
        beautysh = {
          prepend_args = {
            "--indent-size 2",
            "--force-function-style fnpar",
          },
        },
      },
    }
    return opts
  end,
}
