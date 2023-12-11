return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "marilari88/neotest-vitest",
      "rouge8/neotest-rust",
    },
    keys = {
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last Test",
      },
      {
        "<leader>tL",
        function()
          require("neotest").run.run_last({ strategy = "dap" })
        end,
        desc = "Debug Last Test",
      },
      {
        "<leader>tw",
        "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
        desc = "Run Watch",
      },
    },
    opts = {
      adaptors = {
        ["neotest-vitest"] = {},
        ["neotest-rust"] = {},
      },
    },
  },
}
