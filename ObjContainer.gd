extends TabContainer

signal update_content

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(1, get_tab_count()):
		set_tab_disabled(i, true)
#		var content : Position2D = child.get_child(0)
#		if content.has_method("on_update_content"):
#			connect("update_content", content, "on_update_content")

#	for child in get_children():
#		var content : Position2D = child.get_child(0)
#		if content.has_method("on_update_content"):
#			connect("update_content", content, "on_update_content")
#	connect("enemy_death", ("/root/FarmArea1/ObjContainer/Obj 1/ObjectiveContent"), "on_enemy_death")
#	connect("enemy_death", get_node("/root/FarmArea1/ObjContainer/Obj 2/ObjectiveContent"), "on_enemy_death")
#	connect("enemy_death", get_node("/root/FarmArea1/ObjContainer/Obj 3/ObjectiveContent"), "on_enemy_death")

# this container acts as manager for its child tabs
# we intercept the enemy death signal in here so that we can reduce having the enemy connect
# to every tab
# other possibilities involve moving all of the objectivecontents code into this class
# which would make it so we just manage in this class only
func on_enemy_death(_xp):
	emit_signal("update_content")  
	
func on_objective_finished(_reward):
	set_tab_disabled(current_tab, true)
	if(current_tab < get_tab_count()):
		current_tab += 1
		set_tab_disabled(current_tab, false)


