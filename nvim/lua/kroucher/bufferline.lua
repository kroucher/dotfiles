local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then return end

bufferline.setup({
  options = {
    style_preset = { bufferline.style_preset.minimal },
    mode = "buffers",
    numbers = "none",
    themable = true,
    close_command = "bdelete! %d",
    right_mouse_command = "bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    buffer_close_icon = "",
    modified_icon = "",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 30,
    max_prefix_length = 30,
    tab_size = 21,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = true,
    offsets = {
      {
        filetype = "NvimTree",
        text = function()
          return vim.fn.getcwd()
        end,
        highlight = "Directory",
        padding = 1,
        text_align = "left",
      },
    },
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "slant",
    enforce_regular_tabs = true,
    always_show_bufferline = true,
  },
  highlights = {
    separator = {
      fg = "#252b37",
      bg = "#21222b",
    },
    separator_selected = {
      fg = "#252b37",
      bg = "#1a1b22",
    },
    background = {
      fg = "#a6accd",
      bg = "#21222b",
    },
    buffer_selected = {
      fg = "#FFFFFF",
      bg = "#1a1b22",
    },
    fill = {
      bg = "#252b37",
    },
  },
})
