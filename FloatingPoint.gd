extends Position2D

onready var label = get_node("Label")
onready var tween = get_node("Tween")
var content:= String()
var velocity = Vector2(0, 0)
var max_size = Vector2(1, 1)
var custom_color:=String()
signal floating_text_finished_animating

var type = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_text(content)
	if custom_color.empty():
		match type:
			"Damage":
				label.set("custom_colors/font_color", Color('ff6633'))
			"Critical":
				label.set("custom_colors/font_color", Color('ffff33'))
				max_size = Vector2(2.0, 2.0)
			"Neutral":
				label.set("custom_colors/font_color", Color('cfab51'))
	else:
		label.set("custom_colors/font_color", Color(custom_color))
				
			
	
	randomize()
	var side_movement = randi() % 121 - 60
	velocity = Vector2(side_movement, 50)
	
	tween.interpolate_property(self, 'scale', scale, max_size, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	tween.interpolate_property(self, 'scale', max_size, Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	tween.start()
	

func _on_Tween_tween_all_completed():
	emit_signal("floating_text_finished_animating")
	set_process(false)
	self.queue_free()
	
func _process(delta):
	position -= velocity * delta
