extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	rect_size.x = get_node("%LevelPanel").rect_size.x
#	rect_size.y = get_node("%LevelPanel").rect_size.y / 3
#	rect_position.x = get_node("%LevelPanel").rect_position.x
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#TODO: terribly inefficient, need to just do once when we know LevelPanel has spawned (signal perhaps?)
	var y = get_node("%LevelPanel").rect_position.y - rect_size.y - 2
	rect_position.y = y
#	pass
