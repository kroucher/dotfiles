local barbar_status, barbar = pcall(require, "barbar")
if not barbar_status then
  return
end

barbar.setup({
  sidebar_filetypes = {
    NvimTree = true,
  },
  icons = {
    button = "×",
    preset = "default",
  },
  maximum_padding = 6,
  minimum_padding = 4,
})
