extends TabContainer

signal update_content
const ObjectiveContent = preload("res://ObjectiveContent.tscn")
const number_of_objectives = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, number_of_objectives):
		var obj = Tabs.new()
		var objContent = ObjectiveContent.instance()
		obj.add_child(objContent)
		add_child(obj)
		set_tab_title(i, "Obj" + str(i + 1))
		set_tab_disabled(i, true)
		
	for i in range(1, get_tab_count()):
		set_tab_disabled(i, true)
		set_tab_title(i, "???")
	
	set_tab_disabled(0, false)
	

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
		set_tab_title(current_tab, "Obj" + str(current_tab + 1))


