extends Position2D
signal health_bar_ready

onready var tween = get_node("Tween")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bar = get_node("HealthBar")
var is_showing = false
var starting_position = position #Vector2(get_viewport().size.x / 2, 0 - bar.rect_size.y)
var final_position = Vector2()
var hiding_position = Vector2()
var is_animating = false
var time_to_wait = 2

onready var timer = get_node("FullHealthTimer")
# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("health_bar_ready", Player, "on_health_bar_ready")
	var error_code = Player.connect("update_health", self, "on_health_bar_update")
	if error_code:
		print("Error: error connecting to player to healthbar")
	emit_signal("health_bar_ready", true)
	
	final_position = Vector2(get_viewport().size.x / 2, 20)
	hiding_position = Vector2(get_viewport().size.x / 2, -bar.rect_size.y)
	
	bar.value = Player.current_health
	
	bar.max_value = Player.max_health
	position = hiding_position

	timer.set_wait_time(time_to_wait)
	timer.set_one_shot(true)
	

func on_health_bar_update(val, max_val):
	bar.value = val
	bar.max_value = max_val
	
	if !is_animating and val != max_val:
		#tween.stop_all()
		starting_position = position
		is_animating = true
		tween.interpolate_property(self, 'global_position', starting_position, Vector2(get_viewport().size.x / 2, 20) , 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)

		tween.start()
		yield(tween, "tween_completed")
		
		is_animating = false
		
	if val >= max_val and timer.time_left == 0:
		timer.start()   
	

func _exit_tree():
	emit_signal("health_bar_ready", false)

func _on_FullHealthTimer_timeout():
	if bar.max_value == bar.value and position != hiding_position:
		is_animating = true
		
		tween.interpolate_property(self, 'global_position', position, hiding_position, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		is_animating = false

