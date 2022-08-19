extends Node2D

signal item_clicked
var my_item: LootItem = null
var floating_text = preload("res://FloatingPoint.tscn")

func _ready():
	var obj = get_node("/root/FarmArea1/ObjContainer")
	if obj.has_method("on_item_picked_up"):
		var error_code = connect("item_clicked", get_node("/root/FarmArea1/ObjContainer"), "on_item_picked_up")
		if error_code:
			print("Error: error unable to connect to ObjContainer from drop")
	var error_code = connect("item_clicked", Player, "on_item_picked_up")
	if error_code:
		print("Error: error unable to connect to player from drop")
	


func spawn_resource(item):
	my_item = item

	if !my_item.sprite_source:
		return
	
	# check if sprite source exists
	var sprite_file = File.new()
	if !sprite_file.file_exists(my_item.sprite_source):
		return
	
		
	$Sprite.texture = load(my_item.sprite_source)
	$Button.rect_size.x = $Sprite.get_rect().size.x
	$Button.rect_size.y = $Sprite.get_rect().size.y
	
	if my_item.is_animated:
		$Sprite.hframes = my_item.h_frames        
		$Sprite.vframes = my_item.v_frames

		var defaultAnim = Animation.new()
		defaultAnim.add_track(0)
		defaultAnim.length = 0.1 * (my_item.total_frames)
		
		var path = "Sprite:frame"
		defaultAnim.track_set_path(0, path)
		for i in range(my_item.total_frames):
			defaultAnim.track_insert_key(0, i * 0.1, i)

		defaultAnim.value_track_set_update_mode(0, Animation.UPDATE_DISCRETE)
		defaultAnim.loop = true
		
		var aPlayer = AnimationPlayer.new()
		aPlayer.add_animation("default", defaultAnim)
		add_child(aPlayer)
		aPlayer.set_current_animation("default")
		aPlayer.play("default")
		
func on_floating_text_finished_animating():
	set_process(false)
	get_tree().queue_delete(self)
	
func _on_Button_pressed():
	var text = floating_text.instance()
	text.content = "+1"
	text.type = "Neutral"
	text.custom_color = "d4af37"
	add_child(text)
	text.connect("floating_text_finished_animating", self, "on_floating_text_finished_animating")
	emit_signal("item_clicked", my_item)
	$Sprite.visible = false
	$Button.disabled = true

