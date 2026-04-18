-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Key bindings for macOS word and line navigation
config.keys = {
    -- Option + Left Arrow: Move to beginning of word
    {
        key = 'LeftArrow',
        mods = 'OPT',
        action = act.SendString '\x1bb' -- Alt+b (backward word)
    }, -- Option + Right Arrow: Move to end of word
    {
        key = 'RightArrow',
        mods = 'OPT',
        action = act.SendString '\x1bf' -- Alt+f (forward word)
    }, -- Cmd + Left Arrow: Move to beginning of line
    {
        key = 'LeftArrow',
        mods = 'CMD',
        action = act.SendString '\x01' -- Ctrl+a (beginning of line)
    }, -- Cmd + Right Arrow: Move to end of line
    {
        key = 'RightArrow',
        mods = 'CMD',
        action = act.SendString '\x05' -- Ctrl+e (end of line)
    }, -- Option + Backspace: Delete word backward
    {
        key = 'Backspace',
        mods = 'OPT',
        action = act.SendString '\x17' -- Ctrl+w
    }, -- Option + Delete: Delete word forward
    {
        key = 'Delete',
        mods = 'OPT',
        action = act.SendString '\x1bd' -- Alt+d
    }, -- Cmd + Backspace: Delete everything from cursor to beginning of line
    {
        key = 'Backspace',
        mods = 'CMD',
        action = act.SendString '\x15' -- Ctrl+u (delete to beginning of line)
    }, -- Cmd + Z: Undo
    {
        key = 'z',
        mods = 'CMD',
        action = act.SendString '\x1f' -- Ctrl+_ (standard terminal undo)
    }, -- Cmd + Shift + Z: Redo
    {
        key = 'Z',
        mods = 'CMD|SHIFT',
        action = act.SendString '\x18\x1f' -- Ctrl+X Ctrl+_ (redo sequence)
    }, -- Cmd + '+' to Increase font size
    {key = '+', mods = 'CMD', action = wezterm.action.IncreaseFontSize},
    -- Cmd + '-' to Decrease font size
    {key = '-', mods = 'CMD', action = wezterm.action.DecreaseFontSize},
    -- Switch to tab on the left
    {key = 'LeftArrow', mods = 'CMD|OPT', action = act.ActivateTabRelative(-1)},
    -- Switch to tab on the right
    {key = 'RightArrow', mods = 'CMD|OPT', action = act.ActivateTabRelative(1)},
    -- Move tab one position to the left
    {
        key = 'LeftArrow',
        mods = 'CMD|SHIFT',
        action = wezterm.action_callback(function(win, pane)
            local tabs = win:mux_window():tabs_with_info()
            for _, t in ipairs(tabs) do
                if t.is_active then
                    if t.index > 0 then
                        win:perform_action(act.MoveTab(t.index - 1), pane)
                    end
                    break
                end
            end
        end)
    }, -- Move tab one position to the right
    {
        key = 'RightArrow',
        mods = 'CMD|SHIFT',
        action = wezterm.action_callback(function(win, pane)
            local tabs = win:mux_window():tabs_with_info()
            for _, t in ipairs(tabs) do
                if t.is_active then
                    if t.index < #tabs - 1 then
                        win:perform_action(act.MoveTab(t.index + 1), pane)
                    end
                    break
                end
            end
        end)
    }
}

-- Font size
config.font_size = 13

-- Set initial geometry
config.initial_cols = 110
config.initial_rows = 30
config.window_decorations = "NONE|RESIZE|INTEGRATED_BUTTONS"

-- Opacity
config.window_background_opacity = 0.75

-- Split pane contrast
config.colors = {
    split = '#ffffff',
}

config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.7,
}

-- Start screen centered with specific character dimensions
wezterm.on("gui-startup", function(cmd)
    local screen = wezterm.gui.screens().main
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})

    local gui_window = window:gui_window()

    local width = gui_window:get_dimensions().pixel_width
    local height = gui_window:get_dimensions().pixel_height

    local x = (screen.width - width) * 0.75
    local y = (screen.height - height) * 0.65

    gui_window:set_position(x, y)
end)

-- Finally, return the configuration to wezterm:
return config
