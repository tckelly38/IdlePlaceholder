extends Control

const Enemy = preload("res://enemy.tscn")
onready var timer = get_node("SlimeEnemyTimer")
signal enemy_spawned
const bg_colors = ["eeffed", "d7eed2", "b8e4c0", "acd2bd", "5a8994"]
var objectives_complete = 0
onready var loot_table := LootDropResource.new()


var arrow = preload("res://arrow.png")
var arrow_sprite = Sprite.new()
const DropResource = preload("res://loot_table/DropResources/DropResource.tscn")


func _ready():
	Player.visible = true
	VisualServer.set_default_clear_color(Color(bg_colors[objectives_complete]))

	var e = Enemy.instance()
	timer.set_wait_time(e.spawn_rate)
	timer.set_one_shot(false)
	timer.start()
	
	get_node("collision_Wall").position.x = Player.position.x
	get_node("collision_Wall").position.y = Player.position.y
	
	#this doesn't appear to do anything
	get_node("collision_Wall").scale.x = rect_scale.x
	get_node("collision_Wall").scale.y = rect_scale.y
	arrow_sprite.texture = arrow
	arrow_sprite.position.x = get_viewport().size.x - 50
	arrow_sprite.position.y = get_viewport().size.y / 2
	arrow_sprite.visible = false
	arrow_sprite.modulate = Color.aqua
	add_child(arrow_sprite)

	
func _process(_delta):
	self.get_node("ParallaxBackground/BackParallaxLayer").motion_mirroring.x = get_viewport().size.x
	self.get_node("ParallaxBackground/MiddleParallaxLayer").motion_mirroring.x = get_viewport().size.x
	self.get_node("ParallaxBackground/FrontParallaxLayer").motion_mirroring.x = get_viewport().size.x
	
	self.get_node("ParallaxBackground/BackParallaxLayer").motion_offset.x += -1
	self.get_node("ParallaxBackground/MiddleParallaxLayer").motion_offset.x += -1
	self.get_node("ParallaxBackground/FrontParallaxLayer").motion_offset.x += -1
	
#	get_node("collision_Wall").position.x = Player.position.x
#	get_node("collision_Wall").position.y = Player.position.y
#	get_node("collision_Wall").scale.x = rect_scale.x
#	get_node("collision_Wall").scale.y = rect_scale.y

func _on_Back_pressed():
	var error_code = get_tree().change_scene("res://MainMenu.tscn")
	if error_code:
		print("Error: unable to locate MainMenu")

func spawn_enemy(pos):
	var e = Enemy.instance()
	e.position = pos
	add_child(e)
	emit_signal("enemy_spawned")

func _on_spawn_enemy(pos):
	spawn_enemy(pos)

func _on_SlimeEnemyTimer_timeout():
	var pos = Player.position

	pos.y = rand_range(get_node("ObjContainer").rect_size.y + 5, get_viewport().size.y - 10)
	pos.x = get_viewport().size.x - 100
	spawn_enemy(pos)

func add_arrow():
	arrow_sprite.visible = true
	arrow_sprite.scale = Vector2(1, 1)
	var tween = get_tree().create_tween()
	tween.tween_callback(arrow_sprite, "set_modulate", [Color.lightseagreen]).set_delay(0.5)
	tween.tween_callback(arrow_sprite, "set_modulate", [Color.aqua]).set_delay(0.5)
	tween.set_loops()
	
func remove_arrow():
	var tween = get_tree().create_tween()
	tween.tween_property(arrow_sprite, "scale", Vector2(), 1)
	arrow_sprite.visible = false
	
func simulate_end():
	remove_arrow()
	get_tree().call_group("enemies", "queue_free")
	objectives_complete += 1
	if(objectives_complete < bg_colors.size()):
		VisualServer.set_default_clear_color(Color(bg_colors[objectives_complete]))
	
func on_objective_finished_start():
	add_arrow()
	
func on_enemy_death(_xp, pos):
	var item = loot_table.get_reward()
	if item:
		var drop_res = DropResource.instance()
		drop_res.rect_position = pos
		drop_res.spawn_resource(item.item_name)
		add_child(drop_res)
	
func on_objective_finished(_reward):
	# we need to despawn enemies,  transition out, animate player spawning in
	# pause timer to prevent spawning
	timer.stop()
	simulate_end()
	timer.start()
