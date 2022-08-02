extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("xp_bar_ready", Player, "on_xp_bar_ready")
	#emit_signal("xp_bar_ready", true)
	var error_code = Player.connect("experience_gained", self, "_on_update_xp_bar")
	if error_code:
		print("Error: error connecting to experience_gained")
	
	_on_update_xp_bar(Player.experience_total, Player.experience_requred)

	
func _on_update_xp_bar(val, max_val):
	value = val
	if(max_value <= value):
		min_value = value
	max_value = max_val

func _exit_tree():
	#emit_signal("xp_bar_ready", false)
	pass
