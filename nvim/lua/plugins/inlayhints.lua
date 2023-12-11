return {
  { "simrat39/inlay-hints.nvim", config = {
    eol = {
      right_align = true,
    },
  } },

  {
    "simrat39/rust-tools.nvim",
    config = {
      tools = {
        on_initialized = function()
          require("inlay-hints").set_all()
        end,
        inlay_hints = {
          auto = false,
        },
      },
      server = {
        on_attach = function(c, b)
          require("inlay-hints").on_attach(c, b)
        end,
      },
    },
  },
}
