extends Node2D


var gold_texture = preload("res://loot_table/DropResources/gold_sprite.png")
var animated_gold: Texture = preload("res://loot_table/DropResources/MonedaD.png")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func spawn_resource(type):
	if type == "gold":
		$Sprite.hframes = 5           
		$Sprite.vframes = 1
		$Sprite.texture = animated_gold
		$Button.rect_size.x = $Sprite.get_rect().size.x
		$Button.rect_size.y = $Sprite.get_rect().size.y
		var defaultAnim = Animation.new()
		defaultAnim.add_track(0)
		defaultAnim.length = 0.5
		
		var path = String(get_node(".").get_path()) + "Sprite:frame"
		defaultAnim.track_set_path(0, path)
		defaultAnim.track_insert_key(0, 0.0, 0)
		defaultAnim.track_insert_key(0, 0.1, 1)
		defaultAnim.track_insert_key(0, 0.2, 2)
		defaultAnim.track_insert_key(0, 0.3, 3)
		defaultAnim.track_insert_key(0, 0.4, 4)
		defaultAnim.value_track_set_update_mode(0, Animation.UPDATE_DISCRETE)
		defaultAnim.loop = true
		
		var aPlayer = AnimationPlayer.new()
		aPlayer.add_animation("default", defaultAnim)
		add_child(aPlayer)
		aPlayer.set_current_animation("default")
		aPlayer.play("default")

		

		#self.texture_normal = gold_texture
		#sprite.position = pos

		
#func _unhandled_input(event):
#	if event is InputEventMouseButton and event.is_pressed() and not event.is_echo() and event.button_index == BUTTON_LEFT:
#		if get_rect().has_point(event.position):
#			print("clicked")
#			get_tree().set_input_as_handled()
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


func _on_Button_pressed():
	print("clicked")
	pass # Replace with function body.
