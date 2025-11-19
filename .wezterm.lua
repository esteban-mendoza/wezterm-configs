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
		action = act.SendString '\x1bb',  -- Alt+b (backward word)
	},
	-- Option + Right Arrow: Move to end of word
	{
		key = 'RightArrow',
		mods = 'OPT',
		action = act.SendString '\x1bf',  -- Alt+f (forward word)
	},
	-- Cmd + Left Arrow: Move to beginning of line
	{
		key = 'LeftArrow',
		mods = 'CMD',
		action = act.SendString '\x01',  -- Ctrl+a (beginning of line)
	},
	-- Cmd + Right Arrow: Move to end of line
	{
		key = 'RightArrow',
		mods = 'CMD',
		action = act.SendString '\x05',  -- Ctrl+e (end of line)
	},
	-- Option + Backspace: Delete word backward
    {
    	key = 'Backspace',
    	mods = 'OPT',
    	action = act.SendString '\x17',  -- Ctrl+w
    },
    -- Option + Delete: Delete word forward
    {
    	key = 'Delete',
    	mods = 'OPT',
    	action = act.SendString '\x1bd',  -- Alt+d
    },
    -- Cmd + Backspace: Delete everything from cursor to beginning of line
	{
		key = 'Backspace',
		mods = 'CMD',
		action = act.SendString '\x15',  -- Ctrl+u (delete to beginning of line)
	},
    -- Cmd + Z: Undo
    {
        key = 'z',
        mods = 'CMD',
        action = act.SendString '\x1f', -- Ctrl+_ (standard terminal undo)
    },
    -- Cmd + Shift + Z: Redo
    {
        key = 'Z',
        mods = 'CMD|SHIFT',
        action = act.SendString '\x18\x1f', -- Ctrl+X Ctrl+_ (redo sequence)
    }
}

-- or, changing the font size and color scheme.
config.font_size = 13
--config.color_scheme = 'AdventureTime'

-- Set initial geometry
config.initial_cols = 110
config.initial_rows = 30
config.window_decorations = "NONE|RESIZE"

-- Opacity
config.window_background_opacity = 0.65

-- Start screen centered with specific character dimensions
wezterm.on("gui-startup", function(cmd)
	local screen = wezterm.gui.screens().main
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})

	-- Get the GUI window
	local gui_window = window:gui_window()

	-- Let the window render with the initial_cols and initial_rows first
	-- Then get its actual pixel size to calculate center position
	--wezterm.sleep_ms(0)

	-- Get the actual window dimensions after it's created with 120x24 chars
	local width = gui_window:get_dimensions().pixel_width
	local height = gui_window:get_dimensions().pixel_height

	-- Calculate center position
	local x = (screen.width - width) * 0.75
	local y = (screen.height - height) * 0.65

	-- Set the position to center the window
	gui_window:set_position(x, y)
end)

-- Finally, return the configuration to wezterm:
return config
