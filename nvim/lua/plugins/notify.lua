return {
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
      ---@diagnostic disable-next-line: missing-fields
      vim.notify.setup({
        render = "compact",
        background_colour = "#000000",
        stages = "fade_in_slide_out",
        timeout = 3000,
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      })
    end,
  },
}
