return {
  "piersolenski/wtf.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  opts = {
    popup_type = "popup",
    openai_api_key = "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",
    openai_model_id = "gpt-4",
    context = true,
    language = "english",
    search_engine = "github",
  },
  keys = {
    {
      "gw",
      mode = { "n", "x" },
      function()
        require("wtf").ai()
      end,
      desc = "Debug diagnostic with AI",
    },
    {
      mode = { "n" },
      "gW",
      function()
        require("wtf").search()
      end,
      desc = "Search diagnostic with Google",
    },
  },
}
