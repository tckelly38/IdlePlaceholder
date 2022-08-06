extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var xp_label = get_node("XPLabel")
onready var tween = get_node("LabelTween")
var max_size = Vector2(1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	var error_code = Player.connect("level_up", get_node("/root/FarmArea1/Panel/Position2D"), "on_level_up")
	if error_code:
		print("Error: error connecting to level_up")
	xp_label.text = str(Player.level)

func on_level_up():
	xp_label.text = str(Player.level)
	#tween.interpolate_property(self, 'scale', Vector2(0, 0), max_size, 4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	#tween.interpolate_property(self, 'scale', max_size, Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)

	tween.interpolate_property(self, 'scale', Vector2(0, 0), max_size, 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

