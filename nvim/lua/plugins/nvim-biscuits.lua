return {
  {
    "code-biscuits/nvim-biscuits",
    config = function()
      require("nvim-biscuits").setup({
        cursor_line_only = true,
      })
    end,
  },
}
