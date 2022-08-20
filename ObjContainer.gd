extends TabContainer

signal update_content
const ObjectiveContent = preload("res://ObjectiveContent.tscn")
const number_of_objectives = 2
signal final_objective_reached

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0, number_of_objectives):
		var obj = Tabs.new()
		var objContent = ObjectiveContent.instance()
		obj.add_child(objContent)
		add_child(obj)
		set_tab_title(i, "Obj" + str(i + 1))
		set_tab_disabled(i, true)
		
	for i in range(1, number_of_objectives):
		set_tab_disabled(i, true)
		set_tab_title(i, "???")
	
	set_tab_disabled(0, false)
	

# this container acts as manager for its child tabs
# we intercept the enemy death signal in here so that we can reduce having the enemy connect
# to every tab
# other possibilities involve moving all of the objectivecontents code into this class
# which would make it so we just manage in this class only
func on_enemy_death(_xp, _pos):
	emit_signal("update_content", "kill")

func on_item_picked_up(item):
	emit_signal("update_content", item.item_name)
	
func on_objective_finished(_reward):
	set_tab_disabled(current_tab, true)
	set_tab_title(current_tab, "Done")
	if(current_tab < number_of_objectives):
		current_tab += 1
		set_tab_disabled(current_tab, false)
		if current_tab == number_of_objectives - 1:
			#final tab aka boss
			set_tab_title(current_tab, 'Boss')
			emit_signal("final_objective_reached")
		set_tab_title(current_tab, "Obj" + str(current_tab + 1))


