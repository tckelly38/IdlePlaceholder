extends Control

const Enemy = preload("res://enemy.tscn")
# Called when the node enters the scene tree for the first time.

func _ready():
	Player.visible = true
	var timer = get_node("SlimeEnemyTimer")
	var e = Enemy.instance()
	timer.set_wait_time(e.spawn_rate)
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()

func _on_Back_pressed():
	get_tree().change_scene("res://MainMenu.tscn")

func spawn_enemy(pos):
	var e = Enemy.instance()
	e.position = pos
	add_child(e)

func _on_spawn_enemy(pos):
	spawn_enemy(pos)

func _on_SlimeEnemyTimer_timeout():
	var pos = Player.position

	pos.y = rand_range(get_node("ObjContainer").rect_size.y + 5, get_viewport().size.y - 10)
	pos.x = get_viewport().size.x - 100
	spawn_enemy(pos)
