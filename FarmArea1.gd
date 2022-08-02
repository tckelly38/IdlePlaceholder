extends Control

const Enemy = preload("res://enemy.tscn")
const ObjectiveContainer = preload("res://ObjContainer.gd")
signal enemy_spawned

func _ready():
	Player.visible = true
	var timer = get_node("SlimeEnemyTimer")
	var e = Enemy.instance()
	timer.set_wait_time(e.spawn_rate)
	timer.set_one_shot(false)
	timer.start()

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
	pos.y += rand_range(get_viewport().size.y / - 2 + 10, get_viewport().size.y / 2 - 10)
	pos.x = get_viewport().size.x - 100
	spawn_enemy(pos)
