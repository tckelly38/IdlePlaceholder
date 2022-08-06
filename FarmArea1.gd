extends Control

const Enemy = preload("res://enemy.tscn")
onready var timer = get_node("SlimeEnemyTimer")
signal enemy_spawned

func _ready():
	Player.visible = true

	var e = Enemy.instance()
	timer.set_wait_time(e.spawn_rate)
	timer.set_one_shot(false)
	timer.start()
	
	get_node("collision_Wall").position.x = Player.position.x
	get_node("collision_Wall").position.y = Player.position.y
	
	#this doesn't appear to do anything
	get_node("collision_Wall").scale.x = rect_scale.x
	get_node("collision_Wall").scale.y = rect_scale.y
	
func _process(_delta):
	pass
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
