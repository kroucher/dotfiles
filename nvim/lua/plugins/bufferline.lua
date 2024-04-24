return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = function()
    local gray = "#cdcecf"
    local red = "#c94f6d"
    local yellow = "#dbc074"
    local cyan = "#63cdcf"
    local links = "#719cd6"
    local opts = {
      options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        numbers = "none",
        color_icons = false,
        separator_style = "",
        indicator = {
          --icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = "none",
        },
        modified_icon = "●",
        left_trunc_marker = "",
        right_trunc_marker = "",
        show_buffer_close_icons = false,
      -- stylua: ignore
      close_command = function(n) require("mini.bufremove").delete(n, false) end,
      -- stylua: ignore
      right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },

      highlights = {
        background = {
          fg = gray,
        },
        buffer_selected = {
          fg = links,
        },
        buffer_visible = {
          fg = gray,
        },
        separator_selected = {
          fg = "#1e1e2e",
        },
        separator = {
          bg = "#1e1e2e",
          fg = "#1e1e2e",
        },
        diagnostic = {},
        hint = {
          fg = cyan,
          sp = cyan,
        },
        hint_selected = {
          fg = cyan,
          sp = cyan,
        },
        warning = {
          fg = yellow,
          sp = yellow,
        },

        warning_selected = {
          fg = yellow,
          sp = yellow,
        },
        error = {
          fg = red,
          sp = red,
        },
        error_selected = {
          fg = red,
          sp = red,
        },
      },
    }
    return opts
  end,
}
