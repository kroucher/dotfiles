local wezterm = require("wezterm")
local act = wezterm.action
local session_manager = require("wezterm-session-manager/session-manager")

local config = {
  font = wezterm.font("GeistMono Nerd Font Mono"),
  font_size = 13,
  line_height = 1.1,
  color_scheme = "nightfox",
  leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1500 },
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  native_macos_fullscreen_mode = false,
  front_end = "OpenGL",
  unicode_version = 14,
  default_prog = { "zsh" },
  window_background_opacity = 0.90,
  window_decorations = "RESIZE",
  window_padding = {
    left = 20,
    right = 20,
    top = 20,
    bottom = 20,
  },
  -- background = {
  --   {
  --     source = { File = wezterm.config_dir .. "/gaara.jpg" },
  --     attachment = "Fixed",
  --     height = "100%",
  --     width = "100%",
  --     -- opacity = 0.90,
  --     hsb = { brightness = 0.03 },
  --   },
  -- },

  inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.6,
  },
  colors = {
    tab_bar = {
      -- The color of the strip that goes along the top of the window
      -- (does not apply when fancy tab bar is in use)
      background = "rgb(30, 39, 57 / 10%)",

      -- The active tab is the one that has focus in the window
      active_tab = {
        -- The color of the background area for the tab
        bg_color = "rgb(109, 112, 133 / 10%)",
        -- The color of the text for the tab
        fg_color = "rgb(239, 241, 245)",

        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = "Bold",

        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = "None",

        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = "rgb(109, 112, 133 / 10%)",
        fg_color = "#808080",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
      },

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = "#1b1032",
        fg_color = "#808080",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over the new tab button
      new_tab_hover = {
        bg_color = "rgb(109, 112, 133 / 10%)",
        fg_color = "#909090",
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab_hover`.
      },
    },
  },
}
config.keys = {
  -- Window splits
  {
    key = "%",
    mods = "LEADER|SHIFT",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = '"',
    mods = "LEADER|SHIFT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  -- Move between splits
  {
    key = "h",
    mods = "CTRL",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "j",
    mods = "CTRL",
    action = act.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "CTRL",
    action = act.ActivatePaneDirection("Up"),
  },
  {
    key = "l",
    mods = "CTRL",
    action = act.ActivatePaneDirection("Right"),
  },
  -- Adjust split size (horizontal)
  {
    key = "h",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Left", 1 }),
  },
  {
    key = "l",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Right", 1 }),
  },
  -- Adjust split size (vertical)
  {
    key = "j",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Down", 1 }),
  },
  {
    key = "k",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Up", 1 }),
  },
  -- Toggle Zoom
  {
    key = "z",
    mods = "LEADER",
    action = act.TogglePaneZoomState,
  },

  -- Tabs

  -- Create Tab
  {
    key = "c",
    mods = "LEADER",
    action = act({ SpawnTab = "CurrentPaneDomain" }),
  },

  { key = "L", mods = "LEADER", action = "ShowLauncher" },
  { key = "S", mods = "LEADER", action = "QuickSelect" },

  -- Close tab
  {
    key = "c",
    mods = "LEADER|SHIFT",
    action = act({ CloseCurrentTab = { confirm = true } }),
  },

  -- Switch to tab by number
  {
    key = "1",
    mods = "LEADER",
    action = act({ ActivateTab = 0 }),
  },
  {
    key = "2",
    mods = "LEADER",
    action = act({ ActivateTab = 1 }),
  },
  {
    key = "3",
    mods = "LEADER",
    action = act({ ActivateTab = 2 }),
  },
  {
    key = "4",
    mods = "LEADER",
    action = act({ ActivateTab = 3 }),
  },
  {
    key = "5",
    mods = "LEADER",
    action = act({ ActivateTab = 4 }),
  },
  {
    key = "6",
    mods = "LEADER",
    action = act({ ActivateTab = 5 }),
  },
  {
    key = "7",
    mods = "LEADER",
    action = act({ ActivateTab = 6 }),
  },
  {
    key = "8",
    mods = "LEADER",
    action = act({ ActivateTab = 7 }),
  },
  {
    key = "9",
    mods = "LEADER",
    action = act({ ActivateTab = 8 }),
  },
  {
    key = "0",
    mods = "LEADER",
    action = act({ ActivateTab = 9 }),
  },

  -- Save and load sessions
  {
    key = "S",
    mods = "LEADER",
    action = wezterm.action({ EmitEvent = "save_session" }),
  },
  {
    key = "L",
    mods = "LEADER",
    action = wezterm.action({ EmitEvent = "load_session" }),
  },
  {
    key = "R",
    mods = "LEADER",
    action = wezterm.action({ EmitEvent = "restore_session" }),
  },
  -- rename tab
  {
    key = "e",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, _, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },

  -- rotate panes
  {
    key = "b",
    mods = "LEADER",
    action = act.RotatePanes("CounterClockwise"),
  },
  { key = "n", mods = "LEADER", action = act.RotatePanes("Clockwise") },
}

wezterm.on("save_session", function(window)
  session_manager.save_state(window)
end)
wezterm.on("load_session", function(window)
  session_manager.load_state(window)
end)
wezterm.on("restore_session", function(window)
  session_manager.restore_state(window)
end)

-- Decide whether cmd represents a default startup invocation
function IsDefaultStartup(cmd)
  if wezterm.target_triple:match("windows") then
    -- On Windows, use WSL2 as the default domain
    return true
  end
  if not cmd then
    -- we were started with `wezterm` or `wezterm start` with
    -- no other arguments
    return true
  end
  if cmd.domain == "DefaultDomain" and not cmd.args then
    -- Launched via `wezterm start --cwd something`
    return true
  end
  -- we were launched some other way
  return false
end

-- wezterm.on("gui-startup", function(cmd)
--   -- Check if the environment is Windows and set Windows as the default domain
--   if wezterm.target_triple:match("windows") then
--     local wsl_domain = mux.get_domain("WSL:Ubuntu-20.04")
--     mux.set_default_domain(wsl_domain)
--   else
--     -- For non-Windows environments, set the default to Unix
--     local unix_domain = mux.get_domain("unix")
--     mux.set_default_domain(unix_domain)
--   end
--
--   -- Spawn a single window with the default domain
--   if not cmd or cmd == {} then
--     local tab, pane, window = mux.spawn_window({})
--     window:gui_window():maximize()
--   end
-- end)
-- The filled in variant of the < symbol
-- local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
--
-- -- The filled in variant of the > symbol
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
--
-- local tab_title = function(tab_info)
--   local title = tab_info.tab_title
--   if title and #title > 0 then
--     return title
--   end
--   return tab_info.active_pane.title
-- end
-- wezterm.on(
--   "format-tab-title",
--   function(tab, tabs, panes, config, hover, max_width)
--     local edge_background = "#0b0022"
--     local background = "black"
--     local foreground = "#808080"
--
--     if tab.is_active then
--       background = "#2b2042"
--       foreground = "#c0c0c0"
--     elseif hover then
--       background = "#3b3052"
--       foreground = "#909090"
--     end
--
--     local edge_foreground = background
--
--     local title = tab_title(tab)
--
--     -- ensure that the titles fit in the available space,
--     -- and that we have room for the edges.
--     title = wezterm.truncate_right(title, max_width - 2)
--
--     return {
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_LEFT_ARROW },
--       { Background = { Color = background } },
--       { Foreground = { Color = foreground } },
--       { Text = title },
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_RIGHT_ARROW },
--     }
--   end
-- )
-- wezterm.on(
--   "format-tab-title",
--   function(tab, tabs, panes, config, hover, max_width) -- Not sure if it will slow down the performance, at least so far it's good
--     -- Is there a better way to get the tab or window cols ?
--     local mux_window = wezterm.mux.get_window(tab.window_id)
--     local mux_tab = mux_window:active_tab()
--     local mux_tab_cols = mux_tab:get_size().cols
--
--     -- Calculate active/inactive tab cols
--     -- In general, active tab cols > inactive tab cols
--     local tab_count = #tabs
--     local inactive_tab_cols = math.floor(mux_tab_cols / tab_count)
--     local active_tab_cols = mux_tab_cols - (tab_count - 1) * inactive_tab_cols
--
--     local title = tab_title(tab)
--     title = " " .. title .. " "
--     local title_cols = wezterm.column_width(title)
--     local icon = " ⦿"
--     local emptycircle = " ○"
--     local icon_cols = wezterm.column_width(icon)
--
--     title = wezterm.truncate_right(title, max_width - 2)
--     -- Divide into 3 areas and center the title
--     if tab.is_active then
--       local rest_cols = math.max(active_tab_cols - title_cols, 0)
--       local right_cols = math.ceil(rest_cols / 2)
--       return {
--         -- left
--         -- { Foreground = { Color = "white" } },
--         { Text = wezterm.pad_right(icon, 1) },
--         -- center
--         { Foreground = { Color = "white" } },
--         { Attribute = { Italic = true } },
--         { Text = title },
--         -- right
--         { Text = wezterm.pad_right("", right_cols) },
--       }
--     else
--       local rest_cols = math.max(inactive_tab_cols - title_cols, 0)
--       local right_cols = math.ceil(rest_cols / 2)
--       return {
--         { Text = wezterm.pad_right(emptycircle, 1) },
--         -- center
--         { Attribute = { Italic = true } },
--         { Text = title },
--         -- right
--         { Text = wezterm.pad_right("", 6) },
--       }
--     end
--   end
-- )

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make javascript file imports clickable
-- ( import { something } from "~/path/to/file" )
-- should open the file in the current pane, with ~ expanded to the project root
-- format should follow the string template method, where $1 is the file path
-- format is not a function, but a string template
table.insert(config.hyperlink_rules, {
  regex = [[["]?import\s+(?:[\w\d]+)?\s+from\s+["]?([^\s]+)["]?]],
  format = "$1",
})

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = "https://www.github.com/$1/$3",
})

return config
