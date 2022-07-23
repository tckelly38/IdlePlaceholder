extends ProgressBar
signal xp_bar_ready
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("xp_bar_ready", Player, "on_xp_bar_ready")
	emit_signal("xp_bar_ready", true)
	pass # Replace with function body.
	
func _on_update_xp_bar(val, max_val):
	value = val
	if(max_value <= value):
		min_value = value
	max_value = max_val

	
	

func _exit_tree():
	emit_signal("xp_bar_ready", false)
