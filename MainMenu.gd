extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# hack to account for taskbar size
	#OS.window_borderless = true
	OS.set_window_maximized(true)
	var taskbar_height = OS.get_screen_size().y - OS.get_real_window_size().y
	var full_position = OS.get_window_position()
	var full_size = OS.get_real_window_size()
	OS.set_window_maximized(false)
#	OS.window_borderless = false
	OS.set_window_size(Vector2(full_size.x, full_size.y / 4))
	
	OS.set_window_position(Vector2(full_position.x, full_size.y - OS.get_window_size().y - taskbar_height + full_position.y * 2 + 1))# - taskbar_height))
	
	VisualServer.set_default_clear_color(Color("20506a"))
	get_node("Farm/Farm Area 1").get_font("font", "sci-fi-theme").size = 20
	Player.visible = false
	# TODO: for now we make sure player is alive
	Player.current_health = Player.max_health
	Player.is_dead = false
	$"Farm/Farm Area 1".grab_focus()

func _on_Farm_Area_1_pressed():
	var error_code = get_tree().change_scene("res://FarmArea1.tscn")
	if error_code:
		print("Error: no farm area1 exists")

func _on_Save_pressed():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if node.filename.empty():
			print("persistence node '%s' is not an instanced scene, skipped" % node.name)
			continue
		
		if !node.has_method("save"):
			print("persistence node '%s' is missing a save() function, skipped" % node.name)
			continue
		
		
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		print ("no save to load")
		return
	
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		
		for i in node_data.keys():
			Player.set(i, node_data[i])
	save_game.close()
	
func _on_Load_pressed():
	load_game()
