-- Distance to move the image when using panning motions
local move_distance = 128

swayimg.decoration = false
swayimg.overlay = true
swayimg.mode = "viewer"

-- BUG: Panning does not work on Niri
-- See <https://github.com/artemsen/swayimg/issues/435>
swayimg.dnd_button = "MouseLeft"

swayimg.imagelist.adjacent = true

swayimg.on_window_resize(function()
	if swayimg.mode == "viewer" then swayimg.viewer.reset() end
end)

swayimg.viewer.default_scale = "keep"
swayimg.viewer.on_key("f", function() swayimg.viewer.set_fix_scale("fit") end)
swayimg.viewer.on_key("r", function() swayimg.viewer.open("random") end)
swayimg.viewer.on_key("q", function() swayimg.exit() end)
swayimg.viewer.on_key("Escape", function() swayimg.viewer.set_fix_scale("optimal") end)
swayimg.viewer.on_key("Ctrl-h", function()
	local pos = swayimg.viewer.get_position()
	swayimg.viewer.set_abs_position(pos.x + move_distance, pos.y)
end)
swayimg.viewer.on_key("Ctrl-j", function()
	local pos = swayimg.viewer.get_position()
	swayimg.viewer.set_abs_position(pos.x, pos.y - move_distance)
end)
swayimg.viewer.on_key("Ctrl-k", function()
	local pos = swayimg.viewer.get_position()
	swayimg.viewer.set_abs_position(pos.x, pos.y + move_distance)
end)
swayimg.viewer.on_key("Ctrl-l", function()
	local pos = swayimg.viewer.get_position()
	swayimg.viewer.set_abs_position(pos.x - move_distance, pos.y)
end)
swayimg.viewer.on_key("h", function() swayimg.viewer.open("prev") end)
swayimg.viewer.on_key("j", function() swayimg.viewer.open("next") end)
swayimg.viewer.on_key("k", function() swayimg.viewer.open("prev") end)
swayimg.viewer.on_key("l", function() swayimg.viewer.open("next") end)
swayimg.viewer.on_key("Ctrl+Equal", function()
	local scale = swayimg.viewer.scale
	scale = scale + scale / 10
	swayimg.viewer.set_abs_scale(scale)
end)
swayimg.viewer.on_key("Ctrl+Minus", function()
	local scale = swayimg.viewer.scale
	scale = scale - scale / 10
	swayimg.viewer.set_abs_scale(scale)
end)
