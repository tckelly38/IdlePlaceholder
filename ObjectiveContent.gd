extends Position2D

var current_objective = ""
var objectives_target_goal_list = ["10", "5", "20", "100", "50"]
var objectives = ["Kill %s Slimes", "Pickup %s Gold"]


var target_goal = 10
var current_value = 0
var current_reward = 10
onready var objective_label = get_node("Objective Label")
onready var objective_progress_bar = get_node("Objective Progress Bar")
onready var tween = get_node("Tween")

signal objective_finished
signal objective_finished_start
var processing_objective_achieved = false
onready var obj_container = get_parent().get_parent()

# builds a random objective by picking random parts from the static lists
func pick_objective():
	randomize()
	current_objective = objectives[randi() % objectives.size()]
	target_goal = int(objectives_target_goal_list[randi() % objectives_target_goal_list.size()])
	current_objective = current_objective % String(target_goal)
	current_value = 0

				
# Called when the node enters the scene tree for the first time.
# connect to player to notify when event obj finished
# connect to parent obj container which manages the multiple obj content
func _ready():
	var error_code = connect("objective_finished", Player, "on_objective_finished")
	if error_code:
		print("Error: unable to connect to Player.on_objective_finished from ObjectiveContainer")
	
	error_code = obj_container.connect("update_content", self, "on_update_content")
	if error_code:
		print("Error: Unable to connect parent container to objectivecontent")
		
	error_code = connect("objective_finished", obj_container, "on_objective_finished")
	if error_code:
		print("Error: unable to connect to objcontainer.on_objective_finished from ObjectiveContainer")
	
	error_code = connect("objective_finished", get_parent().get_parent().get_parent(), "on_objective_finished")
	if error_code:
		print("Error: unable to connect to objcontainer.on_objective_finished from ObjectiveContainer")
		
	error_code = connect("objective_finished_start", get_parent().get_parent().get_parent(), "on_objective_finished_start")
	if error_code:
		print("Error: unable to connect to objcontainer.on_objective_finished_start from ObjectiveContainer")
	
	pick_objective()
	objective_label.text = current_objective
	objective_progress_bar.max_value = target_goal
	objective_progress_bar.value = current_value
		
# when goal achieved animate the text and update to show Complete message
# TODO: future work will involve doing some other stuff on completion of a task
func goal_achieved():
	# show ui
	processing_objective_achieved = true
	emit_signal("objective_finished_start")
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
	emit_signal("objective_finished", current_reward)

	#update ui elements and get new objective
	current_value = 0
	
# TODO: we will want to make this more dynamic in the future
# to handle obj dealing with things like kill, clicks, etc.
func update_values():
	current_value += 1
	objective_progress_bar.visible = true
	objective_label.text = current_objective
	objective_progress_bar.max_value = target_goal
	objective_progress_bar.value = current_value
	
# we get notified by the Objective Manager that we need to update our values
func on_update_content(type): 
	if !get_parent().visible:
		return
		
	if !type in current_objective.to_lower():
		return
		
	# need to wait until we can get another objective displayed
	if processing_objective_achieved:
		return
		
#	if(receive_signal != "on_enemy_death"):
#		return
	
	update_values()
	
	if current_value >= target_goal:
		goal_achieved()
