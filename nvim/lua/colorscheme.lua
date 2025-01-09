local colorschemes = {
  "solarized",
  "kanagawa",
  "cyberdream",
  "nightfox",
  "night-owl",
  "poimandres",
  "catppuccin",
}

local current_index = 1

local function cycle_colorscheme()
  current_index = current_index + 1
  if current_index > #colorschemes then
    current_index = 1
  end
  vim.cmd("colorscheme " .. colorschemes[current_index])
end

return {
  cycle_colorscheme = cycle_colorscheme,
}
