extends Control
var need_load = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.visible = false
	$"Farm/Farm Area 1".grab_focus()
	if need_load:
		load_game()

func _on_Farm_Area_1_pressed():
	get_tree().change_scene("res://FarmArea1.tscn")


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
	need_load = false
