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
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("health_bar_ready", Player, "on_health_bar_ready")
	Player.connect("update_health", self, "on_health_bar_update")
	emit_signal("health_bar_ready", true)
	
	#final_position = Vector2(get_viewport().size.x / 2, 20)
	hiding_position = Vector2(get_viewport().size.x / 2, -bar.rect_size.y)
	
	bar.value = Player.current_health
	
	bar.max_value = Player.max_health
	position = hiding_position
	
	
func _process(delta):
	#if we are at full health and the bar is displayed in the final position then go ahead and wait and hide it
	if Player.current_health == Player.max_health and final_position.y == position.y and !is_animating:
		is_animating = true
		# we want to keep the life bar out for 10 seconds until putting away
		tween.interpolate_property(self, 'global_position', Vector2(get_viewport().size.x / 2, 20), Vector2(get_viewport().size.x / 2, 20) , 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		
		tween.start()
		yield(tween, "tween_completed")
		

		tween.interpolate_property(self, 'global_position', Vector2(get_viewport().size.x / 2, 20), hiding_position, 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		is_animating = false

func on_health_bar_update(val, max_val):
	bar.value = val
	bar.max_value = max_val

	
	if !is_animating and val != max_val:
		#tween.stop_all()
		starting_position = position
		is_animating = true
		tween.interpolate_property(self, 'global_position', starting_position, Vector2(get_viewport().size.x / 2, 20) , 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN)

		tween.start()
		yield(tween, "tween_completed")
		
		# we want to keep the life bar out for 10 seconds until putting away
		tween.interpolate_property(self, 'global_position', Vector2(get_viewport().size.x / 2, 20), Vector2(get_viewport().size.x / 2, 20) , 2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		
		tween.start()
		yield(tween, "tween_completed")

		is_animating = false
	

func _exit_tree():
	emit_signal("health_bar_ready", false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
