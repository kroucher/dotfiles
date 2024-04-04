return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      sections = {
        lualine_c = {
          {
            function()
              return "  "
            end,
            color = "green",
            on_click = require("mpv").toggle_player,
          },
          "g:mpv_title",
        },
      },
    })
  end,
}
