extends TabContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal update_content

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	for child in get_children():
#		var content : Position2D = child.get_child(0)
#		if content.has_method("on_update_content"):
#			connect("update_content", content, "on_update_content")
#	connect("enemy_death", ("/root/FarmArea1/ObjContainer/Obj 1/ObjectiveContent"), "on_enemy_death")
#	connect("enemy_death", get_node("/root/FarmArea1/ObjContainer/Obj 2/ObjectiveContent"), "on_enemy_death")
#	connect("enemy_death", get_node("/root/FarmArea1/ObjContainer/Obj 3/ObjectiveContent"), "on_enemy_death")


func on_enemy_death(xp):
	emit_signal("update_content")  
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
