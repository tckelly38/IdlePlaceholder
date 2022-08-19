extends Node2D
# this scene should hold the logic we care about at launch of app
func _ready():
	OS.set_window_maximized(true)
	var taskbar_height = OS.get_screen_size().y - OS.get_real_window_size().y
	var full_position = OS.get_window_position()
	var full_size = OS.get_real_window_size()
	OS.set_window_maximized(false)
#	OS.window_borderless = false
	OS.set_window_size(Vector2(full_size.x - 16, full_size.y / 4))
	
	OS.set_window_position(Vector2(full_position.x, full_size.y - OS.get_window_size().y - taskbar_height + full_position.y * 2 + 1))
	pass # Replace with function body.
