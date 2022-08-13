extends TextureButton


var gold_texture = preload("res://loot_table/DropResources/gold_sprite.png")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func spawn_resource(type):
	if type == "gold":
		self.texture_normal = gold_texture
		#sprite.position = pos
		visible = true

		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed() and not event.is_echo() and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(event.position):
			print("clicked")
			get_tree().set_input_as_handled()
	# we get a string, like gold
	# we load up a gold resource?, spawn it at pos (likely where enemy died)
	# make it clickable
	# register click
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_Area2D_pressed():
	print("clicked")
	pass # Replace with function body.
