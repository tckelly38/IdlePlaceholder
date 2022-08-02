extends Position2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var xp_label = get_node("XPLabel")
onready var tween = get_node("LabelTween")
var max_size = Vector2(1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	xp_label.text = str(Player.level)

func on_level_up():
	xp_label.text = str(Player.level)
	tween.interpolate_property(self, 'scale', Vector2(0, 0), max_size, 1.1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_property(self, 'rotation_degrees', 0.0, 720.0, 1,1, Tween.TRANS_LINEAR, Tween.EASE_IN)


	tween.start()

