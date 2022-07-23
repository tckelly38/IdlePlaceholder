extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var xp_label = get_node("XPLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	xp_label.text = str(Player.level)

func on_level_up():
	xp_label.text = str(Player.level)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
