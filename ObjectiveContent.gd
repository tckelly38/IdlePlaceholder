extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_objective = ""
var objectives_prefix_list = ["Kill"]
var objectives_target_goal_list = ["10", "5", "20", "100", "50"]
var objectives_suffix_list = ["Slimes"]
var target_goal = 10
var current_value = 0
var current_reward = 10
onready var objective_label = get_node("Objective Label")
onready var objective_progress_bar = get_node("Objective Progress Bar")
signal objective_finished
onready var tween = get_node("Tween")
var processing_objective_achieved = false
var receive_signal = "on_enemy_death"

func pick_objective():
	randomize()
	var obj_prefix = objectives_prefix_list[randi() % objectives_prefix_list.size()]
	target_goal = int(objectives_target_goal_list[randi() % objectives_target_goal_list.size()])
	var obj_suffix = objectives_suffix_list[randi() % objectives_suffix_list.size()]
	current_objective = obj_prefix + " " + str(target_goal) + " " + obj_suffix
	current_value = 0
	match obj_prefix:
		"Kill":
			receive_signal = "on_enemy_death"
	
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("objective_finished", Player, "on_objective_finished")

	pick_objective()
	objective_label.text = current_objective
	objective_progress_bar.max_value = target_goal
	objective_progress_bar.value = current_value

		
func goal_achieved():
	# show ui
	processing_objective_achieved = true
	emit_signal("objective_finished", current_reward)
	tween.interpolate_property(self, 'scale', Vector2(1, 1), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	objective_label.text = "Complete!"
	objective_progress_bar.visible = false
	tween.interpolate_property(self, 'scale',Vector2(0, 0), Vector2(1, 1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	
	#lets wait 2 seconds before showing new obj
	tween.interpolate_property(self, 'scale',Vector2(1, 1), Vector2(1, 1), 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)

	yield(tween, "tween_completed")

	
	#update ui elements and get new objective
	current_value = 0
	
	
	# emit signal to player to notify
func update_values():
	current_value += 1
	objective_progress_bar.visible = true
	objective_label.text = current_objective
	objective_progress_bar.max_value = target_goal
	objective_progress_bar.value = current_value
	
func on_enemy_death(xp):
	# need to wait until we can get another objective displayed
	if processing_objective_achieved:
		return
	
	if(receive_signal != "on_enemy_death"):
		return
	
	update_values()
	
	if current_value >= target_goal:
		goal_achieved()
	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
